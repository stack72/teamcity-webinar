variable "service_name" {
  type        = "string"
  description = "Name of the RDS service (for tagging)"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID in which to deploy RDS"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "List of Private Subnet IDs for the AutoScaling Group"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "List of Public Subnet IDs for the ELB"
}

variable "instance_type" {
  type        = "string"
  description = "The instance_type from which to build the server"
  default     = "m4.large"
}

variable "volume_size" {
  type        = "string"
  description = "The size of the EBS volume to attach build the server"
  default     = "50"
}

variable "key_name" {
  type        = "string"
  description = "The name of the ssh key to attach to the instance"
}

variable "min_size" {
  default = "0"
  description = "The minimum nodes in the AutoScaling Group"
  type = "string"
}

variable "max_size" {
  default = "2"
  description = "The maximum nodes in the AutoScaling Group"
  type = "string"
}

variable "desired_capacity" {
  description = "The number of running nodes expected in the Autoscaling Group"
  type = "string"
}

variable "pg_url" {
  type = "string"
  description = "The URL of the RDS instance"
}

variable "pg_port" {
  type = "string"
  description = "The port of the RDS instance"
  default = "5432"
}

variable "pg_database" {
  type = "string"
  description = "The name of the RDS master database"
}

variable "pg_username" {
  type = "string"
  description = "The user of the RDS instance"
}

variable "pg_username" {
  type = "string"
  description = "The user of the RDS instance"
}

variable "pg_password" {
  type = "string"
  description = "The password of the RDS instance"
}

output "server_address" {
  value = "${aws_elb.teamcity_elb.dns_name}"
}
