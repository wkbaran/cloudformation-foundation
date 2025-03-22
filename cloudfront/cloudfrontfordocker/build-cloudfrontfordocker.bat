REM Deploy cloudfront pointing to docker host and DNS record
aws cloudformation deploy `
  --template-file cfn-cloudfront-fordocker.yaml `
  --stack-name cloudfront-fordocker `
  --parameter-overrides file://cloudfront-fordocker-params.json `
  --capabilities CAPABILITY_IAM `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload

REM Now deploy traefik to docker host
REM Sorry, use WSL
;cd traefik


REM To add port 80 to an existing security group...
:: aws ec2 authorize-security-group-ingress \
::     --group-id YOUR_SECURITY_GROUP_ID \
::     --protocol tcp \
::     --port 80 \
::     --cidr 13.32.0.0/15 13.35.0.0/16 13.113.196.64/26

REM to check
:: aws ec2 describe-security-groups --group-id YOUR_SECURITY_GROUP_ID


