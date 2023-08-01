#!/bin/bash

if (which docker); then
  echo "Docker aleady installed"
else
  sudo yum update -y
  sudo amazon-linux-extras install -y docker
  sudo usermod -a -G docker ec2-user
  sudo service docker start
fi

yum install -y mariadb htop vim tmux

docker run -d \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD="changeme" \
  --name mysql \
  mysql:5.7-debian

# docker wait mysql

## TODO insert sample dataset in here via docker volume