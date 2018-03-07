#!/bin/bash

# 功能描述：评估使用redis进行存储的容量评估
# 使用：根据自己需要修改key和value的长度，以及写命令

echo "flushdb"
echo "每次测试写1000条数据"
# 清空redis
/usr/local/bin/redis-cli -a 123456  flushdb >/dev/null
# 获取写入前占用的内存空间
um1=`/usr/local/bin/redis-cli -a kevinyin info | grep 'used_memory:'|awk -F':' '{print $2}'| sed -e 's/\r//g'`
echo '写入前占用的内存空间：'$um1
#写入数据
echo "length(key)<8, length(value)<8"
for (( i=10000; i<11000; i++ ))
do
/usr/local/bin/redis-cli -a 123456 set ${i} val>/dev/null
done
# 获取写入后的占用内存
um2=`/usr/local/bin/redis-cli -a kevinyin info | grep 'used_memory:'|awk -F':' '{print $2}'| sed -e 's/\r//g'`
total1=$(echo "$um2 - $um1" | bc)
# 统计每个key和value 占用空间
avg1=$(echo "$total1 / 1000" | bc)
echo "total used memory: $total1, avg: $avg1"

