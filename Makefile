include .env

build:
	@echo Build a docker images $(PROJECT):$(DOCKERTAG)
	docker build -t $(PROJECT):$(DOCKERTAG) .
	@echo Listings docker images from project $(PROJECT)
	docker images $(PROJECT)

publish:
	@echo Push a new version on GitHub of $(PROJECT)
	docker tag $(PROJECT):$(DOCKERTAG) ghcr.io/$(OWNER)/$(PROJECT):$(DOCKERTAG)
	echo $(CR_PAT) | docker login ghcr.io -u $(OWNER) --password-stdin
	docker push ghcr.io/$(OWNER)/$(PROJECT):$(DOCKERTAG)

validate:
	@echo Running tests on $(PROJECT)
	docker run -ti $(PROJECT):$(DOCKERTAG) python /tmp/chrome.py || exit 1;
	docker run -ti $(PROJECT):$(DOCKERTAG) python /tmp/firefox.py || exit 1;

all: build validate publish

