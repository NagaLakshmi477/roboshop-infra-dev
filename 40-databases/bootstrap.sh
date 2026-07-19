#!/bin/bash
component=$1
dnf install ansible -y
ansible-pull -U https://github.com/NagaLakshmi477/terraform-ansible-roles.git -e component=$1 main.yaml