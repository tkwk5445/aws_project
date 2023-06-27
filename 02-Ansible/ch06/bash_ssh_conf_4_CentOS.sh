#! /usr/bin/env bash

now=$(date +"%m_%d_%Y")
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_$now.backup
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
                                    # ssh 접속할때 key방식이 아닌 password방식을 사용하겠다는 말.
systemctl restart sshd
