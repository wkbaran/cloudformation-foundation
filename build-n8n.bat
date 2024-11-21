REM Create the private subnet, ALB listener, dns record, ECS cluster, etc
aws cloudformation deploy `
  --template-file cfn-ecs-cluster.yaml `
  --stack-name n8n-ecs-cluster `
  --parameter-overrides file://n8n-ecs-cluster-params.json `
  --capabilities CAPABILITY_IAM `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload

aws cloudformation deploy `
  --template-file cfn-n8n-rds.yaml `
  --stack-name n8n-rds `
  --parameter-overrides file://n8n-rds-params.json `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload

REM Create the ECS task to run the n8n docker image
aws cloudformation deploy `
  --template-file cfn-ecs-task-n8n.yaml `
  --stack-name n8n-ecs-task `
  --parameter-overrides file://n8n-ecs-task-params.json `
  --capabilities CAPABILITY_IAM `
  --s3-prefix cloudformation-build-925032123076 `
  --disable-rollback --force-upload
