#!/bin/bash

## 创建多个相同类型的文件
function createMoreFile() {
  touch spirit{1..5}.rs
  ls -lah
  rm -rf spirit*.rs
}

## 快速生成一个大文件
function genBigFile() {
  dd if=/dev/zero of=~/Documents/Project/shell-world/clear/test.txt bs=1M count=1024
  ls -lah
  rm -rf test.txt
}

## 清空文件
function clearFile() {
  ## cat /dev/null > haodao.py
  ## : > haodao.py
  ## echo -n "" > haodao.py
  ## truncate -s 0 haodao.py
  true > haodao.py
}

## 测试方法
# createMoreFile
genBigFile