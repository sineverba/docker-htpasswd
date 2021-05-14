FROM alpine:3.13.5

RUN apk add --update apache2-utils \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["htpasswd", "-Bbn"]