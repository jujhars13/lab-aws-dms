#!/bin/bash

yum update -y
amazon-linux-extras install -y docker
usermod -a -G docker ec2-user
service docker start

yum install -y mariadb \
  htop \
  vim \
  tmux \
  unzip \
  nmap-ncat \
  git

readonly MYSQL_ROOT_PASSWORD="changeme"
docker run -d \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
  --name mysql \
  mysql:5.7-debian

## import in this dataset into mysql
# https://github.com/datacharmer/test_db
git clone https://github.com/datacharmer/test_db

echo "going to poll databases until they're ready"
until nc -z -v -w30 localhost 3306
do
    echo "Waiting 2s for database connection to mysql..."
    # wait for n seconds before check again
    sleep 2
done

echo "Importing data into mysql"
(cd test_db && \
  mysql -h localhost \
    --protocol=tcp \
    -u root \
    --password="${MYSQL_ROOT_PASSWORD}" < employees_partitioned.sql)
