#!/bin/bash

## Installing ansible and stuff

YUM_CMD=$(which yum)
APT_CMD=$(which apt)

if [[ ! -z $YUM_CMD ]]; then
     echo
     echo "Installing pip and libs and check ruby...."
     sudo yum update -y >/dev/null
     sudo yum install -y python-pip gcc libffi-devel python-devel openssl-devel ruby >/dev/null
elif [[ ! -z $APT_CMD ]]; then
     echo
     echo "Installing pip and libs and check ruby...."
     sudo apt-get update -y >/dev/null
     sudo apt-get install -y python-pip build-essential libssl-dev libffi-dev python-dev ruby >/dev/null
else
    echo "error, script supports only yum and apt, and you should run it from bash shell"
    exit 1;
fi

echo
echo "Installing pip modules and ansible...."
sudo pip install -U pip >/dev/null
sudo pip install -U setuptools boto >/dev/null
sudo pip install cryptography markupsafe >/dev/null
sudo pip install ansible >/dev/null

## Running ansible playbooks
# AWS chef-server instance up
echo
echo "Runinng ansible-playbook aws_instance_up..."
ansible-playbook aws_instance_up.yml

if [ $? -eq 0 ]; then
    echo
    echo "Runinng ansible-playbook which will install chef-server on the new instance..."
else
    echo "Something went wrong, can't continue :/"
    exit 1
fi

# AWS chef-server install
ansible-playbook -i ec2.py -u ubuntu -l tag_Name_chef_server aws_chef_server_install.yml 

# Localhost install (chef DK)
ansible-playbook workstation_chef_DK.yml
######

