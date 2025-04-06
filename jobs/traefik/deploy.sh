#!/bin/bash
. ./.env
ssh -i ~/.ssh/minecraftkey.pem ec2-user@jobs.${DOMAIN} mkdir -p traefik/config
scp -i ~/.ssh/minecraftkey.pem traefik.yaml ec2-user@jobs.${DOMAIN}:traefik/
scp -i ~/.ssh/minecraftkey.pem config/dashboard.yaml ec2-user@jobs.${DOMAIN}:traefik/config
../jobsdock.sh compose up -d
