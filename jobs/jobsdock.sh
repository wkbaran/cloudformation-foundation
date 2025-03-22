#!/bin/bash
export DOCKER_TLS_VERIFY=1
export DOCKER_HIDE_LEGACY_COMMANDS=1
export DOCKER_HOST=tcp://jobs.billbaran.us:2376
export DOCKER_CERT_PATH=~/.docker
docker $*
