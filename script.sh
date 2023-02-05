# Using bash script to automate the execution of terraform and ansible

#!/bin/bash

cd infra_prov_with_terraform/

sudo terraform init

sudo terraform plan --out output.tfplan

sudo terraform apply "output.tfplan"

##############################################################################

cd ../config_mgt_with_absible/

ansible-playbook -i inventory configs.yml -v