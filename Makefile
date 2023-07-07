IMAGE_NAME=sineverba/htpasswd
CONTAINER_NAME=htpasswd
APP_VERSION=1.3.0-dev
BUILDX_VERSION=0.11.1
BINFMT_VERSION=qemu-v7.0.0-28

build:
	docker build --tag $(IMAGE_NAME):$(APP_VERSION) "."

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
	
multi:
	docker buildx inspect --bootstrap --builder multiarch
	docker buildx build \
		--platform linux/arm64/v8,linux/amd64,linux/arm/v6,linux/arm/v7 \
		--tag $(IMAGE_NAME):$(APP_VERSION) "."

test:
	docker run --rm -it --entrypoint cat $(IMAGE_NAME):$(APP_VERSION) /etc/os-release | grep "3.18.2"
	docker run --rm -ti $(IMAGE_NAME):$(APP_VERSION) docker docker > htpasswd && cat htpasswd | grep "docker"
	rm htpasswd

destroy:
	docker image rm alpine:3.18.2
	docker image rm $(IMAGE_NAME):$(APP_VERSION)