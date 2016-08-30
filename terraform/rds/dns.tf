resource "aws_route53_record" "rds_cname" {
  zone_id = "${var.zone_id}"
  name = "${var.dns_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${replace(aws_db_instance.database.endpoint, ":5432", "")}"]
}
