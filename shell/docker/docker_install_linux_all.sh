#!/bin/bash
 


JK_DEVOPS_DIR=/home/jklink-devops/script/
JK_DEVOPS_URL=https://f.9635.com.cn/

mkdir -p ${JK_DEVOPS_DIR}

curl -s -S -L ${JK_DEVOPS_URL}/linux/docker/git_install_linux.sh -o ${JK_DEVOPS_DIR}/git_install_linux.sh 
curl -s -S -L ${JK_DEVOPS_URL}/linux/docker/docker_install_linux_ce.sh -o ${JK_DEVOPS_DIR}/docker_install_linux_ce.sh 
curl -s -S -L ${JK_DEVOPS_URL}/linux/docker/docker_install_linux_set_daemon.sh -o ${JK_DEVOPS_DIR}/docker_install_linux_set_daemon.sh 
curl -s -S -L ${JK_DEVOPS_URL}/linux/docker/docker_install_linux_compose.sh -o ${JK_DEVOPS_DIR}/docker_install_linux_compose.sh 

chmod -R 777 ${JK_DEVOPS_DIR}/

${JK_DEVOPS_DIR}/git_install_linux.sh
${JK_DEVOPS_DIR}/docker_install_linux_ce.sh
${JK_DEVOPS_DIR}/docker_install_linux_set_daemon.sh
${JK_DEVOPS_DIR}/docker_install_linux_compose.sh