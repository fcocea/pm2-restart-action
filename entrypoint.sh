#!/bin/bash

if [ -z "${SSH_HOST}" ]; then
  echo "ERROR | SSH_HOST is not set."
  exit 1
fi
if [ -z "${SSH_PASS}" ]; then
  echo "ERROR | SSH_PASS is not set."
  exit 1
fi
if [ -z "${SSH_USER}" ]; then
  echo "ERROR | SSH_USER is not set."
  exit 1
fi

if [ -z "${FOLDER}" ]; then
  echo "ERROR | FOLDER is not set."
  exit 1
fi

if [ -z "${PM2_SERVICE}" ]; then
  echo "ERROR | PM2_SERVICE is not set."
  exit 1
fi

PNPM="/${SSH_USER}/.local/share/pnpm/pnpm"
SSH_COMMANDS=$(cat << EOF
if [ ! -d "${FOLDER}" ]; then
  echo "ERROR | The folder ${FOLDER} does not exist. Closing SSH connection."
  exit 1
fi
cd ${FOLDER}
PM2_EXIST=\$(if pm2 list 2> /dev/null | grep -q ${PM2_SERVICE}; then echo 1; else echo 0 ; fi)
if [ "\${PM2_EXIST}" -eq 0 ]; then
  echo "ERROR | PM2 service \${PM2_SERVICE} does not exist."
  exit 1
fi
if ! git rev-parse --verify ${REPO_BRANCH} > /dev/null 2>&1; then
  echo "ERROR | Branch ${REPO_BRANCH} does not exist. Exiting."
  exit 1
fi
git checkout \${REPO_BRANCH}
git pull
${PNPM} i
${PNPM} build
pm2 restart ${PM2_SERVICE} -s
echo "SUCCESS | Deployment completed."
EOF
)

sshpass -p ${SSH_PASS} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${SSH_USER}@${SSH_HOST}:${SSH_PORT} "$SSH_COMMANDS"
SSH_EXIT_CODE=$?
if [ $SSH_EXIT_CODE -ne 0 ]; then
  echo "SSH command failed. Exiting."
  exit 1
fi