#!/bin/bash

if [ ! -e "$HOME/Downloads" ]; then 
    mkdir $HOME/Downloads
fi
cd $HOME/Downloads 

if [ ! -e "$HOME/Downloads/go1.20.4.linux-amd64.tar.gz" ]; then 
    wget https://golang.google.cn/dl/go1.20.4.linux-amd64.tar.gz
fi

tar -xvzf go1.20.4.linux-amd64.tar.gz

sudo -v

if [ -e "/usr/local/go" ]; then
    sudo rm -rf /usr/local/go
    sudo mv go /usr/local
fi

sudo sh -c 'echo "export GOPATH=$HOME/Repo/go" >> /etc/profile'
sudo sh -c 'echo "export GOROOT=/usr/local/go" >> /etc/profile'
sudo sh -c 'echo "export PATH=$PATH:$GOPATH/bin:$GOROOT/bin" >> /etc/profile'

if [ ! -d "$HOME/Repo" ]; then 
    mkdir $HOME/Repo
fi


source /etc/profile

go env -w GOPROXY=https://goproxy.cn,direct
go env -w GO111MODULE=on