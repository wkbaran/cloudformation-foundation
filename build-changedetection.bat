aws cloudformation create-stack --stack-name changedetection --template-body file://cfn-ecsWithEfs.yaml `
    --parameters file://changedetection-ecs-params.json --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name changedetection
aws cloudformation describe-stacks --stack-name changedetection