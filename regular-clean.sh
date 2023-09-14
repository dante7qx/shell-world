
#!/bin/bash
################################################################
#每小时执行一次脚本（任务计划），当时间为0点或12点时，将目标目录下的所有文件内容清空，
#但不删除文件，其他时间则只统计各个文件的大小，一个文件一行，输出到以时#间和日期命名的文件中，需要考虑目标目录下二级、三级等子目录的文件
################################################################

dir=$1
logfile=/tmp/`date +%H-%F`.log
n=`date +%H`

if [ -z "$dir" ]; then
	echo "please input clean dir"
	exit 1
fi


if [ $n -eq 00 ] || [ $n -eq 12 ]
then
    # 通过for循环，以find命令作为遍历条件，将目标目录下的所有文件进行遍历并做相应操作
    for i in `find $dir -type f`
    do
        true > $i
    done
else
    for i in `find $dir -type f`
    do
        du -sh $i >> $logfile
    done
fi