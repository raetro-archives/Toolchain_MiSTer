NAME = misterkun/toolchain
VERSION = 0.2.0
BUILD_DATE = `date -u +"%Y-%m-%dT%H:%M:%SZ"`
VCS_REF = `git rev-parse --short HEAD`

.PHONY: help build build-nocache tag-latest push push-latest release git-tag-version run

help:
	@echo ""
	@echo "════════════════════════════════════════════════════════════════════════════════"
	@echo " MiSTerKüN.io - Help Menu                                                       "
	@echo "════════════════════════════════════════════════════════════════════════════════"
	@echo " 1. make build           - build $(NAME)"
	@echo " 2. make build-nocache   - build $(NAME) without caching"
	@echo " 3. make tag-latest      - add tag $(NAME):latest"
	@echo " 5. make push            - push $(NAME):$(VERSION) to registry"
	@echo " 6. make push-latest     - push $(NAME):latest to registry"
	@echo " 7. make release         - create a release and push to registry"
	@echo " 8. make run             - launch and log into $(NAME)"
	@echo "════════════════════════════════════════════════════════════════════════════════"
	@echo ""

build:
	docker build --build-arg VCS_REF=$(VCS_REF) --build-arg BUILD_VERSION=$(VERSION) --build-arg BUILD_DATE=$(BUILD_DATE) -t $(NAME):$(VERSION) --force-rm --compress image

build-nocache:
	docker build --build-arg VCS_REF=$(VCS_REF) --build-arg BUILD_VERSION=$(VERSION) --build-arg BUILD_DATE=$(BUILD_DATE) -t $(NAME):$(VERSION) --no-cache --force-rm --compress image

tag-latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME):$(VERSION)

push-latest:
	docker push $(NAME):latest

release: build tag-latest push push-latest

git-tag-version: release
	git tag -a v$(VERSION) -m "v$(VERSION)"
	git push origin v$(VERSION)

run:
	docker run -it --rm -v ${pwd}:/mister $(NAME):latest
