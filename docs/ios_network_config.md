# iOS 网络权限配置指南

## 问题原因
iOS 9+ 引入了 App Transport Security (ATS)，默认禁止 HTTP 明文传输和本地网络访问。

## 已修复的配置

### Info.plist 配置
文件位置：`ios/Runner/Info.plist`

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

**说明：**
- `NSAllowsArbitraryLoads`: 允许所有 HTTP/HTTPS 请求（开发环境使用）
- `NSAllowsLocalNetworking`: 允许访问本地网络（iOS 14+ 必需）

## 完整配置示例

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 其他配置... -->
    
    <!-- 网络权限配置 -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsLocalNetworking</key>
        <true/>
    </dict>
</dict>
</plist>
```

## 生产环境建议

在生产环境中，应该限制 ATS 配置，只允许必要的域名：

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>your-production-domain.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.2</string>
        </dict>
    </dict>
</dict>
```

## 验证步骤

1. **修改 Info.plist 后重新构建应用**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **检查后端服务是否运行**
   ```bash
   curl http://192.25.68.206:8080/odk-base-template/api
   ```

3. **查看 Flutter 日志**
   ```bash
   flutter run --verbose
   ```

## 常见问题

### 问题 1: Operation not permitted
**原因：** 缺少 NSAllowsLocalNetworking 配置  
**解决：** 添加上述配置到 Info.plist

### 问题 2: Connection refused
**原因：** 后端服务未启动或 IP 地址错误  
**解决：** 
1. 确认后端服务运行
2. 检查 IP 地址是否正确
3. 确认防火墙未阻止连接

### 问题 3: Cleartext HTTP loads not allowed
**原因：** 使用了 HTTP 而不是 HTTPS  
**解决：** 添加 NSAllowsArbitraryLoads 或使用 HTTPS

## 当前配置状态

✅ 已配置：
- NSAllowsArbitraryLoads: true
- NSAllowsLocalNetworking: true
- baseUrl: http://192.25.68.206:8080/odk-base-template/api

适用于：iOS 模拟器、iOS 真机调试
