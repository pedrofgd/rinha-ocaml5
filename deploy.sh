#!/bin/bash

set -e
set -x

docker-compose build --no-cache
docker-compose down
docker-compose up
