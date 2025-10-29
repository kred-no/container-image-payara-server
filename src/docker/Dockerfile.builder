# ----------------------
# GLOBAL ARGUMENTS
# ----------------------

  ARG builder_image="docker.io/alpine/ansible:latest"

# ----------------------
# BUILDER
# ----------------------

FROM "${builder_image}"

ARG bld_activemq_rar_version="6.1.8"
ARG bld_logback_delegation_version="1.0.0"
ARG bld_logback_encoder_version="9.0"
ARG bld_logback_libs_version="1.0.0"
ARG bld_mssql_jdbc_version="10.2.1"
ARG bld_payara_version_major='6'
ARG bld_payara_version_release='2025.10'
ARG bld_postgres_jdbc_version="42.3.6"

RUN apk add --no-cache tar unzip zip

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

