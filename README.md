# TVOS-Standards

可复用的 tvOS 26 产品设计、Siri Remote 交互、SwiftUI 工程协作与 App Store 发布规范。

## 设计目标

- 一份中央规范，多项目复用。
- 安装时复制文件，不使用符号链接，避免规范更新意外影响正在开发的项目。
- 初始化默认不覆盖已有项目文件。
- 规范升级可审查 diff，再决定是否合并。
- 兼容 Codex、Claude Code、Cursor 等 AI 编程工具；具体工具只会自动读取其支持的规则入口，不能假设它们会自动读取所有 Markdown。

## 目录

- `core/AGENTS.md`：AI 协作的核心执行规则。
- `specs/TVOS-DESIGN-SYSTEM.md`：视觉与设计系统规范。
- `specs/TVOS-INTERACTION-SPEC.md`：Siri Remote、焦点与播放交互规范。
- `specs/TVOS-RELEASE-CHECKLIST.md`：质量门禁与发布检查清单。
- `templates/AGENTS.md`：项目级 AI 规则模板。
- `templates/CLAUDE.md`：Claude Code 入口模板。
- `templates/TVOS-PRODUCT-DESIGN-BASELINE.md`：产品专属设计基线模板。
- `scripts/install.sh`：安全初始化项目。
- `scripts/update.sh`：更新规范副本；默认只展示差异，不直接覆盖。
- `prompts/TVOS-STANDARDS-AUDIT.md`：AI 合规审计提示词。

## 快速开始

```bash
git clone <your-standards-repo-url> ~/Developer/TVOS-Standards
cd ~/Developer/TVOS-Standards
chmod +x scripts/*.sh
./scripts/install.sh /path/to/YourTVOSApp
```

如果规范仓库已经在本机：

```bash
~/Developer/TVOS-Standards/scripts/install.sh ~/Developer/BinGo
```

初始化会复制规范文件，并且不会覆盖已有的 `AGENTS.md`、`CLAUDE.md`、设计基线或规范文档。

## 更新规范

先预览：

```bash
./scripts/update.sh /path/to/YourTVOSApp
```

预览无误后再应用：

```bash
./scripts/update.sh /path/to/YourTVOSApp --apply
```

更新脚本会先备份目标文件到 `.tvos-standards-backup/<timestamp>/`，然后更新标准文档。项目的 `AGENTS.md`、`CLAUDE.md` 和产品设计基线不会被自动覆盖。

## 建议的项目结构

```text
YourTVOSApp/
├── AGENTS.md
├── CLAUDE.md
├── TVOS-STANDARDS-VERSION
├── TVOS-DESIGN-SYSTEM.md
├── TVOS-INTERACTION-SPEC.md
├── TVOS-RELEASE-CHECKLIST.md
├── TVOS-PRODUCT-DESIGN-BASELINE.md
└── ...
```

## 版本策略

- 变更规范时更新 `VERSION`，使用语义化版本号。
- 项目中的 `TVOS-STANDARDS-VERSION` 记录安装/更新时的版本。
- 更新前查看 `git diff` 或脚本输出，避免把项目专属约束混进通用规范。
- 规范升级后运行 AI 审计提示词，并执行项目自己的构建和测试。

## 重要约定

规范是工程约束，不代表所有项目必须采用相同的业务 UI。项目设计基线应明确品牌、内容类型、导航结构、色彩倾向、媒体策略和差异化需求。

## Cursor 规则（可选）

安装后可将 `templates/cursor-rules.mdc` 复制到项目的 `.cursor/rules/tvos-standards.mdc`。根据当前 Cursor 版本检查其规则文件格式与作用范围；不要依赖工具自动读取未声明的规则文件。
