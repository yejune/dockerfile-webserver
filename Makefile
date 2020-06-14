#!make

.DEFAULT_GOAL := help
.PHONY: *
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

ifeq (BRANCH,'master')
	PREFIX=
else
	PREFIX=$(BRANCH)-
endif

OSFLAG :=
ifeq ($(OS),Windows_NT)
	OSFLAG += WIN
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OSFLAG += LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
		OSFLAG += OSX
	endif

	# UNAME_P := $(shell uname -p)
	# ifeq ($(UNAME_P),x86_64)
	# 	OSFLAG += AMD64
	# endif
	# 	ifneq ($(filter %86,$(UNAME_P)),)
	# OSFLAG += IA32
	# 	endif
	# ifneq ($(filter arm%,$(UNAME_P)),)
	# 	OSFLAG += ARM
	# endif
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
		--build-arg EXTENSION_PHALCON_VERSION=$(EXTENSION_PHALCON_VERSION) \
		--build-arg EXTENSION_SWOOLE_VERSION=$(EXTENSION_SWOOLE_VERSION) \
		--build-arg EXTENSION_UUID_VERSION=$(EXTENSION_UUID_VERSION) \
		--build-arg EXTENSION_YAML_VERSION=$(EXTENSION_YAML_VERSION) \
		--build-arg EXTENSION_JSONNET_VERSION=$(EXTENSION_JSONNET_VERSION) \
		--build-arg EXTENSION_PROTOBUF_VERSION=$(EXTENSION_PROTOBUF_VERSION) \
		--build-arg EXTENSION_IGBINARY_VERSION=$(EXTENSION_IGBINARY_VERSION) \
		--build-arg EXTENSION_MSGPACK_VERSION=$(EXTENSION_MSGPACK_VERSION) \
		--build-arg EXTENSION_MAILPARSE_VERSION=$(EXTENSION_MAILPARSE_VERSION) \
		--build-arg EXTENSION_BASE58_VERSION=$(EXTENSION_BASE58_VERSION) \
		--build-arg EXTENSION_APCU_VERSION=$(EXTENSION_APCU_VERSION) \
		--build-arg EXTENSION_MEMCACHED_VERSION=$(EXTENSION_MEMCACHED_VERSION) \
		--build-arg EXTENSION_REDIS_VERSION=$(EXTENSION_REDIS_VERSION) \
		--build-arg EXTENSION_MONGODB_VERSION=$(EXTENSION_MONGODB_VERSION) \
		--build-arg EXTENSION_RDKAFKA_VERSION=$(EXTENSION_RDKAFKA_VERSION) \
		--build-arg EXTENSION_AMQP_VERSION=$(EXTENSION_AMQP_VERSION) \
		--build-arg EXTENSION_GEARMAN_VERSION=$(EXTENSION_GEARMAN_VERSION) \
		--build-arg EXTENSION_SODIUM_VERSION=$(EXTENSION_SODIUM_VERSION) \
		--build-arg EXTENSION_MCRYPT_VERSION=$(EXTENSION_MCRYPT_VERSION) \
		--build-arg EXTENSION_SCREWIM_VERSION=$(EXTENSION_SCREWIM_VERSION) \
		--build-arg EXTENSION_EV_VERSION=$(EXTENSION_EV_VERSION) \
		--build-arg EXTENSION_UV_VERSION=$(EXTENSION_UV_VERSION) \
		--build-arg EXTENSION_EIO_VERSION=$(EXTENSION_EIO_VERSION) \
		--build-arg EXTENSION_EVENT_VERSION=$(EXTENSION_EVENT_VERSION) \
		--build-arg EXTENSION_MEMPROF_VERSION=$(EXTENSION_MEMPROF_VERSION) \
		--build-arg EXTENSION_HTTP_VERSION=$(EXTENSION_HTTP_VERSION) \
		--build-arg EXTENSION_PSR_VERSION=$(EXTENSION_PSR_VERSION) \
		--build-arg EXTENSION_YACONF_VERSION=$(EXTENSION_YACONF_VERSION) \
		--build-arg EXTENSION_CALLEE_VERSION=$(EXTENSION_CALLEE_VERSION) \
		--build-arg EXTENSION_DECIMAL_VERSION=$(EXTENSION_DECIMAL_VERSION) \
		--build-arg EXTENSION_IMAGICK_VERSION=$(EXTENSION_IMAGICK_VERSION) \
		--build-arg EXTENSION_VIPS_VERSION=$(EXTENSION_VIPS_VERSION) \
		--build-arg EXTENSION_SSH2_VERSION=$(EXTENSION_SSH2_VERSION) \
		--build-arg EXTENSION_SQLSRV_VERSION=$(EXTENSION_SQLSRV_VERSION) \
		--build-arg EXTENSION_V8JS_VERSION=$(EXTENSION_V8JS_VERSION) \
		--build-arg EXTENSION_V8_VERSION=$(EXTENSION_V8_VERSION) \
		--build-arg EXTENSION_EXCEL_VERSION=$(EXTENSION_EXCEL_VERSION) \
		--build-arg EXTENSION_XLSWRITER_VERSION=$(EXTENSION_XLSWRITER_VERSION) \
		--build-arg EXTENSION_XDEBUG_VERSION=$(EXTENSION_XDEBUG_VERSION) \
		--build-arg EXTENSION_SEASLOG_VERSION=$(EXTENSION_SEASLOG_VERSION) \
		--build-arg LIBRARY_XL_VERSION=$(LIBRARY_XL_VERSION) \
		--build-arg LIBRARY_XLSWRITER_VERSION=$(LIBRARY_XLSWRITER_VERSION) \
		--build-arg LIBRARY_VIPS_VERSION=$(LIBRARY_VIPS_VERSION) \
		--build-arg EXTENSION_COMPONERE_VERSION=$(EXTENSION_COMPONERE_VERSION) \
		--build-arg EXTENSION_RUNKIT7_VERSION=$(EXTENSION_RUNKIT7_VERSION) \
		--build-arg EXTENSION_VLD_VERSION=$(EXTENSION_VLD_VERSION) \
		--build-arg EXTENSION_DATADOG_TRACE_VERSION=$(EXTENSION_DATADOG_TRACE_VERSION) \
		--build-arg EXTENSION_GRPC_VERSION=$(EXTENSION_GRPC_VERSION) \
		--build-arg EXTENSION_HTTP_MESSAGE_VERSION=$(EXTENSION_HTTP_MESSAGE_VERSION) \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--file $(DOCKERFILE) \
	.

	if [ $(OSFLAG) = "LINUX" ]; then make test TAG="$(TAG)"; fi;


