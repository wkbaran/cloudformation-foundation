#!/bin/bash
. ./.env
ssh -i ~/.ssh/minecraftkey.pem ec2-user@jobs.${DOMAIN} mkdir -p traefik/config
envsubst < traefik.yaml > traefik.gen.yaml
scp -i ~/.ssh/minecraftkey.pem traefik.gen.yaml ec2-user@jobs.${DOMAIN}:traefik/traefik.yaml
envsubst < config/dashboard.yaml > config/dashboard.gen.yaml
scp -i ~/.ssh/minecraftkey.pem config/dashboard.gen.yaml ec2-user@jobs.${DOMAIN}:traefik/config/dashboard.yaml
../jobsdock.sh compose up -d
