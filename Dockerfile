FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-client sshpass

COPY entrypoint.sh /entrypoint.sh
WORKDIR /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]