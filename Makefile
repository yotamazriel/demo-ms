#!/usr/bin/make -f

# Project specific move to .env file
REPO:= gcr.io
REGISTRY := $(REPO)/tensorleap-dev-3
THIS_FILE := $(lastword $(MAKEFILE_LIST))
CMD_ARGUMENTS ?= $(cmd)
# local port
L_PORT:= 300
# container port
C_PORT:= 3000

# Docker Labels
DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
GIT_REPO:= $(shell git remote get-url origin)
GIT_COMMIT := $(shell git rev-parse --short HEAD 2> /dev/null || true)
GIT_BRANCH := $(shell git branch --show-current 2> /dev/null)
IMAGE_TAG := $(GIT_COMMIT)
IMAGE_NAME:= tensorleap-doc

DOCKER := /usr/local/bin/docker
# always remove intermdiate containers
DOCKER_FLAGS += --label docker_build_timestamp=$(DATE)
DOCKER_FLAGS += --label git_repo=$(GIT_REPO)
DOCKER_FLAGS += --label git_branch=$(GIT_BRANCH)
DOCKER_FLAGS += --label git_commit=$(GIT_COMMIT)

# Relase
PATCH_PATH:= 

.PHONY: build
build: Dockerfile
	$(DOCKER) build $(DOCKER_FLAGS) . -t ${REGISTRY}/$(IMAGE_NAME):latest

.PHONY: run
run: | clean build
	$(DOCKER) run -d --name $(IMAGE_NAME)-dev -p $(L_PORT):$(C_PORT) ${REGISTRY}/$(IMAGE_NAME):latest

.PHONY: stop
stop:
	$(DOCKER) stop $(IMAGE_NAME)-dev

#exec: | build
# ifeq ($(CMD_ARGUMENTS),)
# 	# no command is given, default to shell
# 	$(DOCKER) exec -it --name $(IMAGE_NAME)-temp -p $(L_PORT):$(C_PORT) ${REGISTRY}/$(IMAGE_NAME):latest sh
# else
# 	# run extra command using sh -c ""
# 	$(DOCKER) exec -it --name $(IMAGE_NAME)-temp -p $(L_PORT):$(C_PORT) ${REGISTRY}/$(IMAGE_NAME):latest sh -c "$(CMD_ARGUMENTS)"
# endif

clean:
	$(DOCKER) rmi -f ${REGISTRY}/$(IMAGE_NAME):latest

prune:
	# clean all that is not actively used
	docker system prune -af

shell: | build
	$(DOCKER) exec -it ${REGISTRY}/$(IMAGE_NAME):latest -c /bin/sh

.PHONY: tag-release
tag-release: 
	$(DOCKER) tag ${REGISTRY}/$(IMAGE_NAME):latest ${REGISTRY}/$(IMAGE_NAME):$(GIT_COMMIT)

.PHONY: push
push: 
	$(DOCKER) push ${REGISTRY}/$(IMAGE_NAME):latest 
	$(DOCKER) push ${REGISTRY}/$(IMAGE_NAME):$(GIT_COMMIT)

.PHONY: release
release: | build tag-release push

# .PHONY: patch-deploy
# patch-deploy:
# 	cd .deploy/

# .PHONY: deploy
# deploy: | release patch-deploy

# .PHONY: 
# deploy-to-dev: | build tag-release push

usage: help

help:
	@echo ''
	@echo 'Usage: make [TARGET]'
	@echo 'Targets:'
	@echo '  build    	runs clean target then $(DOCKER) build $(DOCKER_FLAGS) .'
	@echo '  clean    	remove docker --image-- for current user: $(DOCKER) rmi -f tensorleap/doc'
	@echo '  run   		runs build target then $(DOCKER) run -d -p $(L_PORT):$(C_PORT) tensorleap/doc'
	@echo '  prune    	shortcut for docker system prune -af. Cleanup inactive containers and cache.'
	@echo '  shell      run docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  release    runs build tag-release push targes'
	@echo ''
	# @echo '  login   	run gcloud login [WIP]'
	# @echo '  test     	test docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
