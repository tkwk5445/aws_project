#! /usr/bin/env bash

sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.11
sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.12
sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.1302-Ansible/CentOS노드추가/add_ssh_auth.sh 02-Ansible/CentOS노드추가/ansible_env_ready.yml 02-Ansible/CentOS노드추가/bash_ssh_conf_4_CentOS.sh 02-Ansible/CentOS노드추가/nginx_install.yml 02-Ansible/CentOS노드추가/nginx_remove.yml 02-Ansible/CentOS노드추가/Vagrantfile