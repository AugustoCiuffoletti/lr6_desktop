IMAGE=novnc
ARCH=amd64

build:
	docker build -t $(IMAGE):$(ARCH) .
run: 
	docker run -v $(shell pwd)/shared:/shared -h desktop -it --rm --privileged -p 6080:6080 -h 2022:22 $(IMAGE):$(ARCH)

