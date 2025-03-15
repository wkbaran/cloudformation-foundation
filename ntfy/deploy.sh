#!/bin/bash
ssh -i ~/.ssh/minecraftkey.pem ec2-user@jobs.billbaran.us mkdir -p ntfy
scp -i ~/.ssh/minecraftkey.pem init-script.sh ec2-user@jobs.billbaran.us:ntfy/
ssh -i ~/.ssh/minecraftkey.pem ec2-user@jobs.billbaran.us chmod +x ntfy/init-script.sh
../jobsdock.sh compose up -d
