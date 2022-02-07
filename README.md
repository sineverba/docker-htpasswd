Docker htpasswd
===============

Inspired from [https://github.com/xmartlabs/docker-htpasswd](https://github.com/xmartlabs/docker-htpasswd)

Sick of googling to generate a `htpasswd`?

`$ docker run --rm -ti sineverba/htpasswd <username> <password> > htpasswd`

This will use bcrypt encryption.

| CD / CI   |           |
| --------- | --------- |
| Semaphore CI | [![Build Status](https://sineverba.semaphoreci.com/badges/docker-htpasswd/branches/master.svg)](https://sineverba.semaphoreci.com/projects/docker-htpasswd) |

## Github / image tags and versions

Architectures availables:
+ linux/arm64/v8
+ linux/amd64
+ linux/arm/v6
+ linux/arm/v7 |