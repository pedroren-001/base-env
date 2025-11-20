#!/bin/bash
# 针对scripts目录下的所有sh脚本进行执行
set -e
for file in `ls scripts/*.sh`; do
    echo "executing $file"
    bash $file
done
