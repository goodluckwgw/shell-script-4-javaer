#!/bin/bash

# 1.找到高负载的进程
topPid=$(pidstat 2 1 | grep Average | sort -k 7 -n -r | head -1 | awk '{print $3}')
# 2.根据进程号找到占用CPU最高的线程
topTid=$(ps -mp $topPid -o THREAD,tid,time | sort -k 2 -n -r | head -20 | awk '{print $8}' | grep -v '-' | grep -v TID | head -1)
# 3.打印栈信息到文件
stackTid=$(printf %x $topTid)
filename=$(date +'%F-%H:%M:%S')
sudo jstack $topPid | grep $stackTid -A 20 > /data/logs/shell/$filename.log 
