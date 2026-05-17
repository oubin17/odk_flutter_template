# Spring Boot 集成阿里云 OSS 完整指南

> 适用于头像存储、文件上传等场景，基于 Spring Boot + 阿里云 OSS SDK

---

## 目录

- [一、为什么选择 OSS 而不是本地存储](#一为什么选择-oss-而不是本地存储)
- [二、前置准备](#二前置准备)
- [三、Maven 依赖](#三maven-依赖)
- [四、配置文件](#四配置文件)
- [五、OSS 配置类](#五oss-配置类)
- [六、OSS 服务封装](#六oss-服务封装)
- [七、头像上传接口](#七头像上传接口)
- [八、OSS 目录规范（最佳实践）](#八oss-目录规范最佳实践)
- [九、数据库存储设计](#九数据库存储设计)
- [十、OSS 生命周期规则](#十oss-生命周期规则)
- [十一、安全最佳实践](#十一安全最佳实践)
- [十二、图片处理（OSS 自带能力）](#十二图片处理oss-自带能力)
- [十三、完整流程总结](#十三完整流程总结)

---

## 一、为什么选择 OSS 而不是本地存储

### 方案对比

| 对比项 | ECS 本地存储 | 阿里云 OSS |
|--------|-------------|-----------|
| 数据持久性 | 依赖磁盘，易丢失 | 99.9999999999% 持久性 |
| 存储成本 | ECS 磁盘较贵 | 约 0.12 元/GB/月 |
| 扩展性 | 磁盘容量有限 | 无限扩展 |
| CDN 加速 | 不便接入 | 天然支持 |
| 备份 | 需自行实现 | 自动冗余 |
| 多实例部署 | 文件不共享 | 天然共享 |
| 运维复杂度 | 需关注磁盘/备份 | 零运维 |

### 结论

**头像属于用户核心数据，不能丢**。OSS 集成成本低、费用极低（1000 用户头像每月不到 0.03 元），建议直接使用 OSS。

---

## 二、前置准备

1. 登录 [阿里云 OSS 控制台](https://oss.console.aliyun.com/)
2. 创建 Bucket（建议选择与 ECS 同地域，如 `华东2-上海`）
3. 存储类型选**标准存储**，读写权限选**私有**（通过签名 URL 访问）
4. 获取 AccessKey ID 和 AccessKey Secret（建议使用 RAM 子账号，仅授权 OSS 权限）

---

## 三、Maven 依赖

```xml
<!-- 阿里云 OSS SDK -->
<dependency>
    <groupId>com.aliyun.oss</groupId>
    <artifactId>aliyun-sdk-oss</artifactId>
    <version>3.17.4</version>
</dependency>

<!-- 可选：如果用 STS 临时凭证 -->
<dependency>
    <groupId>com.aliyun</groupId>
    <artifactId>alibabacloud-sts20150401</artifactId>
    <version>1.0.1</version>
</dependency>
```

---

## 四、配置文件

### application.yml

```yaml
aliyun:
  oss:
    endpoint: oss-cn-shanghai.aliyuncs.com    # 根据你的地域修改
    access-key-id: ${OSS_ACCESS_KEY_ID}        # 建议用环境变量
    access-key-secret: ${OSS_ACCESS_KEY_SECRET}
    bucket-name: your-bucket-name
    # 自定义域名（可选，如果绑定了 CDN 域名）
    custom-domain: https://cdn.yourdomain.com
    # 签名 URL 过期时间（秒）
    sign-url-expiration: 3600
```

> ⚠️ **安全提示**：AccessKey 不要硬编码在代码或配置文件中，使用环境变量或配置中心（如 Nacos）注入。

---

## 五、OSS 配置类

```java
@Data
@Component
@ConfigurationProperties(prefix = "aliyun.oss")
public class OssProperties {
    private String endpoint;
    private String accessKeyId;
    private String accessKeySecret;
    private String bucketName;
    private String customDomain;
    private Integer signUrlExpiration = 3600;
}
```

---

## 六、OSS 服务封装

```java
@Slf4j
@Service
public class OssService {

    @Autowired
    private OssProperties ossProperties;

    /**
     * 上传文件 - 返回文件的 objectKey
     */
    public String upload(String objectKey, InputStream inputStream, String contentType) {
        OSS ossClient = createClient();
        try {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentType(contentType);
            // 不缓存原图，避免更新后看到旧图
            metadata.setCacheControl("no-cache");

            PutObjectResult result = ossClient.putObject(
                ossProperties.getBucketName(), objectKey, inputStream, metadata
            );
            log.info("文件上传成功, objectKey={}, etag={}", objectKey, result.getETag());
            return objectKey;
        } catch (OSSException | ClientException e) {
            log.error("文件上传失败, objectKey={}", objectKey, e);
            throw new RuntimeException("文件上传失败", e);
        } finally {
            ossClient.shutdown();
        }
    }

    /**
     * 删除文件
     */
    public void delete(String objectKey) {
        OSS ossClient = createClient();
        try {
            ossClient.deleteObject(ossProperties.getBucketName(), objectKey);
            log.info("文件删除成功, objectKey={}", objectKey);
        } catch (OSSException | ClientException e) {
            log.error("文件删除失败, objectKey={}", objectKey, e);
            throw new RuntimeException("文件删除失败", e);
        } finally {
            ossClient.shutdown();
        }
    }

    /**
     * 获取签名访问 URL（Bucket 为私有时使用）
     */
    public String getSignedUrl(String objectKey) {
        OSS ossClient = createClient();
        try {
            Date expiration = new Date(System.currentTimeMillis()
                + ossProperties.getSignUrlExpiration() * 1000L);
            return ossClient.generatePresignedUrl(
                ossProperties.getBucketName(), objectKey, expiration
            ).toString();
        } finally {
            ossClient.shutdown();
        }
    }

    /**
     * 获取公开访问 URL（如果绑定了自定义域名）
     */
    public String getPublicUrl(String objectKey) {
        if (StringUtils.hasText(ossProperties.getCustomDomain())) {
            return ossProperties.getCustomDomain() + "/" + objectKey;
        }
        return "https://" + ossProperties.getBucketName() + "."
            + ossProperties.getEndpoint() + "/" + objectKey;
    }

    private OSS createClient() {
        return new OSSClientBuilder().build(
            ossProperties.getEndpoint(),
            ossProperties.getAccessKeyId(),
            ossProperties.getAccessKeySecret()
        );
    }
}
```

---

## 七、头像上传接口

```java
@RestController
@RequestMapping("/api/user")
public class AvatarController {

    @Autowired
    private OssService ossService;

    @Autowired
    private UserService userService;

    /**
     * 上传头像
     */
    @PostMapping("/avatar")
    public ApiResponse<String> uploadAvatar(
            @RequestParam("file") MultipartFile file,
            @AuthenticationPrincipal Long userId) {

        // 1. 校验文件
        validateAvatar(file);

        // 2. 生成 objectKey
        String objectKey = OssPathBuilder.avatar(userId, file.getOriginalFilename());

        // 3. 上传到 OSS
        try (InputStream inputStream = file.getInputStream()) {
            ossService.upload(objectKey, inputStream, file.getContentType());
        } catch (IOException e) {
            throw new RuntimeException("文件读取失败", e);
        }

        // 4. 删除旧头像
        String oldAvatarKey = userService.getAvatarKey(userId);
        if (StringUtils.hasText(oldAvatarKey)) {
            ossService.delete(oldAvatarKey);
        }

        // 5. 更新数据库（存 objectKey，不是完整 URL）
        String avatarUrl = ossService.getPublicUrl(objectKey);
        userService.updateAvatar(userId, objectKey, avatarUrl);

        return ApiResponse.success(avatarUrl);
    }

    /**
     * 获取头像签名 URL
     */
    @GetMapping("/avatar/url")
    public ApiResponse<String> getAvatarUrl(@AuthenticationPrincipal Long userId) {
        String avatarKey = userService.getAvatarKey(userId);
        if (StringUtils.isBlank(avatarKey)) {
            return ApiResponse.success(null);
        }
        return ApiResponse.success(ossService.getSignedUrl(avatarKey));
    }

    private void validateAvatar(MultipartFile file) {
        // 文件大小限制 2MB
        if (file.getSize() > 2 * 1024 * 1024) {
            throw new BusinessException("头像文件不能超过2MB");
        }
        // 文件类型校验
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new BusinessException("只能上传图片文件");
        }
        // 允许的图片格式
        String suffix = FileUtil.getExtension(file.getOriginalFilename());
        List<String> allowedSuffixes = List.of("jpg", "jpeg", "png", "webp");
        if (!allowedSuffixes.contains(suffix.toLowerCase())) {
            throw new BusinessException("仅支持 jpg/jpeg/png/webp 格式");
        }
    }
}
```

---

## 八、OSS 目录规范（最佳实践）

### 路径构建工具类

```java
public class OssPathBuilder {

    /**
     * 头像目录规范
     * 格式: avatar/{userId}/{yyyyMMddHHmmss}_{random6}.{ext}
     *
     * 示例: avatar/10001/20260515150900_a3f8k2.jpg
     */
    public static String avatar(Long userId, String originalFilename) {
        String ext = getExtension(originalFilename);
        String timestamp = LocalDateTime.now().format(
            DateTimeFormatter.ofPattern("yyyyMMddHHmmss")
        );
        String random = RandomStringUtils.randomAlphanumeric(6);
        return String.format("avatar/%d/%s_%s.%s", userId, timestamp, random, ext);
    }

    /**
     * 通用文件目录规范
     * 格式: {bizType}/{yyyy/MM/dd}/{randomId}.{ext}
     *
     * 示例: resume/2026/05/15/a3f8k2m9x1.pdf
     */
    public static String file(String bizType, String originalFilename) {
        String ext = getExtension(originalFilename);
        String datePath = LocalDate.now().format(
            DateTimeFormatter.ofPattern("yyyy/MM/dd")
        );
        String randomId = RandomStringUtils.randomAlphanumeric(10);
        return String.format("%s/%s/%s.%s", bizType, datePath, randomId, ext);
    }

    private static String getExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "bin";
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }
}
```

### 目录结构总览

```
bucket-root/
├── avatar/                          # 头像
│   ├── 10001/                       # 按用户ID分目录
│   │   ├── 20260515150900_a3f8k2.jpg
│   │   └── 20260520100000_x9m2p1.png   # 更换后的新头像
│   └── 10002/
│       └── 20260518143000_b7n4q5.jpg
├── resume/                          # 简历文件
│   └── 2026/
│       └── 05/
│           └── 15/
│               ├── a3f8k2m9x1.pdf
│               └── k7j3h5n2w8.docx
├── id-card/                         # 身份证照片
│   └── 10001/
│       ├── front_20260515.jpg
│       └── back_20260515.jpg
└── temp/                            # 临时文件（设置生命周期自动清理）
    └── upload/
        └── 2026/
            └── 05/
                └── 15/
                    └── abc123.jpg
```

### 目录命名规范要点

| 规则 | 说明 | 示例 |
|------|------|------|
| 全小写 | OSS objectKey 区分大小写，统一小写避免混乱 | `avatar` 而非 `Avatar` |
| 短横线分隔 | 业务词之间用 `-` 连接 | `id-card` 而非 `idCard` |
| 按用户分目录 | 头像等用户级文件按 userId 分目录 | `avatar/10001/` |
| 按日期分目录 | 通用文件按日期归档，便于清理 | `resume/2026/05/15/` |
| 文件名含时间戳+随机串 | 防止重名覆盖 | `20260515150900_a3f8k2.jpg` |
| 不用原始文件名 | 避免中文/特殊字符/信息泄露 | ✅ `a3f8k2m9x1.pdf` ❌ `张三的简历.pdf` |

---

## 九、数据库存储设计

### 表结构

```sql
-- 用户表头像相关字段
ALTER TABLE user ADD COLUMN avatar_key VARCHAR(255) COMMENT 'OSS对象键(objectKey)';
ALTER TABLE user ADD COLUMN avatar_url  VARCHAR(512) COMMENT '头像访问URL（冗余字段，方便查询）';
```

### ⚠️ 关键原则

**数据库中必须存 objectKey**（如 `avatar/10001/20260515150900_a3f8k2.jpg`），而不是完整 URL。

原因：
- 域名可能变更（换 CDN、换 Bucket）
- 签名 URL 有时效性，不能持久化
- objectKey 是 OSS 操作（删除、替换）的唯一标识

---

## 十、OSS 生命周期规则

在 OSS 控制台配置生命周期规则：

| 前缀 | 过期时间 | 说明 |
|------|---------|------|
| `temp/` | 30 天 | 临时文件自动清理 |
| `avatar/` | 不过期 | 头像永久保存 |
| `resume/` | 不过期 | 简历永久保存 |

配置路径：OSS 控制台 → Bucket → 数据管理 → 生命周期

---

## 十一、安全最佳实践

### 1. 使用 RAM 子账号

为应用创建专用 RAM 子账号，仅授予必要的 OSS 权限：

```json
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "oss:PutObject",
        "oss:GetObject",
        "oss:DeleteObject"
      ],
      "Resource": [
        "acs:oss:*:*:your-bucket-name/avatar/*",
        "acs:oss:*:*:your-bucket-name/resume/*"
      ]
    }
  ],
  "Version": "1"
}
```

### 2. 上传方案对比

| 方案 | 适用场景 | 说明 |
|------|---------|------|
| **服务端上传** | 文件需校验/处理 | 客户端 → 服务端 → OSS，简单但占服务端带宽 |
| **客户端直传（STS）** | 大文件/高并发 | 客户端获取 STS 临时凭证后直传 OSS，服务端不中转 |
| **客户端直传（签名URL）** | 中小文件 | 服务端生成 PostObject 签名策略，客户端直传 |

**头像场景建议**：文件小（< 2MB），直接用**服务端上传**即可，简单可靠。

### 3. STS 客户端直传（大文件场景）

如果后续有大量图片上传需求，可切换为 STS 客户端直传：

```java
// STS 临时凭证获取示例
public StsToken getStsToken() {
    DefaultProfile profile = DefaultProfile.getProfile(
        "cn-shanghai", ossProperties.getAccessKeyId(), ossProperties.getAccessKeySecret()
    );
    IAcsClient client = new DefaultAcsClient(profile);

    AssumeRoleRequest request = new AssumeRoleRequest();
    request.setRoleArn("acs:ram::your-account-id:role/oss-upload");
    request.setRoleSessionName("app-upload");
    request.setDurationSeconds(3600L); // 1小时有效

    AssumeRoleResponse response = client.getAcsResponse(request);
    return new StsToken(
        response.getCredentials().getAccessKeyId(),
        response.getCredentials().getAccessKeySecret(),
        response.getCredentials().getSecurityToken(),
        response.getCredentials().getExpiration()
    );
}
```

### 4. Bucket 安全设置

- **读写权限**：设为**私有**，通过签名 URL 或服务端代理访问
- **防盗链**：在 Bucket 设置 Referer 白名单
- **跨域设置**：如果需要前端直传，配置 CORS 规则

---

## 十二、图片处理（OSS 自带能力）

OSS 支持在 URL 上加参数实现图片处理，**无需在服务端做缩略图**：

### 常用图片处理参数

```
# 原图
https://cdn.yourdomain.com/avatar/10001/20260515150900_a3f8k2.jpg

# 缩略图 200x200（填充模式）
https://cdn.yourdomain.com/avatar/10001/20260515150900_a3f8k2.jpg?x-oss-process=image/resize,m_fill,w_200,h_200

# 缩略图 100x100（长边缩放）
https://cdn.yourdomain.com/avatar/10001/20260515150900_a3f8k2.jpg?x-oss-process=image/resize,m_lfit,w_100,h_100

# 质量压缩（节省流量）
https://cdn.yourdomain.com/avatar/10001/20260515150900_a3f8k2.jpg?x-oss-process=image/quality,q_80

# 格式转换（自动转 WebP，浏览器支持时更省流量）
https://cdn.yourdomain.com/avatar/10001/20260515150900_a3f8k2.jpg?x-oss-process=image/format,webp

# 组合使用：缩略图 + 质量压缩 + WebP
https://cdn.yourdomain.com/avatar/10001/20260515150900_a3f8k2.jpg?x-oss-process=image/resize,m_fill,w_200,h_200/quality,q_80/format,webp
```

### 图片样式分隔符配置

在 OSS 控制台可以配置样式分隔符，简化 URL：

```
# 配置分隔符为 ! 后：
https://cdn.yourdomain.com/avatar/10001/20260515150900_a3f8k2.jpg!thumb

# thumb 为自定义样式名，在控制台配置具体参数
```

---

## 十三、完整流程总结

### 客户端上传头像流程

```
1. 用户选择图片 → 压缩到 2MB 以内
2. POST /api/user/avatar (multipart/form-data)
3. 服务端校验文件类型、大小
4. 生成 objectKey: avatar/{userId}/{timestamp}_{random}.{ext}
5. 上传到 OSS
6. 删除旧头像 objectKey
7. 更新数据库 avatar_key 和 avatar_url
8. 返回头像 URL 给客户端
```

### 客户端显示头像流程

**方案 A（推荐）：Bucket 公开读 + CDN**

- 通过 Bucket Policy 仅允许 `avatar/` 前缀公开读
- 配合 CDN 加速
- 直接用 `avatar_url` 拼接图片处理参数显示
- 避免每次生成签名 URL 的开销

**方案 B：Bucket 私有**

- 调用 `GET /api/user/avatar/url` 获取签名 URL 显示
- 或在服务端返回用户信息时动态生成签名 URL
- 安全性更高，但有额外的签名计算开销

### 技术选型速查

| 场景 | 推荐方案 |
|------|---------|
| 头像存储 | OSS 标准存储 |
| 头像访问 | 公开读 + CDN（方案 A） |
| 上传方式 | 服务端上传（头像文件小） |
| 目录结构 | `avatar/{userId}/{timestamp}_{random}.{ext}` |
| 数据库存储 | 存 objectKey，不存完整 URL |
| 图片缩略图 | OSS 图片处理参数，无需自建 |
| 临时文件 | `temp/` 前缀 + 生命周期自动清理 |
| AccessKey | RAM 子账号 + 环境变量注入 |

---

> 📅 文档更新时间：2026-05-15
