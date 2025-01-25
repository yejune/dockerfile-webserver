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

include env.version
include env.makefile

help:
	@echo "\033[33mUsage:\033[0m\n  make [target] [arg=\"val\"...]\n\n\033[33mTargets:\033[0m"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build-command: ## Build image. Usage: make build-command TAG="7.2.x" PHP_VERSION="..." ...
	docker build \
		--no-cache \
		--progress=plain \
		--platform linux/$(PLATFORM) \
		--tag yejune/webserver:$(PREFIX)$(TAG) \
		--build-arg ARCH="linux/$(PLATFORM)" \
		--build-arg REPOGITORY_URL="$(REPOGITORY_URL)" \
		--build-arg GDB="$(GDB)" \
		--build-arg FROM="$(FROM)" \
		--build-arg PHP_VERSION="$(PHP_VERSION)" \
		--build-arg PHP_GPGKEYS="$(PHP_GPGKEYS)" \
		--build-arg PHP_SHA256="$(PHP_SHA256)" \
		--build-arg RC_USER="$(RC_USER)" \
		--build-arg ALPHA_USER="$(ALPHA_USER)" \
		--build-arg BUILD_EXTENSIONS="$(EXTENSIONS)" \
		--build-arg EXTENSION_PHALCON_VERSION=$(EXTENSION_PHALCON_VERSION) \
		--build-arg EXTENSION_SWOOLE_VERSION=$(EXTENSION_SWOOLE_VERSION) \
		--build-arg EXTENSION_UUID_VERSION=$(EXTENSION_UUID_VERSION) \
		--build-arg EXTENSION_APFD_VERSION=$(EXTENSION_APFD_VERSION) \
		--build-arg EXTENSION_JSONPOST_VERSION=$(EXTENSION_JSONPOST_VERSION) \
		--build-arg EXTENSION_YAML_VERSION=$(EXTENSION_YAML_VERSION) \
		--build-arg EXTENSION_JSONNET_VERSION=$(EXTENSION_JSONNET_VERSION) \
		--build-arg EXTENSION_PROTOBUF_VERSION=$(EXTENSION_PROTOBUF_VERSION) \
		--build-arg EXTENSION_IGBINARY_VERSION=$(EXTENSION_IGBINARY_VERSION) \
		--build-arg EXTENSION_MSGPACK_VERSION=$(EXTENSION_MSGPACK_VERSION) \
		--build-arg EXTENSION_MAILPARSE_VERSION=$(EXTENSION_MAILPARSE_VERSION) \
		--build-arg EXTENSION_BASE58_VERSION=$(EXTENSION_BASE58_VERSION) \
		--build-arg EXTENSION_APCU_VERSION=$(EXTENSION_APCU_VERSION) \
		--build-arg EXTENSION_APCU_BC_VERSION=$(EXTENSION_APCU_BC_VERSION) \
		--build-arg EXTENSION_MEMCACHED_VERSION=$(EXTENSION_MEMCACHED_VERSION) \
		--build-arg EXTENSION_REDIS_VERSION=$(EXTENSION_REDIS_VERSION) \
		--build-arg EXTENSION_MONGODB_VERSION=$(EXTENSION_MONGODB_VERSION) \
		--build-arg EXTENSION_RDKAFKA_VERSION=$(EXTENSION_RDKAFKA_VERSION) \
		--build-arg EXTENSION_SIMPLE_KAFKA_CLIENT_VERSION=$(EXTENSION_SIMPLE_KAFKA_CLIENT_VERSION) \
		--build-arg EXTENSION_VAR_REPRESENTATION_VERSION=$(EXTENSION_VAR_REPRESENTATION_VERSION) \
		--build-arg EXTENSION_JSONPATH_VERSION=$(EXTENSION_JSONPATH_VERSION) \
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
		--build-arg EXTENSION_COMPONERE_VERSION=$(EXTENSION_COMPONERE_VERSION) \
		--build-arg EXTENSION_RUNKIT7_VERSION=$(EXTENSION_RUNKIT7_VERSION) \
		--build-arg EXTENSION_VLD_VERSION=$(EXTENSION_VLD_VERSION) \
		--build-arg EXTENSION_ZEPHIR_PARSER_VERSION=$(EXTENSION_ZEPHIR_PARSER_VERSION) \
		--build-arg EXTENSION_DATADOG_TRACE_VERSION=$(EXTENSION_DATADOG_TRACE_VERSION) \
		--build-arg EXTENSION_GRPC_VERSION=$(EXTENSION_GRPC_VERSION) \
		--build-arg EXTENSION_HTTP_MESSAGE_VERSION=$(EXTENSION_HTTP_MESSAGE_VERSION) \
		--build-arg EXTENSION_GEOSPATIAL_VERSION=$(EXTENSION_GEOSPATIAL_VERSION) \
		--build-arg EXTENSION_EXCIMER_VERSION=$(EXTENSION_EXCIMER_VERSION) \
		--build-arg EXTENSION_AWSCRT_VERSION=$(EXTENSION_AWSCRT_VERSION) \
		--build-arg EXTENSION_XHPROF_VERSION=$(EXTENSION_XHPROF_VERSION) \
		--build-arg EXTENSION_UOPZ_VERSION=$(EXTENSION_UOPZ_VERSION) \
		--build-arg EXTENSION_SIMDJSON_VERSION=$(EXTENSION_SIMDJSON_VERSION) \
		--build-arg EXTENSION_BSDIFF_VERSION=$(EXTENSION_BSDIFF_VERSION) \
		--build-arg EXTENSION_SOLR_VERSION=$(EXTENSION_SOLR_VERSION) \
		--build-arg LIBRARY_XL_VERSION=$(LIBRARY_XL_VERSION) \
		--build-arg LIBRARY_XLSWRITER_VERSION=$(LIBRARY_XLSWRITER_VERSION) \
		--build-arg LIBRARY_VIPS_VERSION=$(LIBRARY_VIPS_VERSION) \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--file $(DOCKERFILE) \
	.

	if [ $(OSFLAG) = "LINUX" ]; then make test PLATFORM="$(PLATFORM)" TAG="$(TAG)"; fi;

