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
  description = "List of Private Subnet IDs for the Subnet Group"
}

variable "instance_identifier" {
  type        = "string"
  description = "The identifier of the RDS Instance"
}

variable "allocated_storage" {
  type        = "string"
  default     = "60"
  description = "The Storage Allocated to the RDS Instance"
}

variable "storage_type" {
  type        = "string"
  default     = "gp2"
  description = "The Storage Type for the RDS Instance"
}

variable "instance_class" {
  type        = "string"
  default     = "db.m3.medium"
  description = "The Instance class for the RDS Instance"
}

variable "master_database" {
  type        = "string"
  description = "The Name of the Master Database for the RDS Instance"
}

variable "root_username" {
  type        = "string"
  description = "The Root Username for the RDS Instance"
}

variable "root_password" {
  type        = "string"
  description = "The Root Password for the RDS Instance"
}

variable "zone_id" {
  type = "string"
  description = "The zone to create the DNS entry"
}

variable "dns_name" {
  type = "string"
  description = "The logical DNS name to give the database"
}

output "database_address" {
  value = "${replace(aws_db_instance.database.endpoint, ":5432", "")}"
}

output "database_r53_record" {
  value = "${aws_route53_record.rds_cname.fqdn}"
}
