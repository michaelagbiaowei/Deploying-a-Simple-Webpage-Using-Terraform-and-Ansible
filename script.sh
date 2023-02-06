# Using bash script to automate the execution of terraform and ansible on AWS Cloud9

#!/bin/bash

#cd /home/ec2-user/Deploying-a-Simple-Webpage-Using-Terraform-and-Ansible/infra_prov_with_terraform

 #sudo terraform init

#sudo terraform plan --out output.tfplan

#sudo terraform apply "output.tfplan"

##############################################################################

#sudo amazon-linux-extras install ansible2 -y


cd /home/ec2-user/Deploying-a-Simple-Webpage-Using-Terraform-and-Ansible/config_mgt_with_ansible

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i inventory configs.yml --private-key=Ifiekemi1990.pem -v
