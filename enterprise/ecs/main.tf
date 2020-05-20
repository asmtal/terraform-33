provider "aws" {
  version = "2.46.0"
}

provider "template" {
  version = "2.1.2"
}

provider "random" {
  version = "~> 2.2"
}

terraform {
  backend "s3" {
    bucket = "sider-enterprise-provisioning-examples"
    key    = "tf"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  blacklisted_names = [
    "us-east-1c",
    "us-east-1e",
  ]
  state = "available"
}

locals {
  mysql_username = "sider"
}

module "sider_enterprise_network" {
  source = "../modules/network"

  vpc_cidr_block = "10.13.0.0/16"
  public_subnet1 = {
    cidr_block        = "10.13.0.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
  }
  public_subnet2 = {
    cidr_block        = "10.13.1.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]
  }
  private_subnet1 = {
    cidr_block        = "10.13.2.0/24"
    availability_zone = data.aws_availability_zones.available.names[2]
  }
  private_subnet2 = {
    cidr_block        = "10.13.3.0/24"
    availability_zone = data.aws_availability_zones.available.names[3]
  }
}

module "sider_enterprise_s3_buckets" {
  source = "../modules/s3_buckets"

  vpc_id     = module.sider_enterprise_network.vpc_id
  aws_region = data.aws_region.current.name
  catpost_vpc_endpoint_route_table_ids = [
    module.sider_enterprise_network.route_table_private1_id,
    module.sider_enterprise_network.route_table_private2_id,
  ]
}

module "sider_enterprise_iam_policies" {
  source = "../modules/iam_policies"

  account_id                  = data.aws_caller_identity.current.account_id
  aws_region                  = data.aws_region.current.name
  parameter_store_name_prefix = var.parameter_store_name_prefix
  catpost_bucket_arn          = module.sider_enterprise_s3_buckets.bucket_catpost_arn
  traces_bucket_arn           = module.sider_enterprise_s3_buckets.bucket_traces_arn
}

module "sider_enterprise_cluster" {
  source = "../modules/cluster"

  name   = "sider_enterprise_cluster"
  vpc_id = module.sider_enterprise_network.vpc_id
  vpc_zone_identifier = [
    module.sider_enterprise_network.subnet_private1_id,
    module.sider_enterprise_network.subnet_private2_id,
  ]
  max_size                              = 6
  desired_capacity                      = 2
  image_id                              = "ami-07a63940735aebd38" // amzn2-ami-ecs-hvm-2.0.20200115-x86_64-ebs
  instance_type                         = "r5.large"
  volume_size                           = 100
  allow_calling_ecs_task_definition_arn = module.sider_enterprise_iam_policies.allow_calling_ecs_task_definition_arn
  allow_manage_catpost_s3_arn           = module.sider_enterprise_iam_policies.allow_manage_catpost_s3_arn
  allow_logging_arn                     = module.sider_enterprise_iam_policies.allow_logging_arn
  allow_autoscaling_arn                 = module.sider_enterprise_iam_policies.allow_autoscaling_arn
}

module "sider_enterprise_mysql_password" {
  source = "../modules/random_secret"

  name   = "${var.parameter_store_name_prefix}/mysql_password"
  length = 40
}

module "sider_enterprise_mysql" {
  source = "../modules/mysql"

  vpc_id = module.sider_enterprise_network.vpc_id
  subnet_ids = [
    module.sider_enterprise_network.subnet_private1_id,
    module.sider_enterprise_network.subnet_private2_id,
  ]
  security_group_ids_to_allow = [
    module.sider_enterprise_cluster.instance_security_group_id,
  ]
  username = local.mysql_username
  password = module.sider_enterprise_mysql_password.result
}

module "sider_enterprise_redis_auth_token" {
  source = "../modules/random_secret"

  name   = "${var.parameter_store_name_prefix}/redis_auth_token"
  length = 32
}

module "sider_enterprise_redis" {
  source = "../modules/redis"

  vpc_id = module.sider_enterprise_network.vpc_id
  subnet_ids = [
    module.sider_enterprise_network.subnet_private1_id,
    module.sider_enterprise_network.subnet_private2_id,
  ]
  replication_group_id = "sider-enterprise-cache"
  security_group_ids_to_allow = [
    module.sider_enterprise_cluster.instance_security_group_id,
  ]
  auth_token = module.sider_enterprise_redis_auth_token.result
}
