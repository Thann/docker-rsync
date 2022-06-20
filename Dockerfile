FROM alpine:latest

VOLUME ["/data"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["rsync", "--no-detach", "--daemon"]

RUN apk upgrade --no-cache && \
    apk add --no-cache rsync openssh lsyncd && \
    echo "root:root" | chpasswd && \
    sed -i s/#PermitRootLogin.*/PermitRootLogin\ without-password/ /etc/ssh/sshd_config && \
    echo -e "Host *\n  StrictHostKeyChecking accept-new" >> /etc/ssh/ssh_config

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
