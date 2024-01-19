FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-client sshpass

COPY ./entrypoint.sh /bin/entrypoint.sh
WORKDIR /

RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]