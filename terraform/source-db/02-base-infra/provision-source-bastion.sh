#!/bin/bash

if (which docker); then
  echo "Docker aleady installed"
else
  sudo yum update -y
  sudo amazon-linux-extras install -y docker
  sudo usermod -a -G docker ec2-user
  sudo service docker start
fi