#!/bin/bash

sudo yum update

sudo yum install -y java-17-amazon-corretto-devel

sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill -9

export MICRONAUT_SERVER_PORT=80

nohup java -jar esop-trading/build/libs/esop-trading-0.1-all.jar > /dev/null 2>&1&