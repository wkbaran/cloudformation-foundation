# Bill's Cloudformation Templates

## Jobs Server
This is intended to be a standalone docker server to build on top of.  
Build on just the vpcinet stack. No load balancer, single instance in a single public subnet.  

### TLS
Commands used for setting up TLS...

1. *Generate TLS Certificates (On Your Local Machine)*
You'll need:
 - A CA certificate
 - A server certificate (for Docker)
 - A client certificate (for remote management)

*Generate a Root CA:*
```bash
mkdir -p ~/docker-tls && cd ~/docker-tls
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
```

*Generate a Server Key and Cert:*
```bash
openssl genrsa -out server-key.pem 4096
openssl req -new -key server-key.pem -out server.csr
echo subjectAltName = IP:YOUR_INSTANCE_IP > extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
```

*Generate a Client Key and Cert:*
```bash
openssl genrsa -out client-key.pem 4096
openssl req -new -key client-key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile-client.cnf
```

2. *Upload Certificates to AWS SSM Parameter Store*
```bash
aws ssm put-parameter --name "/docker/ca.pem" --type "SecureString" --value "$(cat ca.pem)"
aws ssm put-parameter --name "/docker/server-cert.pem" --type "SecureString" --value "$(cat server-cert.pem)"
aws ssm put-parameter --name "/docker/server-key.pem" --type "SecureString" --value "$(cat server-key.pem)"
```

3. *Add the following to EC2 UserData*
```bash
# Create certificate directory
mkdir -p /etc/docker/certs

# Fetch TLS certificates from SSM
aws ssm get-parameter --name "/docker/ca.pem" --with-decryption --query "Parameter.Value" --output text > /etc/docker/certs/ca.pem
aws ssm get-parameter --name "/docker/server-cert.pem" --with-decryption --query "Parameter.Value" --output text > /etc/docker/certs/server-cert.pem
aws ssm get-parameter --name "/docker/server-key.pem" --with-decryption --query "Parameter.Value" --output text > /etc/docker/certs/server-key.pem

# Set correct permissions
chmod 600 /etc/docker/certs/*
chown root:root /etc/docker/certs/*
```

## Foundation Template
The foundation template is the VPC, Internet Gateway, public subnet and NAT Gateway - so 
everything to get to the internet.

The ECS cluster is built on top of that, intended to be the default source for compute for my 
applications. Cluster resources are deployed in private subnets.

Applications will be deployed as an ECS Task or Service template. Isolation is done through security 
groups.

If persistent state is needed, that should be created in a separate template and export the 
necessary identifiers to import them into the task template. This way, the task implementation can 
be changed without effecting the datastore.

This creates a VPC and what's needed to give apps a public gateway to the internet.
Namely:
- Internet Gateway
- Two public subnets
- NAT Gateway to give private subnets access to the Internet
- Application Load Balancer - It's expected that each app will have its own Listener

## ECS Cluster
My default source of compute. Currently only has one

## ECS Service / Task Template

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