build-base-72: ## Build PHP 7.2 base images
	@make build \
		EXTENSIONS="$(FULL_EXTENSIONS)" \
		PHP_VERSION="$(PHP72_VERSION)" \
		PHP_GPGKEYS="$(PHP72_GPGKEYS)" \
		PHP_SHA256="$(PHP72_SHA256)" \
		TAG="$(PHP72_VERSION)" \
		DOCKERFILE="72.Dockerfile"

build-extend-72: ## Build PHP 7.2 extend images
	@make build \
		EXTENSIONS="$(FULL_EXTENSIONS)" \
		PHP_VERSION="$(PHP72_VERSION)" \
		PHP_GPGKEYS="$(PHP72_GPGKEYS)" \
		PHP_SHA256="$(PHP72_SHA256)" \
		TAG="$(PHP72_VERSION)" \
		DOCKERFILE="72.Dockerfile"

build-72: ## Build PHP 7.2 images
	@make build-base-72
	@make build-extend-72

build-base-73: ## Build PHP 7.3 base image
	docker build \
		--no-cache \
		--tag yejune/webserver:$(PREFIX)$(PHP73_VERSION)-base \
		--build-arg REPOGITORY_URL="$(REPOGITORY_URL)" \
		--build-arg PHP_VERSION="$(PHP73_VERSION)" \
		--build-arg PHP_GPGKEYS="$(PHP73_GPGKEYS)" \
		--build-arg PHP_SHA256="$(PHP73_SHA256)" \
		--build-arg BUILD_EXTENSIONS="$(DEFAULT_EXTENSIONS)" \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--file Base.Dockerfile \
	.

	if [ $(OSFLAG) = "LINUX" ]; then make test TAG="$(PHP73_VERSION)-base"; fi;

build-extend-73: ## Build PHP 7.3 extend images
	@make build \
		EXTENSIONS="$(CUSTOM_EXTENSIONS)" \
		PHP_VERSION="$(PHP73_VERSION)" \
		PHP_GPGKEYS="$(PHP73_GPGKEYS)" \
		PHP_SHA256="$(PHP73_SHA256)" \
		TAG="$(PHP73_VERSION)" \
		DOCKERFILE="73.Dockerfile"

build-73: ## Build PHP 7.3 images
	@make build-base-73
	@make build-extend-73


build-base-74: ## Build PHP 7.4 base image
	docker build \
		--no-cache \
		--tag yejune/webserver:$(PREFIX)$(PHP74_VERSION)-base \
		--build-arg REPOGITORY_URL="$(REPOGITORY_URL)" \
		--build-arg PHP_VERSION="$(PHP74_VERSION)" \
		--build-arg PHP_GPGKEYS="$(PHP74_GPGKEYS)" \
		--build-arg PHP_SHA256="$(PHP74_SHA256)" \
		--build-arg BUILD_EXTENSIONS="$(DEFAULT_EXTENSIONS)" \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--file Base.Dockerfile \
	.

	if [ $(OSFLAG) = "LINUX" ]; then make test TAG="$(PHP74_VERSION)-base"; fi;

