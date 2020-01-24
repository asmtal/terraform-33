variable access_key {}
variable secret_key {}

variable awskeypair_name {}
variable image {}
variable region {}
variable bootnode_instance_name {}
variable bootnode_instance_type {}
variable bootnode_count_instances {}
variable bootnode-elb_instance_name {}
variable bootnode-elb_instance_type {}
variable bootnode-elb_count_instances {}
variable infrastructure_name {}
variable operator_instance_name {}
variable operator_instance_type {}
variable operator_count_instances {}
variable owner_instance_name {}
variable owner_instance_type {}
variable owner_count_instances {}

variable availability_zones {
  description = "Avail. Zones for EC2 Instances"
  type        = "list"
}
