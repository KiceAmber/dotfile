# 下载 Go1.20.4 版本压缩包
cd ~/Downloads

wget https://golang.google.cn/dl/go1.20.4.linux-amd64.tar.gz

tar -xvzf go1.20.4.linux-amd64.tar.gz

sudo mv go /usr/local

sudo echo export GOPATH=$HOME/Project/go >> /etc/profile
sudo echo export GOROOT=/usr/local/go >> /etc/profile
sudo echo export PATH=$PATH:$GOPATH/bin:$GOROOT/bin >> /etc/profile

source /etc/profile

go env -w GOPROXY=https://goproxy.cn,direct
go env -w GO111MODULE=on
