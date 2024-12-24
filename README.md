
# Bill's Cloudformation Templates
The foundation template is the VPC, Internet Gateway, public subnet and NAT Gateway - so 
everything to get to the internet.

The ECS cluster is built on top of that, intended to be the default source for compute for my 
applications. Cluster resources are deployed in private subnets.

Applications will be deployed as an ECS Task or Service template. Isolation is done through security 
groups.

If persistent state is needed, that should be created in a separate template and export the 
necessary identifiers to import them into the task template. This way, the task implementation can 
be changed without effecting the datastore.

## Foundation Template
This creates a VPC and what's needed to give apps a public gateway to the internet.
Namely:
- Internet Gateway
- Two public subnets
- NAT Gateway to give private subnets access to the Internet
- Application Load Balancer - It's expected that each app will have its own Listener

### Prerequisites
First, create the following resources in AWS:
- Route 53 zone
- Wildcard cert

### Parameters
- VpcCidr
- SSLCertificateArn

### Resources:
- VPC
- InternetGateway
- InternetGatewayAttachment
- PublicSubnet1
- PublicSubnet2
- PublicRouteTable
- DefaultPublicRoute
- PublicSubnet1RouteTableAssociation
- PublicSubnet2RouteTableAssociation
- NATGateway
- NATGatewayEIP
- ALBSecurityGroup
- ApplicationLoadBalancer

### Outputs
- SSLCertificationArn
- VPCId
- VPCCidr
- NATGatewayId
- ALBArn
- ALBDNSName
- ALBHostedZoneId
- ALBSecurityGroupId
- PublicSubnet1AZ
- PublicSubnet2AZ

## ECS Cluster
My default source of compute. Currently only has one

### Prerequisites
- User pool (Referenced in ECS cluster when ALB Listener is configured)

### Parameters
- Region
- CIDR block for private Subnet
- Internet Gateway Id
- EC2 Instance Type

### Resources
- PrivateSubnet
- DefaultPublicRoute
- PrivateRouteTable
- PrivateSubnetRouteTableAssociation
- ECSCluster
- ECSSecurityGroup
- ECSInstanceProfile
- ECSInstanceRole
- SSMServiceRole
- ECSTaskExecutionRole
- LaunchTemplate
- AutoScalingGroup
- ECSCapacityProvider
- ClusterCapacityProviderAssociation

### Outputs
- ECSClusterArn
- ECSTaskExecutionRoleArn
- ECSSecurityGroupId
- PrivateSubnetId

## ECS Service / Task Template

### Prerequisites
First, create the following resources in AWS:
- Route 53 zone

### Parameters
- DomainName
- ImagePath - Docker Hub image path
- AppPort - Port to expose for app
- EfsFileSystemId
- EfsMountPath - Path to mount EFS volume onto
- Environment
- DatabaseSecretArn - Secret that has the db username nad password
- R53HostedZoneId
- UserPoolId
- UserPoolArn
- UserPoolDomain

### Resources
- CloudWatchLogsGroup
- ECSTaskRole
- EFSSecurityGroup
- MountTarget
- ALBTargetGroup
- ALBIngressRule
- UserPoolClient
- ALBListener
- ALBListenerRule
- ECSTaskDefinition
- ECSService
- ECSTaskSecurityGroup
- Route53RecordSet
- RDSIngressRule
- RDSIngressRuleVPC

## Commands
### Disabling Service 
```
aws ecs update-service --cluster n8n-ecs-cluster-cluster --service n8n-ecs-task-service --desired-count 0
```
### Enabling Service
```
aws ecs update-service --cluster n8n-ecs-cluster-cluster --service n8n-ecs-task-service --desired-count 1
```
### Enable maintenance mode
```bash
aws elbv2 set-rule-priorities --rule-priorities \
  RuleArn=arn:aws:elasticloadbalancing:us-west-2:925032123076:listener-rule/app/founda-Appli-PuYPyboNP4Rc/0d5aab57c40cddc1/c16dcddef6a189c5/1e5763ff40f168ba,Priority=101
```

## To-Do
- [ ] Add ALB listener rule to display a maintenance page when app is down to task template
- [ ] Make task template and param files for changedetection.io
