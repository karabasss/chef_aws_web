#!/bin/bash

YUM_CMD=$(which yum)
APT_CMD=$(which apt)

if [[ ! -z $YUM_CMD ]]; then
     echo "Installing pip and libs...."
     sudo yum update -y >/dev/null
     sudo yum install -y python-pip gcc libffi-devel python-devel openssl-devel >/dev/null
elif [[ ! -z $APT_CMD ]]; then
     echo "Installing pip and libs...."
     sudo apt update -y >/dev/null
     sudo apt install -y python-pip build-essential libssl-dev libffi-dev python-dev >/dev/null
else
    echo "error, script supports only yum and apt, and you should run it from bash shell"
    exit 1;
fi

echo "Installing pip modules and ansible...."
sudo pip install --upgrade pip >/dev/null
sudo pip install --upgrade setuptools >/dev/null
sudo pip install cryptography >/dev/null
sudo pip install markupsafe >/dev/null
sudo pip install boto >/dev/null
sudo pip install ansible >/dev/null

echo "Runinng ansible-playbook aws_instance_up..."
ansible-playbook aws_instance_up.yml

