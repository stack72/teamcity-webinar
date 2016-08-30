provider "aws" {
  region = "us-west-2"
}

variable "key_name" {
  default = "teamcity-webinar"
}

data "aws_availability_zones" "zones" {}

module "vpc" {
  source = "./vpc"

  vpc_name  = "TeamCity VPC"
  zone_name = "teamcity.local"

  cidr_block      = "192.168.0.0/16"
  private_subnets = ["192.168.1.0/24", "192.168.2.0/24"]
  public_subnets  = ["192.168.10.0/24"]

  availability_zones = ["${data.aws_availability_zones.zones.names}"]
}

variable "openvpn_ami" {
    default = "ami-b7418dd7"
}
module "vpn" {
    source = "./vpn"

    vpc_id = "${module.vpc.vpc_id}"
    public_subnets = ["${module.vpc.public_subnets}"]
    ami = "${var.openvpn_ami}"
    key_name = "${var.key_name}"
    tag_name = "teamcity webinar"
}
output "vpn_setup_command" {
    value = "${format("ssh openvpnas@%s", module.vpn.vpn_ip)}"
}
output "vpn_web_console" {
  value = "${format("https://%s/", module.vpn.vpn_ip)}"
}

module "backup_bucket" {
  source = "./private-s3"

  name        = "terraform-teamcity-backups-bucket-webinar"
  description = "Terraform TeamCity Backups"
}

variable "password" {
  type = "string"
}
variable "username" {
  type = "string"
  default = "teamcityuser"
}
variable "database" {
  type = "string"
  default = "teamcity"
}

module "rds" {
  source = "./rds"

  vpc_id = "${module.vpc.vpc_id}"
  private_subnet_ids = ["${module.vpc.private_subnets}"]

  master_database = "${var.database}"
  root_password = "${var.password}"
  root_username = "${var.username}"
  instance_identifier = "teamcity-rds"

  service_name = "TeamCity"

  zone_id = "${module.vpc.zone_id}"
  dns_name = "pg"
}

module "teamcity" {
  source = "./teamcity"

  service_name = "TeamCity"

  vpc_id = "${module.vpc.vpc_id}"
  private_subnet_ids = ["${module.vpc.private_subnets}"]
  public_subnet_ids = ["${module.vpc.public_subnets}"]

  key_name = "${var.key_name}"
  desired_capacity = "0"

  pg_url = "${module.rds.database_address}"
  pg_username = "${var.username}"
  pg_password = "${var.password}"
  pg_database = "${var.database}"
}
