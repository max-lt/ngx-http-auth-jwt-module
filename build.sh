#!/bin/bash

RED='\033[01;31m'
NONE='\033[00m'

# build main image
DOCKER_IMAGE_NAME=jwt-nginx
docker build -t ${DOCKER_IMAGE_NAME} .
if [ $? -ne 0 ]
then
  echo -e "${RED}Build Failed${NONE}";
  exit 1;
fi
