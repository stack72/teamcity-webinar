resource "aws_security_group" "teamcity_server" {
  name = "teamcity-sg"
  description = "${var.service_name} Security Group"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 8111
    to_port   = 8111
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.service_name} Security Group"
  }
}

resource "aws_security_group" "teamcity_elb" {
  name = "teamcity-elb-sg"
  description = "${var.service_name} ELB Security Group"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.service_name} ELB Security Group"
  }
}

resource "aws_elb" "teamcity_elb" {
  name = "teamcity-elb"
  subnets = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.teamcity_elb.id}"]
  cross_zone_load_balancing = true
  connection_draining = true
  internal = false

  listener {
    instance_port      = 8111
    instance_protocol  = "tcp"
    lb_port            = 80
    lb_protocol        = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    target              = "TCP:8111"
    timeout             = 5
  }
}

data "template_file" "teamcity_userdata" {
  template = "${file("${path.module}/scripts/setup.sh")}"

  vars {
    pg_url      = "${var.pg_url}"
    pg_port     = "${var.pg_port}"
    pg_database = "${var.pg_database}"
    pg_username = "${var.pg_username}"
    pg_password = "${var.pg_password}"
  }
}

data "aws_ami" "teamcity_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["teamcity*"]
  }
}

resource "aws_launch_configuration" "teamcity_server_launch_config" {
  image_id = "${data.aws_ami.teamcity_ami.id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.teamcity_server.name}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.teamcity_server.id}"]
  user_data = "${data.template_file.teamcity_userdata.rendered}"
  enable_monitoring = true

  root_block_device {
    volume_size = "${var.volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "teamcity_server_autoscale_group" {
  name = "teamcity-server-autoscale-group"
  vpc_zone_identifier = ["${var.private_subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.teamcity_server_launch_config.id}"
  desired_capacity = "${var.desired_capacity}"
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  health_check_grace_period = "60"
  health_check_type = "EC2"
  load_balancers = ["${aws_elb.teamcity_elb.name}"]

  tag {
    key = "Name"
    value = "teamcity-server"
    propagate_at_launch = true
  }
}
