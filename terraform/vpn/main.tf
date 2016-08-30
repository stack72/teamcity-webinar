variable "vpc_id" {}
variable "public_subnets" {
  type = "list"
}
variable "key_name" {}
variable "ami" {}
variable "tag_name" {}

resource "aws_security_group" "openvpn" {
    name = "openvpn-sg"
    description = "Security group for Open VPN instances"
    vpc_id = "${var.vpc_id}"

    tags {
        Name = "OpenVPN"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 943
        to_port = 943
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 1194
        to_port = 1194
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "openvpn" {
    ami = "${var.ami}"
    instance_type = "t2.micro"
    subnet_id = "${element(var.public_subnets, 0)}"

    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.openvpn.id}"]
    key_name = "${var.key_name}"
    user_data = "${file("${path.module}/setup.txt")}"

    tags {
        Name = "${format("%s VPN Node", var.tag_name)}"
    }
}

output "vpn_ip" {
    value = "${aws_instance.openvpn.public_ip}"
}
