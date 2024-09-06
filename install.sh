#!/usr/bin/env bash

# Usage:
# $ . install.sh [branch]

USER_ID=$(id -u)
GROUP_ID=$(id -g)

printf "USER_ID: ${USER_ID}\n"
printf "GROUP_ID: ${GROUP_ID}\n"

branch_args=""
[[ "${1}" != "" ]] && branch_args="-b ${1}"

APP_DIR=${PWD}/app
DOCKER_DIR=${PWD}/docker
DOCKER_REP=git@github.com:jprivet-dev/symfony-docker.git
PROJECT_NAME=${PWD##*/}
SERVER_NAME=${PROJECT_NAME}.localhost
COMPOSE_BASE=${DOCKER_DIR}/compose.yaml
COMPOSE_OVERRIDE=${DOCKER_DIR}/compose.override.yaml

case $default in
  "${YES}" | "${YES_SHORT}") default="${YES}" ;;
  "${NO}" | "${NO_SHORT}") default="${NO}" ;;
  *) default="${YES}" ;;
esac

if [ -d ${DOCKER_DIR} ]; then
  printf "Symfony Docker already cloned\n"
else
  printf "Clone Symfony Docker (next branch)\n"
  git clone ${DOCKER_REP} ${DOCKER_DIR} ${branch_args}
fi

printf "Build fresh images\n"
APP_DIR=${APP_DIR} DOCKER_DIR=${DOCKER_DIR} SERVER_NAME=${SERVER_NAME} \
  docker compose -p ${PROJECT_NAME} -f ${COMPOSE_BASE} -f ${COMPOSE_OVERRIDE} build --no-cache

printf "Set up and start a fresh Symfony project\n"
APP_DIR=${APP_DIR} DOCKER_DIR=${DOCKER_DIR} SERVER_NAME=${SERVER_NAME} \
  docker compose -p ${PROJECT_NAME} -f ${COMPOSE_BASE} -f ${COMPOSE_OVERRIDE} up --pull always -d --wait

printf "Fix permissions\n"
APP_DIR=${APP_DIR} DOCKER_DIR=${DOCKER_DIR} SERVER_NAME=${SERVER_NAME} \
  docker compose -p ${PROJECT_NAME} -f ${COMPOSE_BASE} -f ${COMPOSE_OVERRIDE} run --rm php chown -R ${USER_ID}:${GROUP_ID} .

printf ">\n"
printf "> Go on https://${SERVER_NAME}/\n"
printf ">\n"
