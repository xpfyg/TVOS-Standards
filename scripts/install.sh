#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "用法: $0 /path/to/tvOS-project" >&2
  exit 2
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
VERSION="$(cat "$ROOT_DIR/VERSION" 2>/dev/null || echo unknown)"

copy_if_missing() {
  local src="$1" dest="$2"
  if [[ ! -f "$src" ]]; then
    echo "跳过（源文件不存在）: $src" >&2
    return 0
  fi
  if [[ -e "$dest" ]]; then
    echo "保留已有文件: $dest"
  else
    cp "$src" "$dest"
    echo "已安装: $dest"
  fi
}

copy_if_missing "$ROOT_DIR/core/AGENTS.md" "$TARGET/TVOS-CORE-AGENTS.md"
copy_if_missing "$ROOT_DIR/specs/TVOS-DESIGN-SYSTEM.md" "$TARGET/TVOS-DESIGN-SYSTEM.md"
copy_if_missing "$ROOT_DIR/specs/TVOS-INTERACTION-SPEC.md" "$TARGET/TVOS-INTERACTION-SPEC.md"
copy_if_missing "$ROOT_DIR/specs/TVOS-RELEASE-CHECKLIST.md" "$TARGET/TVOS-RELEASE-CHECKLIST.md"
copy_if_missing "$ROOT_DIR/templates/TVOS-PRODUCT-DESIGN-BASELINE.md" "$TARGET/TVOS-PRODUCT-DESIGN-BASELINE.md"

if [[ ! -e "$TARGET/AGENTS.md" ]]; then
  cat > "$TARGET/AGENTS.md" <<'EOF'
# 项目 AI 开发规则

开始任务前阅读 `TVOS-PRODUCT-DESIGN-BASELINE.md`、`TVOS-DESIGN-SYSTEM.md`、`TVOS-INTERACTION-SPEC.md`、`TVOS-RELEASE-CHECKLIST.md` 和 `TVOS-CORE-AGENTS.md` 中与任务相关的内容。

遵循现有项目架构与产品基线；优先做最小必要改动。所有交互必须考虑 Siri Remote 焦点、页面返回和加载/空/错误状态。执行可用的构建与测试，并如实报告命令、结果、未执行项目和风险。不得声称通过了未实际执行的测试或真机验证。
EOF
  echo "已创建: $TARGET/AGENTS.md"
else
  echo "保留已有文件: $TARGET/AGENTS.md"
fi

if [[ ! -e "$TARGET/CLAUDE.md" ]]; then
  cp "$ROOT_DIR/templates/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "已创建: $TARGET/CLAUDE.md"
else
  echo "保留已有文件: $TARGET/CLAUDE.md"
fi

if [[ ! -e "$TARGET/TVOS-STANDARDS-VERSION" ]]; then
  printf '%s\n' "$VERSION" > "$TARGET/TVOS-STANDARDS-VERSION"
  echo "已记录规范版本: $VERSION"
else
  echo "保留已有文件: $TARGET/TVOS-STANDARDS-VERSION（当前版本 $VERSION）"
fi

echo
echo "初始化完成。请按项目需要编辑 TVOS-PRODUCT-DESIGN-BASELINE.md。"
echo "注意：Cursor 等工具可能需要在其专用规则目录配置入口；不会自动读取所有 Markdown。"
