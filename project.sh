#!/bin/sh

# 请在 unix 终端或 git-bash 中运行此脚本

printf "\n1. 项目成员数量："; git log --pretty='%aN' | sort -u | wc -l

printf "\n\n2. 按用户名统计代码提交次数：\n\n"
printf "%10s  %s\n" "次数" "用户名"
git log --pretty='%aN'  --since=2023-01-01 --until=2023-06-30 | sort | uniq -c | sort -k1 -n -r | head -n 5
printf "\n%10s" "合计";
printf "\n%5s" ""; git log --oneline  --since=2023-01-01 --until=2023-06-30 | wc -l

printf "\n3. 按用户名统计代码提交行数：\n\n"
printf "%25s %s = %s - %18s\n" "用户名" "总行数" "添加行数" "删除行数"

git log --format='%aN'  --since=2023-01-01 --until=2023-06-30 | sort -u -r | while read name; do printf "%25s" "$name"; \
git log --author="$name" --pretty=tformat: --numstat  --since=2023-01-01 --until=2023-06-30 | \
awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%15s %15s %15s \n", loc, add, subs }' \
-; done

printf "\n%25s   " "总计："; git log --pretty=tformat: --numstat  --since=2023-01-01 --until=2023-06-30 | \
awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%15s %15s %15s \n", loc, add, subs }'

echo ""
# shellcheck disable=SC2162


printf "\n4. 修改最多的文件：\n\n"
git --no-pager log --format=format:'%h' --no-merges --since=2023-01-01 --until=2023-06-30 | \
awk '{system(" git --no-pager diff  --stat-name-width=300 --name-only "$1" "$1"~") }'| \
awk '{fs[$0]+=1} END{for(f in fs) printf("%d\t%s\r\n",fs[f],f) }' | sort -n -r | head -10

printf "\n5. 创建csv文件用于excel做各类图：\n\n"

path=$(basename "$PWD") 
echo $path
git log --pretty="format:%ci|%an|%h|%s" --since=2023-01-01 --until=2023-06-30 | awk '{print $0}' > $path.csv

printf "%s.csv 已创建" $path

read -n 1 -p "请按任意键继续..."