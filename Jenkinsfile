#!/bin/bash
set -xe

cd Terraform

sed -i "s/server_name/${SERVER_NAME}/g" backend.tf
export TF_VAR_name=${SERVER_NAME}

terraform init
terraform plan
terraform $TERRAFORM_ACTION -auto-approve

sleep 60

if [ $TERRAFORM_ACTION = "destroy" ]; then
	exit 0
else
	cd ../Ansible
        pip install boto3 --break-system-packages
	ansible-playbook -i /opt/aws_ec2.yaml apache.yaml 
fi
