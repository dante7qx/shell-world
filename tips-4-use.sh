
#!/bin/bash

usage() {
    echo "Usage: ./tips-4-use.sh [statsum|guess|varassgin|statfile]"
    exit 1
}

## 连续输入5个100以内的数字，统计和、最小和最大
function statSum() {
    COUNT=1
    SUM=0
    MIN=0
    MAX=100
    while [ $COUNT -le 5 ]; do
        read -p "请输入1-10个整数：" INT
        if [[ ! $INT =~ ^[0-9]+$ ]]; then
            echo "输入必须是整数！"
            exit 1
            elif [[ $INT -gt 100 ]]; then
            echo "输入必须是100以内！"
            exit 1
        fi
        SUM=$(($SUM+$INT))
        [ $MIN -lt $INT ] && MIN=$INT
        [ $MAX -gt $INT ] && MAX=$INT
        let COUNT++
    done
    echo "SUM: $SUM"
    echo "MIN: $MIN"
    echo "MAX: $MAX"
}

## 用户猜数字
## 脚本生成一个 100 以内的随机数,提示用户猜数字,根据用户的输入,提示用户猜对了, 猜小了或猜大了, 直至用户猜对脚本结束
function guessNum() {
    num=$[RANDOM%100+1]
    echo "系统答案 --> $num"
    while :
    do
        read -p "计算机生成了一个 1‐100 的随机数,你猜: " cai
        if [ $cai -eq $num ]
        then
            echo "恭喜,猜对了"
            exit
        elif [ $cai -gt $num ]
        then
            echo "Oops,猜大了"
        else
            echo "Oops,猜小了"
        fi
    done
}

## 变量赋值
function varAssign() {
    num=0
    for i in $(eval echo "192.168.1.1{1,2}"); do   #eval将{1,2}分解为1 2
        let num+=1
        eval node${num}="$i"
    done
    echo $node1 $node2 $node3

    arr=(4 5 6)
    INDEX1=$(echo ${arr[0]})
    INDEX2=$(echo ${arr[1]})
    INDEX3=$(echo ${arr[2]})
    echo $INDEX1 $INDEX2 $INDEX3
}

## 统计某类文件大小
statFileDir=$2
statFileSuffix=$3
function statFile() {
    if [[ -z "$statFileDir" ||  -z "$statFileSuffix" ]]; then
        echo "please input stat dir and suffix"
        exit 1
    fi
    ## 统计单个目录
    # du -ch ${statFileDir}/*.${statFileSuffix} | grep -E "total$" | awk '{print $1}'
    ## 递归统计
    find ${statFileDir} -name "*.${statFileSuffix}" -exec du -ch {} + | grep -E "total$" | awk '{print $1}'
}

case "$1" in
   "statsum")
        statSum
        ;;
   "guess")
        guessNum
        ;;
   "varassgin")
        varAssign
        ;;
    "statfile")
        statFile
        ;;
   *)
     usage
     ;;
esac

