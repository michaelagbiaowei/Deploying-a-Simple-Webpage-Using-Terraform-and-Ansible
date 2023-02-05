# Using bash script to automate the execution of terraform and ansible on AWS Cloud9

#!/bin/bash

# cd /home/ec2-user/environment/Deploying-a-Simple-Webpage-Using-Terraform-and-Ansible/infra_prov_with_terraform

# sudo terraform init

# sudo terraform plan --out output.tfplan

# sudo terraform apply "output.tfplan"

##############################################################################

# sudo yum install ansible -y

cd /home/ec2-user/environment/Deploying-a-Simple-Webpage-Using-Terraform-and-Ansible/config_mgt_with_ansible

ansible-playbook -i inventory configs.yml -v