build-base-command: ## Build PHP 8.0 base image
	docker build \
		--no-cache \
		--progress=plain \
		--platform linux/$(PLATFORM) \
		--tag yejune/webserver:$(PREFIX)$(PHP84_VERSION)-base \
		--build-arg ARCH="linux/$(PLATFORM)" \
		--build-arg RC_USER="$(RC_USER)" \
		--build-arg ALPHA_USER="$(ALPHA_USER)" \
		--build-arg REPOGITORY_URL="$(REPOGITORY_URL)" \
		--build-arg PHP_VERSION="$(PHP84_VERSION)" \
		--build-arg PHP_GPGKEYS="$(PHP84_GPGKEYS)" \
		--build-arg PHP_SHA256="$(PHP84_SHA256)" \
		--build-arg BUILD_EXTENSIONS="$(DEFAULT_EXTENSIONS)" \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--file Base.Dockerfile \
	.

	if [ $(OSFLAG) = "LINUX" ]; then make test TAG="$(PHP84_VERSION)-base"; fi;

build-extend-command: ## Build PHP 8.0 extend images
	@make build-command \
		FROM="yejune/webserver:$(PREFIX)$(PHP84_VERSION)-base" \
		TAG="$(PHP84_VERSION)" \
		EXTENSIONS="$(CUSTOM_EXTENSIONS)" \
		PHP_VERSION="$(PHP84_VERSION)" \
		PHP_GPGKEYS="$(PHP84_GPGKEYS)" \
		PHP_SHA256="$(PHP84_SHA256)" \
		DOCKERFILE="Dockerfile" \
		PLATFORM="$(PLATFORM)"

build-all: ## Build PHP 8.0 images
	@make build-command-arm
	@make build-command-amd

build-arm: ## Build PHP 8.0 images
	@make build-base-command PLATFORM=arm64
	@make build-extend-command PLATFORM=arm64
	@make push-command PLATFORM=arm64

build-amd: ## Build PHP 8.0 images
	@make build-base-command PLATFORM=amd64
	@make build-extend-command PLATFORM=amd64
	@make push-command PLATFORM=amd64

push-command: ## Push built PHP 8.4 images to Docker Hub
	@docker push --platform linux/$(PLATFORM) yejune/webserver:$(PREFIX)$(PHP84_VERSION)-base
	@docker push --platform linux/$(PLATFORM) yejune/webserver:$(PREFIX)$(PHP84_VERSION)

test-command:
	if [ ! -z "$(shell docker ps | grep 8112 | awk '{ print $(1) }')" ]; then docker rm -f test-webserver > /dev/null; fi
	docker run --rm -d --name=test-webserver -p 8112:80 --platform linux/$(PLATFORM) yejune/webserver:$(PREFIX)$(TAG)
	wget --tries=10 --no-check-certificate --spider http://localhost:8112 || sleep 5; wget --tries=10 --no-check-certificate --spider http://localhost:8112
	curl --retry 10 --retry-delay 5 -L -I http://localhost:8112/ip.php | grep "200 OK"
	docker kill test-webserver

test:
	@make test-command TAG="$(PHP84_VERSION)"
test-base:
	@make test-command TAG="$(PHP84_VERSION)-base"


clean: ## Clean all containers and images on the system
	-@docker ps -a -q | xargs docker rm -f
	-@docker images -q | xargs docker rmi -f
