#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Enable SSM
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm || :
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

# Configure ECS
cat <<DATA >> /etc/ecs/ecs.config
ECS_CLUSTER=${cluster_name}
DATA
