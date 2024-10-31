
#!/bin/bash

         apt-get update
         apt-get install -y ruby ruby-dev build-essential rpm
         gem install --no-document fpm
apt-get install docker-ce docker-ce-cli containerd.io
systemctl start docker
docker run hello-world
