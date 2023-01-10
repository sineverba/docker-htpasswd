FROM alpine:3.17.1
RUN apk update && \
    apk add --upgrade apk-tools && \
    apk upgrade --available && \
    apk add --update apache2-utils \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["htpasswd", "-Bbn"]