#!/usr/bin/env bash

# Usage:
# $ . install.sh

USER_ID=$(id -u)
GROUP_ID=$(id -g)

printf "USER_ID: ${USER_ID}\n"
printf "GROUP_ID: ${GROUP_ID}\n"

APP=${PWD}/app
FRANKENPHP=${PWD}/symfony-docker
PROJECT_NAME=${PWD##*/}
SERVER_NAME=${PROJECT_NAME}.localhost
BASE=symfony-docker/compose.yaml
OVERRIDE=symfony-docker/compose.override.yaml

if [ -d symfony-docker ]; then
  printf "Symfony Docker already cloned\n"
else
  printf "Clone Symfony Docker (next branch)\n"
  git clone git@github.com:jprivet-dev/symfony-docker.git -b next
fi

sleep 1

printf "Build fresh images\n"
APP=${APP} FRANKENPHP=${FRANKENPHP} SERVER_NAME=${SERVER_NAME} docker compose -p ${PROJECT_NAME} -f ${BASE} -f ${OVERRIDE} build --no-cache

printf "Set up and start a fresh Symfony project\n"
APP=${APP} FRANKENPHP=${FRANKENPHP} SERVER_NAME=${SERVER_NAME} docker compose -p ${PROJECT_NAME} -f ${BASE} -f ${OVERRIDE} up --pull always -d --wait

printf "Fix permissions\n"
APP=${APP} FRANKENPHP=${FRANKENPHP} SERVER_NAME=${SERVER_NAME} docker compose -p ${PROJECT_NAME} -f ${BASE} -f ${OVERRIDE} run --rm php chown -R ${USER_ID}:${GROUP_ID} .

printf ">\n"
printf "> Go on https://${SERVER_NAME}/\n"
printf ">\n"
