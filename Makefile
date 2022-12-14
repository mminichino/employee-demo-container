CONTAINER=empdemo
MAJOR_REV_FILE=major-revision.txt
MINOR_REV_FILE=minor-revision.txt
BUILD_REV_FILE=build-revision.txt

.PHONY: build push

push:
	git pull
	@if ! test -f $(BUILD_REV_FILE); then echo 0 > $(BUILD_REV_FILE); fi
	@echo $$(($$(cat $(BUILD_REV_FILE)) + 1)) > $(BUILD_REV_FILE)
	@if ! test -f $(MAJOR_REV_FILE); then echo 1 > $(MAJOR_REV_FILE); fi
	@if ! test -f $(MINOR_REV_FILE); then echo 0 > $(MINOR_REV_FILE); fi
	$(eval MAJOR_REV := $(shell cat $(MAJOR_REV_FILE)))
	$(eval MINOR_REV := $(shell cat $(MINOR_REV_FILE)))
	$(eval BUILD_REV := $(shell cat $(BUILD_REV_FILE)))
	docker buildx build --platform linux/amd64,linux/arm64 \
	--no-cache \
	-t mminichino/$(CONTAINER):latest \
	-t mminichino/$(CONTAINER):$(MAJOR_REV).$(MINOR_REV).$(BUILD_REV) \
	-f Dockerfile . \
	--push
	git add -A .
	git commit -m "Build version $(MAJOR_REV).$(MINOR_REV).$(BUILD_REV)"
	git push -u origin master
build:
	docker build --force-rm=true --no-cache=true -t $(CONTAINER) -f Dockerfile .
