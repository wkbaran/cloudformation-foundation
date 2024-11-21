
# Bill's Cloudformation Templates

## Prerequisites
First, create the following resources in AWS:
- Route 53 zone
- Wildcard cert

## Foundation
This creates a VPC and what's needed to give apps a public gateway to the internet.
Namely:
- Internet Gateway
- Two public subnets
- NAT Gateway to give private subnets access to the Internet
- Application Load Balancer - It's expected that each app will have its own Listener

### Parameters
- CIDR block for the VPC
- ARN for SSL Cert in Certificate Manager

### Outputs
- SSL Cert Arn
- VPC Id
- NAT Gateway Id
- ALB ARN
- ALB DNS Name
- ALB Hosted Zone Id
- ALB Security Group Id
- Public Subnet 1 AZ
- Public Subnet 2 AZ

## Docker on ECS with EFS
Runs a Docker image as an ECS Service on a single EC2 instance.

### Parameters
- Docker image path
- Port to expose
- Domain name to assign
- EFS Filesystem Id
- EFS Mount path
- Route 53 Zone Id
- EC2 Instance Type
- Email address to use for first user account
- CIDR block for private Subnet 

## To-Do
- [ ] Make EFS conditional
- [ ] Remove user pool from change detection; Make global
- [ ] RDS option
- [ ] Fargate option
