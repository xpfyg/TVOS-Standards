#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="${1:-}"
MODE="${2:-}"

if [[ -z "$TARGET" ]]; then
  echo "用法: $0 /path/to/tvOS-project [--apply]" >&2
  exit 2
fi
TARGET="$(cd "$TARGET" && pwd)"
VERSION="$(cat "$ROOT_DIR/VERSION" 2>/dev/null || echo unknown)"
FILES=(
  "TVOS-CORE-AGENTS.md|$ROOT_DIR/core/AGENTS.md"
  "TVOS-DESIGN-SYSTEM.md|$ROOT_DIR/specs/TVOS-DESIGN-SYSTEM.md"
  "TVOS-INTERACTION-SPEC.md|$ROOT_DIR/specs/TVOS-INTERACTION-SPEC.md"
  "TVOS-RELEASE-CHECKLIST.md|$ROOT_DIR/specs/TVOS-RELEASE-CHECKLIST.md"
)

if [[ "$MODE" != "--apply" ]]; then
  echo "预览模式：只显示差异，不修改文件。使用 --apply 才会应用。"
  for item in "${FILES[@]}"; do
    dest="${item%%|*}"
    src="${item#*|}"
    echo
    echo "===== $dest ====="
    if [[ -f "$TARGET/$dest" ]]; then
      diff -u "$TARGET/$dest" "$src" || true
    else
      echo "目标文件不存在，将新增。"
      diff -u /dev/null "$src" || true
    fi
  done
  echo
  echo "项目级 AGENTS.md、CLAUDE.md 和产品设计基线不会被更新脚本覆盖。"
  exit 0
fi

STAMP="$(date '+%Y%m%d-%H%M%S')"
BACKUP="$TARGET/.tvos-standards-backup/$STAMP"
mkdir -p "$BACKUP"

for item in "${FILES[@]}"; do
  dest="${item%%|*}"
  src="${item#*|}"
  if [[ -f "$TARGET/$dest" ]]; then
    cp "$TARGET/$dest" "$BACKUP/$dest"
  fi
  cp "$src" "$TARGET/$dest"
  echo "已更新: $dest"
done

printf '%s\n' "$VERSION" > "$TARGET/TVOS-STANDARDS-VERSION"
echo "已更新版本记录: $VERSION"
echo "备份目录: $BACKUP"
echo "完成。请复核项目规则入口是否引用了新规范。"
