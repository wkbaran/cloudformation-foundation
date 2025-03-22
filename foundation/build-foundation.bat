aws cloudformation create-stack --stack-name foundation --template-body file://cfn-foundation.yaml `
    --parameters file://foundation-default-params.json
aws cloudformation wait stack-create-complete --stack-name foundation
aws cloudformation describe-stacks --stack-name foundation

aws cloudformation deploy `
  --template-file cfn-foundation.yaml `
  --stack-name foundation `
  --parameter-overrides file://foundation-default-params.json `
  --force-upload `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback

