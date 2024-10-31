
#!/bin/bash

         apt-get update
         apt-get install -y ruby ruby-dev build-essential rpm
         gem install --no-document fpm
apt-get install -y ca-certificates lsb-release curl gnupg software-properties-common
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial stable"
apt-get update
apt-get install -y docker-ce
docker --version
