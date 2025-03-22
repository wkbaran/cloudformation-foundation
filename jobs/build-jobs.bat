REM Create jobs server as a docker host
aws cloudformation deploy `
  --template-file cfn-jobs.yaml `
  --stack-name jobs `
  --parameter-overrides file://jobs-params.json `
  --capabilities CAPABILITY_IAM `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload
