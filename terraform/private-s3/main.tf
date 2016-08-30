variable "name" {
  type        = "string"
  description = "Name of the S3 Bucket"
}

variable "description" {
  type        = "string"
  description = "Description of the S3 Bucket (for tagging)"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}"
  acl    = "private"

  tags {
    Name = "${var.description}"
  }
}

output "arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}
