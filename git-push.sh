#!/bin/bash
# 适用于 Windows Git Bash 的一键提交脚本

# 强制使用 UTF-8 避免中文乱码（Git Bash 默认就是 UTF-8，但保险起见）
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

# 提示输入提交信息（支持中文输入）
echo "请输入本次更新的描述："
read commit_message

if [ -z "$commit_message" ]; then
    commit_message="Update on $(date '+%Y-%m-%d %H:%M:%S')"
    echo "使用默认信息: $commit_message"
fi

# 添加、提交、推送
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