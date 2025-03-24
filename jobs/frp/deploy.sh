#!/bin/bash
. ./.env
ssh -i ~/.ssh/minecraftkey.pem ec2-user@jobs.${DOMAIN} mkdir -p frp/certs
scp -i ~/.ssh/minecraftkey.pem frps.toml generate_certs.sh ec2-user@jobs.${DOMAIN}:frp/
../jobsdock.sh compose up -d
