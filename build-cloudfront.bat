REM Create Cloudfront distribution for ntfy.billbaran.us, zrok.billbaran.us, etc
aws cloudformation deploy `
  --template-file cfn-cloudfront.yaml `
  --stack-name cloudfront `
  --parameter-overrides file://cloudfront-params.json `
  --capabilities CAPABILITY_IAM `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload
