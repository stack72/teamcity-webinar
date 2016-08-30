ssh-key:
	ssh-keygen -t rsa -C "demo_ssh_key" -P '' -f modules/terraform/ssh_key/key; chmod 400 modules/terraform/ssh_key/key.pub
