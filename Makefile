build:
	docker build --tag sineverba/testdockerhtpasswd .

multiple:
	mkdir -vp ~/.docker/cli-plugins/
	curl --silent -L "https://github.com/docker/buildx/releases/download/v0.5.1/buildx-v0.5.1.linux-amd64" > ~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx
	docker buildx version
	docker run --rm --privileged tonistiigi/binfmt:latest --install all
	docker buildx ls
	docker buildx create --name multiarch --driver docker-container --use
	docker buildx inspect --bootstrap --builder multiarch
	docker buildx build --platform linux/arm64/v8,linux/amd64,linux/arm/v6,linux/arm/v7 --tag sineverba/htpasswd:1.1.0 --push .

test:
	docker run --rm -ti sineverba/testdockerhtpasswd docker docker > htpasswd && cat htpasswd | grep "docker"

destroy:
	docker image rm sineverba/testdockerhtpasswd