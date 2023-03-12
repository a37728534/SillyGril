#!/bin/bash

# 提示用户选择需要安装的软件
echo "请选择需要安装的软件:"
echo "1. 安装奥特曼"
echo "2. 安装go-cqhttp"
echo "3. 安装青龙面板"
echo "4. 安装BBK微信扫码"
echo "5. 安装BBK京东扫码"

# 读取用户输入的选项
read choice

case $choice in
    1)
        # 安装奥特曼
        tag=$(curl -s https://gitee.com/hdbjlizhe/autMan/releases/latest|cut -d"\"" -f2|cut -d'/' -f8)
        if [ ! "$tag" ];then exit;fi
        s=autMan
        a=amd64
        if [[ $(uname -a | grep "aarch64") != "" ]];then a=arm64;fi
        if [ ! -d $s ];then mkdir $s;fi
        cd $s
        wget https://gitee.com/hdbjlizhe/${s}/releases/download/${tag}/autMan_$a.tar.gz && tar -zxvf autMan_$a.tar.gz && rm -rf autMan_$a.tar.gz && chmod 777 $s;pkill -9 $s;$(pwd)/$s -t
        ;;
    2)
        # 安装go-cqhttp
        cd /root && mkdir go-cqhttp && cd go-cqhttp
        wget https://github.com/Mrs4s/go-cqhttp/releases/download/v1.0.0-rc4/go-cqhttp_linux_amd64.tar.gz #拉取go-cqhttp文件
        tar -zxvf go-cqhttp_linux_amd64.tar.gz #解压文件
        ./go-cqhttp #启动go-cqhttp
        ;;
    3)
        # 安装青龙面板
        docker run -dit \
            -v $PWD/ql:/ql/config \
            -p 5700:5700 \
            --name qinglong \
            --hostname qinglong \
            --restart unless-stopped \
            --privileged=true \
            --network=host \
            whyour/qinglong:latest
        ;;
    4)
        # 安装BBK微信扫码
        cd /root && mkdir -p $(pwd)/bbk-qr/{conf,logs} && cd $(pwd)/bbk-qr
        docker run -dit \
            -v $PWD/conf:/data/conf \
            -v $PWD/logs:/data/logs \
            -p 2081:81 \
            --name bbk-qr \
            neuynp8oido4ejj/qr:latest
        ;;
    5)
        # 安装BBK京东扫码
        cd /root && mkdir -p $(pwd)/bbk-jd-qr/{conf,logs} && cd $(pwd)/bbk-jd-qr
        docker run -dit \
            -v $PWD/conf:/data/conf \
            -v $PWD/logs:/data/logs \
            -p 3081:81 \
            --name bbk-jd-qr \
            --privileged=true
            neuynp8oido4ejj/jd-qr:latest
        esac
