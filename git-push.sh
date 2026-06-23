#!/bin/bash
# 适用于 Windows Git Bash 的一键提交脚本（带提交类型选择）

# 强制使用 UTF-8 避免中文乱码
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 检查是否在 Git 仓库中
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "错误：当前目录不是 Git 仓库！"
    read -p "按任意键退出..." -n1
    exit 1
fi

# 获取当前分支
branch=$(git symbolic-ref --short HEAD 2>/dev/null)
if [ -z "$branch" ]; then
    echo "无法获取当前分支，可能处于 detached HEAD 状态"
    read -p "按任意键退出..." -n1
    exit 1
fi
echo "当前分支: $branch"

# 检查是否有更改（包括未跟踪文件）
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "没有需要提交的更改。"
    read -p "按任意键退出..." -n1
    exit 0
fi

# ---------- 新增：选择提交类型 ----------
echo "请选择提交类型（输入数字）："
echo "  1) feat     - 新功能"
echo "  2) fix      - 修复 Bug"
echo "  3) docs     - 文档变更"
echo "  4) style    - 代码格式（不影响逻辑）"
echo "  5) refactor - 重构"
echo "  6) perf     - 性能优化"
echo "  7) test     - 测试相关"
echo "  8) chore    - 构建/工具变动"
echo "  9) 不使用前缀（自定义）"
read -p "请输入序号 (1-9，直接回车默认 9): " type_choice

# 若直接回车，默认无前缀
if [ -z "$type_choice" ]; then
    type_choice=9
fi

case $type_choice in
    1) prefix="feat: " ;;
    2) prefix="fix: " ;;
    3) prefix="docs: " ;;
    4) prefix="style: " ;;
    5) prefix="refactor: " ;;
    6) prefix="perf: " ;;
    7) prefix="test: " ;;
    8) prefix="chore: " ;;
    9) prefix="" ;;
    *) 
        echo "无效输入，将不使用前缀。"
        prefix="" ;;
esac

# ---------- 输入提交描述 ----------
echo "请输入本次更新的描述："
read commit_desc

# 如果描述为空，生成默认描述
if [ -z "$commit_desc" ]; then
    commit_desc="Update on $(date '+%Y-%m-%d %H:%M:%S')"
    echo "使用默认描述: $commit_desc"
fi

# 拼接最终提交信息
commit_message="${prefix}${commit_desc}"
echo "最终提交信息: $commit_message"

# ---------- 执行提交和推送 ----------
git add .
echo "已添加所有更改。"

git commit -m "$commit_message"
if [ $? -ne 0 ]; then
    echo "提交失败，请检查错误信息。"
    read -p "按任意键退出..." -n1
    exit 1
fi

git push origin "$branch"
if [ $? -ne 0 ]; then
    echo "推送失败，请检查网络或权限。"
    read -p "按任意键退出..." -n1
    exit 1
fi

echo "提交并推送成功！"
read -p "按任意键退出..." -n1