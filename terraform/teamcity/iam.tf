resource "aws_iam_role" "teamcity_server" {
    name = "TeamCityServer"
    assume_role_policy = "${file("${path.module}/policies/assume-role-policy.json")}"
}

resource "aws_iam_instance_profile" "teamcity_server" {
    name = "TeamCityServer"
    roles = ["${aws_iam_role.teamcity_server.name}"]
}
