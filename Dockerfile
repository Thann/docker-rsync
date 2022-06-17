FROM alpine:latest

VOLUME ["/data"]
CMD ["rsyncd"]

RUN apk upgrade --no-cache && \
    apk add --no-cache rsync openssh-client lsyncd

COPY rsyncd /usr/local/bin/
