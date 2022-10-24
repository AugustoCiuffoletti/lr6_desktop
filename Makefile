IMAGE=novnc
ARCH=amd64

build:
	docker build -t $(IMAGE):$(ARCH) .
run: 
	docker run -it --rm -p 5901:5901 -p 6080:6080 $(IMAGE):$(ARCH) /bin/bash

