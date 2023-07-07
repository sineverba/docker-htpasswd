FROM alpine:3.18.2
RUN apk update && \
    apk add --upgrade apk-tools && \
    apk upgrade --available && \
    apk add --update apache2-utils \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["htpasswd", "-Bbn"]