#!/bin/bash

## 查找当前目录下名字包含springboot的目录
find . -type d -name "springboot*"

## 查找当前目录下文件权限为755的对应文件
find . -type f -perm 755

## 查找当前目录下不具有755权限的所有文件
find . -type f ! -perm 755

## 查找当前目录下具有777权限的所有文件，并且将这些权限全部改为755
find . -type f -perm 777  -exec chmod 755 {} \;

## 查找当前目录下文件大小为100MB~1GB的所有文件
find . -type f -size +100M -size -1G

## 查找当前目录下以.py结尾的文件，并且删除
find . -name "*.py" | xargs rm -rf {};

## 查找当前目录下30天前修改过的所有文件
## 查找当前目录下30天前访问过的所有文件
find . -mtime 30
find . -atime 30

## 查找当前目录下7天前创建的，并且后缀名是以.py结尾的文件，并且进行删除
find . -mtime +7  -name "*.py" | xargs rm -rf {};

## 查看有几个逻辑cpu, 包括cpu型号
## 查看有几颗cpu,每颗分别是几核
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
cat /proc/cpuinfo | grep physical | uniq -c

## /var目录按照目录大小排序展示最前面20个目录或者文件
## 按照大到小排列出当前文件或者目录最大的10个
du -xB M --max-depth=2 /var | sort -rn | head -n 20
du -s * | sort -n | tail

## 查找当前系统内存使用量较高的进程（前20个）
ps -aux | sort -rnk 4 | head -20

## 查找 80 端口请求数最高的前 15 个 IP
netstat -anlp|grep 80|grep tcp|awk '{print $5}' |awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n 15

## 通过抓包工具tcpdump查看8080端口访问量情况；
tcpdump -i ens33 -tnn dst port 8080 -c 1000 | awk -F"." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr |head -10
## 针对网口ens33进行抓包，过滤出端口号是 8080 的相关报文
tcpdump port 8080 -i ens33 -n -c 5
## 针对网口ens33进行抓包，过滤出 80端口到443端口
tcpdump portrange 80-433 -i ens33 -n -c 8