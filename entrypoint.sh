#!/bin/bash

echo -e "Host ${SSH_HOST}\n\tUser ${SSH_USER}\n\tStrictHostKeyChecking no" > ~/.ssh/config

sshpass -p "${SSH_PASS}" ssh -o StrictHostKeyChecking=no "${SSH_USER}@${SSH_HOST}" "cd ${FOLDER} && echo 'Ejecutando comandos en el servidor.' > log.txt"
