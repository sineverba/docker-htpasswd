IMAGE_NAME=sineverba/htpasswd
CONTAINER_NAME=htpasswd
APP_VERSION=1.4.0-dev
ALPINE_VERSION=3.19.0
BUILDX_VERSION=0.12.1
BINFMT_VERSION=qemu-v7.0.0-28

build:
	docker build \
		--no-cache \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--build-arg SQLITE_VERSION=$(SQLITE_VERSION) \
		--tag $(IMAGE_NAME):$(APP_VERSION) \
		"."

inspect:
	docker run \
		--rm \
		-it \
		--entrypoint /bin/sh \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME):$(APP_VERSION)

preparemulti:
	mkdir -vp ~/.docker/cli-plugins
	curl \
		-L \
		"https://github.com/docker/buildx/releases/download/v$(BUILDX_VERSION)/buildx-v$(BUILDX_VERSION).linux-amd64" \
		> \
		~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx
	docker buildx version
	docker run --rm --privileged tonistiigi/binfmt:$(BINFMT_VERSION) --install all
	docker buildx ls
	docker buildx rm multiarch
	docker buildx create --name multiarch --driver docker-container --use
	docker buildx inspect --bootstrap --builder multiarch
	
multi: preparemulti
	docker buildx build \
		--platform linux/arm64/v8,linux/amd64,linux/arm/v6,linux/arm/v7 \
		--tag $(IMAGE_NAME):$(APP_VERSION) "."

test:
	docker run --rm -it --entrypoint cat $(IMAGE_NAME):$(APP_VERSION) /etc/os-release | grep $(ALPINE_VERSION)
	docker run --rm -ti $(IMAGE_NAME):$(APP_VERSION) docker docker > htpasswd && cat htpasswd | grep "docker"
	rm htpasswd

destroy:
	-docker image rm alpine:$(ALPINE_VERSION)
	docker image rm $(IMAGE_NAME):$(APP_VERSION)