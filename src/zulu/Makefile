.PHONY: build run clean

CONTAINER_ENGINE ?= podman

# Build Parameters
IMAGE_NAME 									= payara
IMAGE_TAG									  = local
PAYARA_VERSION_MAJOR       ?= 7
PAYARA_VERSION_RELEASE     ?= 2026.7
ACTIVEMQ_VERSION           ?= 6.3.0
LOGBACK_DELEGATION_VERSION ?= 1.0.0
LOGBACK_ENCODER_VERSION    ?= 9.0
LOGBACK_LIBS_VERSION       ?= 1.0.0
MSSQL_JDBC_VERSION         ?= 13.4.0
POSTGRES_JDBC_VERSION      ?= 42.7.13

# Run Parameters
LOGBACK_FILE_PATH  ?= /tmp/logback.xml
POSTBOOT_FILE_PATH ?= /tmp/postboot.asadmin

# Makefile Actions
build:
	$(CONTAINER_ENGINE) build -t $(IMAGE_NAME):$(IMAGE_TAG) \
	--build-arg bld_payara_version_major=$(PAYARA_VERSION_MAJOR) \
	--build-arg bld_payara_version_release=$(PAYARA_VERSION_RELEASE) \
	--build-arg bld_activemq_rar_version=$(ACTIVEMQ_VERSION) \
	--build-arg bld_logback_delegation_version=$(LOGBACK_DELEGATION_VERSION) \
	--build-arg bld_logback_encoder_version=$(LOGBACK_ENCODER_VERSION) \
	--build-arg bld_logback_libs_version=$(LOGBACK_LIBS_VERSION) \
	--build-arg bld_mssql_jdbc_version=$(MSSQL_JDBC_VERSION) \
	--build-arg bld_postgres_jdbc_version=$(POSTGRES_JDBC_VERSION) \
  .

debug:
	$(CONTAINER_ENGINE) run --rm -it \
	-p 4848:4848 -p 8080:8080 \
	--name payara-local $(IMAGE_NAME):$(IMAGE_TAG)

# Remove the image
clean:
	$(CONTAINER_ENGINE) rmi $(IMAGE_NAME):$(IMAGE_TAG)
