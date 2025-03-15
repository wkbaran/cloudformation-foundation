REM Create the private subnet, ALB listener, dns record, ECS cluster, etc
aws cloudformation deploy `
  --template-file cfn-zrok-full.yaml `
  --stack-name zrok `
  --parameter-overrides file://zrok-full-params.json `
  --capabilities CAPABILITY_IAM `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload
