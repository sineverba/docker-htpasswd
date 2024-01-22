# Define base env
ARG ALPINE_VERSION=3.19.0
# Get Image
FROM alpine:${ALPINE_VERSION}
RUN apk update && \
    apk add --upgrade apk-tools && \
    apk upgrade --available --no-cache && \
    apk add --update apache2-utils \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["htpasswd", "-Bbn"]