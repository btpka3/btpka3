#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 清理 ~/.claude/skills 下指向 gstack 仓库的 SKILL.md 软链接
# 以及清理因此产生的空目录
# ============================================================

# ---- 可配置变量 ----
GSTACK_ROOT="/Users/zll/data0/work/git-repo/github/gstack"
SKILLS_DIR="$HOME/.claude/skills"

# ---- 模式参数 ----
#   --dry-run   : 仅统计报告，不执行删除（默认）
#   --execute   : 执行实际清理动作
MODE="dry-run"

for arg in "$@"; do
  case "$arg" in
    --execute) MODE="execute" ;;
    --dry-run) MODE="dry-run" ;;
    -h|--help)
      echo "用法: $0 [--dry-run|--execute]"
      echo ""
      echo "  --dry-run   仅统计报告，不删除任何文件（默认）"
      echo "  --execute   执行实际清理"
      exit 0
      ;;
    *)
      echo "未知参数: $arg" >&2
      echo "使用 --help 查看用法" >&2
      exit 1
      ;;
  esac
done

# ---- 前置检查 ----
if [ ! -d "$SKILLS_DIR" ]; then
  echo "[ERROR] skills 目录不存在: $SKILLS_DIR" >&2
  exit 1
fi

if [ ! -d "$GSTACK_ROOT" ]; then
  echo "[WARN] gstack 目录不存在: $GSTACK_ROOT" >&2
  echo "       仍将基于路径匹配清理指向该路径的软链接"
fi

echo "=========================================="
echo "  gstack SKILL.md 软链接清理工具"
echo "=========================================="
echo "gstack 目录 : $GSTACK_ROOT"
echo "skills 目录 : $SKILLS_DIR"
echo "运行模式    : $MODE"
echo "=========================================="
echo ""

# ---- 第一阶段: 查找并处理指向 gstack 的 SKILL.md 软链接 ----
symlink_count=0
symlink_list=()

while IFS= read -r -d '' link_path; do
  target=$(readlink "$link_path" 2>/dev/null || true)
  # 检查目标路径是否以 GSTACK_ROOT 开头
  if [[ "$target" == "$GSTACK_ROOT"* ]]; then
    symlink_count=$((symlink_count + 1))
    symlink_list+=("$link_path")

    if [ "$MODE" = "execute" ]; then
      rm -f "$link_path"
      echo "[DELETE] $link_path -> $target"
    else
      echo "[FOUND]  $link_path -> $target"
    fi
  fi
done < <(find "$SKILLS_DIR" -name "SKILL.md" -type l -print0 2>/dev/null)

echo ""
echo "--- 软链接统计 ---"
echo "发现指向 gstack 的 SKILL.md 软链接: $symlink_count 个"

if [ "$MODE" = "execute" ] && [ "$symlink_count" -gt 0 ]; then
  echo "状态: 已全部删除"
fi

# ---- 第二阶段: 清理空目录 ----
echo ""
echo "--- 空目录清理 ---"

empty_dir_count=0
empty_dir_list=()

# 从最深层开始向上查找空目录，避免父目录先于子目录被处理
while IFS= read -r -d '' dir_path; do
  # 跳过 skills 根目录本身
  if [ "$dir_path" = "$SKILLS_DIR" ]; then
    continue
  fi
  # 检查是否为空目录（不含任何文件/子目录）
  if [ -z "$(ls -A "$dir_path" 2>/dev/null)" ]; then
    empty_dir_count=$((empty_dir_count + 1))
    empty_dir_list+=("$dir_path")

    if [ "$MODE" = "execute" ]; then
      rmdir "$dir_path" 2>/dev/null && echo "[RMDIR]  $dir_path" || echo "[SKIP]   $dir_path (非空或已不存在)"
    else
      echo "[EMPTY]  $dir_path"
    fi
  fi
done < <(find "$SKILLS_DIR" -mindepth 1 -depth -type d -print0 2>/dev/null | sort -rz)

echo ""
echo "发现空目录: $empty_dir_count 个"

if [ "$MODE" = "execute" ] && [ "$empty_dir_count" -gt 0 ]; then
  echo "状态: 已全部删除"
fi

# ---- 汇总 ----
echo ""
echo "=========================================="
if [ "$MODE" = "dry-run" ]; then
  echo "  预览完成，未执行任何删除操作"
  echo "  确认无误后请运行: $0 --execute"
else
  echo "  清理完成！"
  echo "  删除软链接: $symlink_count 个"
  echo "  删除空目录  : $empty_dir_count 个"
fi
echo "=========================================="
