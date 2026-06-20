---
name: "git-commit"
description: "根据 git 改动自动生成 commit message 并提交。Invoke when user says '提交', 'commit', 'git commit', '提交代码', '提交变更', or any request to stage and commit changes."
---

# Git Commit Skill

## 功能

根据当前工作区的 git 改动，自动分析变更内容并生成符合项目风格的 commit message，然后执行提交。

## 使用流程

### 1. 检查改动

先运行以下命令查看当前改动：

```bash
git status
git diff --stat
git diff HEAD
```

### 2. 分析变更类型

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

### 3. 生成 Commit Message

遵循以下格式：

```
<type>: <subject>

<body> (可选)
```

- **subject**：简短描述（50 字符以内），使用中文或英文（与项目风格一致）
- **body**：详细说明（可选），解释改动原因和细节

### 4. 用户确认

**必须**在提交前向用户展示生成的 commit message，询问是否确认提交。

### 5. 执行提交

用户确认后执行：

```bash
git add -A  # 或 git add <具体文件>
git commit -m "<message>"
```

## 注意事项

- **不自动 push**：除非用户明确要求 `push` 或 `推送`
- **不提交敏感文件**：检查是否有 `.env`、密钥等敏感文件被加入暂存区
- **遵循项目规范**：如果项目有 `.gitmessage` 或 commitlint 配置，遵循其格式
- **拆分提交**：如果改动涉及多个独立功能，建议拆分为多个 commit

## 示例交互

用户：提交一下

AI：
1. 检查到以下改动：
   - `lib/pages/home.dart` 新增首页布局
   - `lib/widgets/button.dart` 添加通用按钮组件

2. 生成 commit message：
   ```
   feat: 添加首页和通用按钮组件
   ```

3. 是否确认提交？(是/否)

用户确认后执行 `git add -A && git commit`
