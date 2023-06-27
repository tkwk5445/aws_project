# ! /usr/bin/env/ bash
# ~/.ssh/known_hosts에 ssh 키 값을 저장하는 목적
#   -p :  password 자동으로 넣어주는 기능     -o strict~:  pingerprint 묻지마라는 뜻
sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.11
sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.12
sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.13