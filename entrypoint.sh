#!/bin/bash

CMD="cd ${FOLDER} git checkout ${REPO_BRANCH} && git pull origin ${REPO_BRANCH} && pnpm i && pnpm build && pm2 restart ${PM2_SERVICE}"

sshpass -p "${SSH_PASS}" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${SSH_USER}@${SSH_HOST}" ${CMD}
