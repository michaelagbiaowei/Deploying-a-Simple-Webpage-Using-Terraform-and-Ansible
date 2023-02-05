# Using bash script to automate the execution of terraform and ansible

#!/bin/bash

sudo infra_prov_with_terraform/terraform init

sudo infra_prov_with_terraform/terraform plan --out output.tfplan

sudo infra_prov_with_terraform/terraform apply "output.tfplan"

##############################################################################

config_mgt_with_absible/ansible-playbook -i inventory configs.yml -v