#!/bin/bash

#####################################
# 检测两台服务器指定目录下的文件一致性
#####################################
# 通过对比两台服务器上文件的md5值，达到检测一致性的目的

dir=$1
serverIP=$2

if [[ -z "$dir" ||  -z "$serverIP" ]]; then
	echo "please input diff dir and server ip"
	exit 1
fi

echo "$dir - $serverIP"

# 将指定目录下的文件全部遍历出来并作为md5sum命令的参数，进而得到所有文件的md5值，并写入到指定文件中
find $dir -type f | xargs md5sum > /tmp/md5_a.txt
ssh root@$serverIP "find $dir -type f | xargs md5sum > /tmp/md5_b.txt"
scp root@$serverIP:/tmp/md5_b.txt /tmp
ssh root@$serverIP "rm -rf /tmp/md5_b.txt"

# 将文件名作为遍历对象进行一一比对
for f in `awk '{print $2}' /tmp/md5_a.txt`
do
	# 以a机器为标准，当b机器不存在遍历对象中的文件时直接输出不存在的结果
	if grep -qw "$f" /tmp/md5_b.txt
	then
		md5_a=`grep -w "$f" /tmp/md5_a.txt|awk '{print $1}'`
		md5_b=`grep -w "$f" /tmp/md5_b.txt|awk '{print $1}'`
		# 当文件存在时，如果md5值不一致则输出文件改变的结果
        if [ $md5_a != $md5_b ]
        then
            echo "$f changed."
        fi
	else
		echo "$f deleted."
	fi
done

## 清理临时文件
rm -rf /tmp/md5_*.txt