build-extend-74: ## Build PHP 7.4 extend images
	@make build \
		EXTENSIONS="$(CUSTOM_EXTENSIONS)" \
		PHP_VERSION="$(PHP74_VERSION)" \
		PHP_GPGKEYS="$(PHP74_GPGKEYS)" \
		PHP_SHA256="$(PHP74_SHA256)" \
		TAG="$(PHP74_VERSION)" \
		DOCKERFILE="74.Dockerfile"

build-74: ## Build PHP 7.4 images
	@make build-base-74
	@make build-extend-74

build-test: ## Build PHP 7.2 image. Usage: make build-test tag="test11"
	@make build \
		EXTENSIONS="$(FULL_EXTENSIONS)" \
		PHP_VERSION="$(PHP72_VERSION)" \
		PHP_GPGKEYS="$(PHP72_GPGKEYS)" \
		PHP_SHA256="$(PHP72_SHA256)" \
		TAG="$(tag)" \
		DOCKERFILE="Base.Dockerfile"

	@docker push yejune/webserver:$(PREFIX)$(tag)

build-test-new: ## Dockerfile.test 로 빌드. Usage: make build-test-new tag="test11"
	docker build \
		--tag yejune/webserver:$(PREFIX)$(tag) \
		--file 73.Dockerfile \
		--build-arg BUILD_EXTENSIONS="$(FULL_EXTENSIONS)" \
	.

	@docker push yejune/webserver:$(PREFIX)$(tag)

build-test-file: ## Dockerfile.test 로 빌드. Usage: make build-test-file tag="test11"
	docker build \
		--tag yejune/webserver:$(PREFIX)$(tag) \
		--file Dockerfile.test \
	.

	@docker push yejune/webserver:$(PREFIX)$(tag)

build-all: ## Build all images
	@make build-74
	@make build-73
	@make build-72

push-72: ## Push built PHP 7.2 images to Docker Hub
	@docker push yejune/webserver:$(PREFIX)$(PHP72_VERSION)-base
	@docker push yejune/webserver:$(PREFIX)$(PHP72_VERSION)
	# @docker tag yejune/webserver:$(PREFIX)$(PHP72_VERSION) yejune/webserver:$(PREFIX)latest
	# @docker push yejune/webserver:$(PREFIX)latest

push-73: ## Push built PHP 7.3 images to Docker Hub
	@docker push yejune/webserver:$(PREFIX)$(PHP73_VERSION)-base
	@docker push yejune/webserver:$(PREFIX)$(PHP73_VERSION)

push-74: ## Push built PHP 7.3 images to Docker Hub
	@docker push yejune/webserver:$(PREFIX)$(PHP74_VERSION)-base
	@docker push yejune/webserver:$(PREFIX)$(PHP74_VERSION)

push-all: ## Push all built images to Docker Hub
	@make push-74
	@make push-73
	@make push-72

build-and-push-72: ## Build and push PHP 7.2 images to Docker Hub
	@make build-72
	@make push-72

build-and-push-73: ## Build and push PHP 7.3 images to Docker Hub
	@make build-73
	@make push-73

build-and-push-74: ## Build and push PHP 7.3 images to Docker Hub
	@make build-74
	@make push-74

build-and-push-all: ## Build all images and push them to Docker Hub
	@make build-all
	@make push-all

test:
	if [ ! -z "$(shell docker ps | grep 8111 | awk '{ print $(1) }')" ]; then docker rm -f test-webserver > /dev/null; fi
	docker run --rm -d --name=test-webserver -p 8111:80 yejune/webserver:$(PREFIX)$(TAG)
	wget --tries=10 --no-check-certificate --spider http://localhost:8111 || sleep 5; wget --tries=10 --no-check-certificate --spider http://localhost:8111
	curl --retry 10 --retry-delay 5 -L -I http://localhost:8111/ip.php | grep "200 OK"
	docker kill test-webserver

test-all: ## 테스트
	@make test-74
	@make test-73
	@make test-72

test-72:
	@make test TAG="$(PHP72_VERSION)"
	#@make test TAG="$(PHP72_VERSION)-mini"

test-73:
	@make test TAG="$(PHP73_VERSION)"

test-74:
	@make test TAG="$(PHP74_VERSION)"

test-base-73:
	@make test TAG="$(PHP73_VERSION)-base"

clean: ## Clean all containers and images on the system
	-@docker ps -a -q | xargs docker rm -f
	-@docker images -q | xargs docker rmi -f
