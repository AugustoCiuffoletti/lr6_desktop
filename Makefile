OWNER = mastrogeppetto
IMAGE  ?= lr6_desktop
TAG   ?= latest
# arm64 or amd64
ARCH ?= amd64

# push everything and create multiarch manifest
multiarch:
	ARCH=arm64 make push
	ARCH=amd64 make push
	docker manifest create \
		$(OWNER)/$(IMAGE):$(TAG) \
		--amend $(OWNER)/$(IMAGE):amd64-$(TAG) \
		--amend $(OWNER)/$(IMAGE):arm64-$(TAG)
	docker manifest push $(OWNER)/$(IMAGE):$(TAG)
# push an image on dockerhub
push:
	ARCH=$(ARCH) make build
	docker push $(OWNER)/$(IMAGE):$(ARCH)-$(TAG)
# build a loval image
build:
	cp Dockerfile Dockerfile.$(ARCH)
	docker buildx build --load --platform linux/$(ARCH) -t $(OWNER)/$(IMAGE):$(ARCH)-$(TAG) -f Dockerfile.$(ARCH) .
# test run
run: 
	docker run \
		-v $(shell pwd)/shared:/shared \
		-h desktop \
		-it \
		--rm \
		--privileged \
		-p 6080:6080 \
		-h 2022:22 \
		$(IMAGE):$(ARCH)-$(TAG)
# Remove images
clean:
	docker rmi $(IMAGE):$(ARCH)-$(TAG)
	docker image prune -f
