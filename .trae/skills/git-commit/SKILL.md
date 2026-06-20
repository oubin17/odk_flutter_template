---
name: "git-commit"
description: "根据 git 改动自动生成 commit message 并提交。Invoke when user says '提交', 'commit', 'git commit', '提交代码', '提交变更', or any request to stage and commit changes."
---

# Git Commit Skill

## 功能

根据当前工作区的 git 改动，自动分析变更内容并生成符合项目风格的 commit message，然后执行提交并推送。

## 使用流程

### 1. 检查改动

运行以下命令查看当前改动：

```bash
git status
git diff --stat
```

### 2. 安全检查（自动判断是否需要确认）

**无需确认，直接提交的情况：**
- 常规代码文件修改（`.dart`, `.js`, `.ts`, `.json`, `.md` 等）
- 新增业务组件、页面、工具类
- 样式调整、格式化
- 配置文件修改

**必须向用户确认的情况：**
- 包含敏感文件（`.env`, `*.key`, `*.pem`, `credentials.json`, `secrets.yaml` 等）
- 包含大量删除（`deletions > insertions * 3`）
- 修改了 CI/CD 配置（`.github/`, `.gitlab-ci.yml`）
- 修改了数据库迁移文件
- 包含二进制文件（`.exe`, `.dll`, `.so`）
- 权限变更（`chmod` 修改）
- 首次提交（initial commit）

### 3. 分析变更类型

根据改动内容判断 commit 类型：

| 类型 | 场景 |
|------|------|
| `feat` | 新增功能、页面、组件 |
| `fix` | 修复 bug、修复错误 |
| `docs` | 文档更新、README、注释 |
| `style` | 代码格式、样式调整、无逻辑改动 |
| `refactor` | 重构代码、优化结构 |
| `perf` | 性能优化 |
| `test` | 添加/修改测试 |
| `chore` | 构建配置、依赖更新、工具配置 |

### 4. 生成 Commit Message

遵循以下格式：

```
<type>: <subject>

<body> (可选)
```

- **subject**：简短描述（50 字符以内），使用中文或英文（与项目风格一致）
- **body**：详细说明（可选），解释改动原因和细节

### 5. 执行提交并推送

**安全检查通过时，自动执行，无需确认：**

```bash
git add -A
git commit -m "<message>"
git push
```

**安全检查未通过时，展示风险并向用户确认后再执行。**

## 注意事项

- **自动推送**：提交后自动执行 `git push`
- **无需确认**：常规改动直接提交，不打扰用户
- **风险拦截**：只有以下情况会要求确认：
  1. 包含敏感文件（`.env`, 密钥等）
  2. 大量删除操作（可能误删）
  3. CI/CD 配置变更
  4. 数据库迁移文件
  5. 二进制文件
  6. 权限变更
- **遵循项目规范**：如果项目有 `.gitmessage` 或 commitlint 配置，遵循其格式

## 示例

### 常规提交（自动执行）

用户：提交一下

AI：
1. 检查到改动：
   - `lib/pages/home.dart` 新增首页布局
   - `lib/widgets/button.dart` 添加通用按钮组件

2. 自动提交：
   ```bash
   git add -A
   git commit -m "feat: 添加首页和通用按钮组件"
   git push
   ```

3. ✅ 提交成功并已推送。

### 风险拦截（需要确认）

用户：提交一下

AI：
1. ⚠️ 检测到以下风险，需要您确认：
   - 包含敏感文件：`.env`
   - 包含大量删除：`lib/old_module/`（-500 行）

2. 是否继续提交？(是/否)
