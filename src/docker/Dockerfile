# https://mvnrepository.com/artifact/fish.payara
# Payara ONLY supports Java LTS versions (8,11,17)
# https://blog.payara.fish/why-payara-platform-only-supports-lts-versions-of-jdk
#
# ----------------------
# BUILD ARGUMENTS
# ----------------------

ARG builder_image="docker.io/alpine/ansible:latest"
ARG runtime_image="docker.io/azul/zulu-openjdk-debian:25-jre-headless"

#ARG bld_activemq_rar_version="6.1.8"
#ARG bld_logback_delegation_version="1.0.0"
#ARG bld_logback_encoder_version="9.0"
#ARG bld_logback_libs_version="1.0.0"
#ARG bld_mssql_jdbc_version="10.2.1"
#ARG bld_payara_version_major='6'
#ARG bld_payara_version_release='2025.10'
#ARG bld_postgres_jdbc_version="42.3.6"

# ----------------------
# BUILDER
# ----------------------

FROM "${builder_image}" AS builder

# (Re)declare global variables inside each stage
ARG bld_activemq_rar_version
ARG bld_logback_delegation_version
ARG bld_logback_encoder_version
ARG bld_logback_libs_version
ARG bld_mssql_jdbc_version
ARG bld_payara_version_major
ARG bld_payara_version_release
ARG bld_postgres_jdbc_version

# Include pipx bin-path
#ENV PATH="/root/.local/bin:$PATH"
#COPY --chmod='755' ["./files/setup-builder.debian.sh", "/tmp/setup-builder.sh"]
#RUN ./tmp/setup-builder.sh

# Add Required OS packages
RUN apk add --no-cache tar unzip zip

# Run Ansible Playbook(s)
COPY --chmod='755' ["./files/ansible/download.yml", "/tmp/download.yml"]
RUN ansible-playbook -i localhost, /tmp/download.yml \
  --extra-vars "activemq_rar_version=${bld_activemq_rar_version}"\
  --extra-vars "logback_delegation_version=${bld_logback_delegation_version}" \
  --extra-vars "logback_encoder_version=${bld_logback_encoder_version}" \
  --extra-vars "logback_libs_version=${bld_logback_libs_version}" \
  --extra-vars "mssql_jdbc_version=${bld_mssql_jdbc_version}" \
  --extra-vars "payara_version_major=${bld_payara_version_major}" \
  --extra-vars "payara_version_release=${bld_payara_version_release}" \
  --extra-vars "postgres_jdbc_version=${bld_postgres_jdbc_version}"

# ----------------------
# RUNTIME IMAGE
# ----------------------

FROM ${runtime_image}

# Override at runtime, if required. Examples:
#   TZ="Europe/Oslo"
#   LC_ALL="nb_NO.ISO-8859-1"

ENV LC_ALL="C" \
    JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError"

ENV DOMAIN_NAME="payara" \
    PAYARA_USER="payara" \
    PAYARA_DIR="/opt/payara" \
    ADMIN_USER="admin"

ENV CONFIG_DIR="${PAYARA_DIR}/config" \
    SCRIPT_DIR="${PAYARA_DIR}/scripts" \
    DEPLOY_DIR="${PAYARA_DIR}/deploy" \
    PATH_ADMIN_SECRET="${PAYARA_DIR}/secret.txt"

ENV PATH_PREBOOT_COMMANDS="${CONFIG_DIR}/preboot-commands.asadmin" \
    PATH_POSTBOOT_COMMANDS="${CONFIG_DIR}/postboot-commands.asadmin"

ENV PATH="${PAYARA_DIR}/bin:$PATH"

EXPOSE 8080 8181 4848 9009

# Copy build artifacts & Configure container
COPY --from=builder /output/payara "${PAYARA_DIR}"
COPY --chmod='755' ["./files/setup-runtime.debian.sh", "/tmp/setup-runtime.sh"]
RUN --mount=type=secret,id=payara_admin_secret,env=PAYARA_ADMIN_SECRET \
  /tmp/setup-runtime.sh

# Copy startup script
COPY --chmod='755' ["./files/docker-entrypoint.sh","/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
