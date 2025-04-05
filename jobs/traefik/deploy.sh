#!/bin/bash
. ./.env
ssh -i ~/.ssh/minecraftkey.pem ec2-user@jobs.${DOMAIN} mkdir -p traefik
scp -i ~/.ssh/minecraftkey.pem traefik.toml ec2-user@jobs.${DOMAIN}:traefik/
../jobsdock.sh compose up -d
