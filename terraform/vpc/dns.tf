resource "aws_route53_zone" "vpc" {
  name    = "${var.zone_name}"
  vpc_id  = "${aws_vpc.vpc.id}"
  comment = "Private zone for ${var.zone_name}. Managed by Terraform"
}
