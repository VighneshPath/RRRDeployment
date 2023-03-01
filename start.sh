#!/bin/bash

sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill -9

nohup sudo MICRONAUT_SERVER_PORT=80 java -jar esop-trading/build/libs/esop-trading-0.1-all.jar > /dev/null 2>&1&