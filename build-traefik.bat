REM Create traefik proxy server as a docker container
aws cloudformation deploy `
  --template-file cfn-traefik-full.yaml `
  --stack-name traefik `
  --parameter-overrides file://traefik-full-params.json `
  --capabilities CAPABILITY_IAM `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload
