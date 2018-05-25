#!make

.DEFAULT_GOAL := help
.PHONY: *
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

ifeq (BRANCH,'master')
	PREFIX=
else
	PREFIX=$(BRANCH)-
endif

include env.makefile

help:
	@echo "\033[33mUsage:\033[0m\n  make [target] [arg=\"val\"...]\n\n\033[33mTargets:\033[0m"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build image. Usage: make build TAG="7.2.x" PHP_VERSION="..." ...
	docker build --no-cache \
		--tag yejune/webserver:$(PREFIX)$(TAG) \
		--build-arg REPOGITORY_URL="$(REPOGITORY_URL)" \
		--build-arg PHP_VERSION="$(PHP_VERSION)" \
		--build-arg PHP_GPGKEYS="$(PHP_GPGKEYS)" \
		--build-arg PHP_SHA256="$(PHP_SHA256)" \
		--build-arg BUILD_EXTENSIONS="$(EXTENSIONS)" \
		--build-arg LIBRARY_V8_VERSION=$(LIBRARY_V8_VERSION) \
		--build-arg LIBRARY_RABBITMQ_VERSION=$(LIBRARY_RABBITMQ_VERSION) \
		--build-arg EXTENSION_YAML_VERSION=$(EXTENSION_YAML_VERSION) \
		--build-arg EXTENSION_IGBINARY_VERSION=$(EXTENSION_IGBINARY_VERSION) \
		--build-arg EXTENSION_MSGPACK_VERSION=$(EXTENSION_MSGPACK_VERSION) \
		--build-arg EXTENSION_APCU_VERSION=$(EXTENSION_APCU_VERSION) \
		--build-arg EXTENSION_MEMCACHED_VERSION=$(EXTENSION_MEMCACHED_VERSION) \
		--build-arg EXTENSION_REDIS_VERSION=$(EXTENSION_REDIS_VERSION) \
		--build-arg EXTENSION_MONGODB_VERSION=$(EXTENSION_MONGODB_VERSION) \
		--build-arg EXTENSION_IMAGICK_VERSION=$(EXTENSION_IMAGICK_VERSION) \
		--build-arg EXTENSION_UUID_VERSION=$(EXTENSION_UUID_VERSION) \
		--build-arg EXTENSION_EV_VERSION=$(EXTENSION_EV_VERSION) \
		--build-arg EXTENSION_UV_VERSION=$(EXTENSION_UV_VERSION) \
		--build-arg EXTENSION_SSH2_VERSION=$(EXTENSION_SSH2_VERSION) \
		--build-arg EXTENSION_PHALCON_VERSION=$(EXTENSION_PHALCON_VERSION) \
		--build-arg EXTENSION_SODIUM_VERSION=$(EXTENSION_SODIUM_VERSION) \
		--build-arg EXTENSION_SQLSRV_VERSION=$(EXTENSION_SQLSRV_VERSION) \
		--build-arg EXTENSION_GEARMAN_VERSION=$(EXTENSION_GEARMAN_VERSION) \
		--build-arg EXTENSION_AMQP_VERSION=$(EXTENSION_AMQP_VERSION) \
		--build-arg EXTENSION_V8JS_VERSION=$(EXTENSION_V8JS_VERSION) \
		--build-arg EXTENSION_V8_VERSION=$(EXTENSION_V8_VERSION) \
		--build-arg EXTENSION_SCREWIM_VERSION=$(EXTENSION_SCREWIM_VERSION) \
		--build-arg EXTENSION_SWOOLE_VERSION=$(EXTENSION_SWOOLE_VERSION) \
		--build-arg EXTENSION_HTTP_VERSION=$(EXTENSION_HTTP_VERSION) \
		--build-arg EXTENSION_XDEBUG_VERSION=$(EXTENSION_XDEBUG_VERSION) \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--file $(DOCKERFILE) \
	.

	@make test TAG="$(TAG)"

build-71: ## Build PHP 7.1 images
	@make build \
		EXTENSIONS="$(FULL_EXTENSIONS)" \
		PHP_VERSION="$(PHP71_VERSION)" \
		PHP_GPGKEYS="$(PHP71_GPGKEYS)" \
		PHP_SHA256="$(PHP71_SHA256)" \
		TAG="$(PHP71_VERSION)" \
		DOCKERFILE="Dockerfile"

	@make build \
		EXTENSIONS="$(MINI_EXTENSIONS)" \
		PHP_VERSION="$(PHP71_VERSION)" \
		PHP_GPGKEYS="$(PHP71_GPGKEYS)" \
		PHP_SHA256="$(PHP71_SHA256)" \
		TAG="$(PHP71_VERSION)-mini" \
		DOCKERFILE="Dockerfile"

build-72: ## Build PHP 7.2 images
	@make build \
		EXTENSIONS="$(FULL_EXTENSIONS)" \
		PHP_VERSION="$(PHP72_VERSION)" \
		PHP_GPGKEYS="$(PHP72_GPGKEYS)" \
		PHP_SHA256="$(PHP72_SHA256)" \
		TAG="$(PHP72_VERSION)" \
		DOCKERFILE="Dockerfile"

	@make build \
		EXTENSIONS="$(MINI_EXTENSIONS)" \
		PHP_VERSION="$(PHP72_VERSION)" \
		PHP_GPGKEYS="$(PHP72_GPGKEYS)" \
		PHP_SHA256="$(PHP72_SHA256)" \
		TAG="$(PHP72_VERSION)-mini" \
		DOCKERFILE="Dockerfile"

build-test: ## Build PHP 7.2 image. Usage: make build-test tag="test11"
	@make build \
		EXTENSIONS="$(FULL_EXTENSIONS)" \
		PHP_VERSION="$(PHP72_VERSION)" \
		PHP_GPGKEYS="$(PHP72_GPGKEYS)" \
		PHP_SHA256="$(PHP72_SHA256)" \
		TAG="$(tag)" \
		DOCKERFILE="Dockerfile"

	@docker push yejune/webserver:$(PREFIX)$(tag)

build-test-file: ## Dockerfile.test 로 빌드. Usage: make build-test-file tag="test11"
	docker build \
		--tag yejune/webserver:$(PREFIX)$(tag) \
		--file Dockerfile.test \
	.

	@docker push yejune/webserver:$(PREFIX)$(tag)

build-all: ## Build all images
	@make build-71
	@make build-72

push-71: ## Push built PHP 7.1 images to Docker Hub
	@docker push yejune/webserver:$(PREFIX)$(PHP71_VERSION)
	@docker push yejune/webserver:$(PREFIX)$(PHP71_VERSION)-mini

push-72: ## Push built PHP 7.2 images to Docker Hub
	@docker push yejune/webserver:$(PREFIX)$(PHP72_VERSION)
	@docker push yejune/webserver:$(PREFIX)$(PHP72_VERSION)-mini
	# @docker tag yejune/webserver:$(PREFIX)$(PHP72_VERSION) yejune/webserver:$(PREFIX)latest
	# @docker push yejune/webserver:$(PREFIX)latest

push-all: ## Push all built images to Docker Hub
	@make push-71
	@make push-72

build-and-push-71: ## Build and push PHP 7.1 images to Docker Hub
	@make build-71
	@make push-71

build-and-push-72: ## Build and push PHP 7.2 images to Docker Hub
	@make build-72
	@make push-72

build-and-push: ## Build all images and push them to Docker Hub
	@make build-all
	@make push-all

test:
	@if [ ! -z "$(shell docker ps | grep 8111 | awk '{ print $(1) }')" ]; then docker rm -f test-webserver > /dev/null; fi
	@#docker rm -f test-webserver > /dev/null 2>&1 || true
	docker run --rm -d --name=test-webserver -p 8111:80 yejune/webserver:$(PREFIX)$(TAG)
	wget --spider --tries 10 --retry-connrefused --no-check-certificate -T 5 http://localhost:8111
	curl --retry 10 --retry-delay 5 -L -I http://localhost:8111 | grep "200 OK"
	docker kill test-webserver

test-all: ## 테스트
	@make test-71
	@make test-72

test-71:
	@make test TAG="$(PHP71_VERSION)"
	@make test TAG="$(PHP71_VERSION)-mini"

test-72:
	@make test TAG="$(PHP72_VERSION)"
	@make test TAG="$(PHP72_VERSION)-mini"

clean: ## Clean all containers and images on the system
	-@docker ps -a -q | xargs docker rm -f
	-@docker images -q | xargs docker rmi -f
