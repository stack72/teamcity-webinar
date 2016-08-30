ami:
	packer build \
		-var "source_ami=ami-9ece19fe" \
		-var "region=us-west-2" \
		-var "subnet_id=subnet-7d8ef70b"\
		-var "security_group_id=sg-1650b06f"\
		teamcity.json

.PHONY: ami
