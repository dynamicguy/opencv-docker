.PHONY: run build login push latest test save

CV ?= 4.6.0
DIST ?= fedora
WORKDIR=/mnt/$$(basename $$(pwd))

run: build test login push

build:
	docker build --build-arg OPENCV_VERSION=$(CV) -t dynamicguy/opencv:$(CV)-$(DIST) ./$(DIST)

push:
	@docker tag dynamicguy/opencv:$(CV)-$(DIST) ghcr.io/dynamicguy/opencv:$(CV)-$(DIST)
	@docker tag dynamicguy/opencv:$(CV)-$(DIST) quay.io/dynamicguy/opencv:$(CV)-$(DIST)
	@docker push dynamicguy/opencv:$(CV)-$(DIST)
	@docker push ghcr.io/dynamicguy/opencv:$(CV)-$(DIST)
	@docker push quay.io/dynamicguy/opencv:$(CV)-$(DIST)

latest:
	@docker pull dynamicguy/opencv:$(CV)-$(DIST)
	@docker tag dynamicguy/opencv:$(CV)-$(DIST) dynamicguy/opencv:latest
	@docker tag dynamicguy/opencv:$(CV)-$(DIST) ghcr.io/dynamicguy/opencv:latest
	@docker tag dynamicguy/opencv:$(CV)-$(DIST) quay.io/dynamicguy/opencv:latest
	@docker push dynamicguy/opencv:latest
	@docker push ghcr.io/dynamicguy/opencv:latest
	@docker push quay.io/dynamicguy/opencv:latest

test:
	@docker run --rm -v $$(pwd):$(WORKDIR) -w $(WORKDIR) dynamicguy/opencv:$(CV)-$(DIST) python3 test.py

save:
	@docker save dynamicguy/opencv:$(CV)-$(DIST) | gzip > dynamicguy_opencv$(CV)-$(DIST).tar.gz
