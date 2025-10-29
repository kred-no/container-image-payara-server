#!/bin/env sh

# ----------------------
# OS Configuration
# ----------------------

# Add Required Packages
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install apt-utils 
apt-get -y install locales dumb-init gosu
apt-get -y autoclean

# Add Norwegian Locale
sed -i "/nb_NO/s/^# \?//g" /etc/locale.gen
locale-gen

# Create User
useradd \
  --system \
  --no-create-home \
  --comment "Payara User" \
  --home-dir $PAYARA_DIR \
  --user-group \
  $PAYARA_USER

# ----------------------
# Payara Offline Commands
# ----------------------

# Remove Default Payara domain(s)
rm -rf ${PAYARA_DIR}/glassfish/domains/**

# Create New Payara domain
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} create-domain --nopassword=true ${DOMAIN_NAME}

# Set Admin Password
tee "${PATH_ADMIN_SECRET}" > /dev/null <<EOF
AS_ADMIN_PASSWORD=
AS_ADMIN_NEWPASSWORD=${bld_payara_admin_secret}
EOF

${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} change-admin-password --domain_name=${DOMAIN_NAME}

tee "${PATH_ADMIN_SECRET}" > /dev/null <<EOF
AS_ADMIN_PASSWORD=${bld_payara_admin_secret}
EOF

# ----------------------
# Payara Online Commands
# ----------------------

# Start Payara Domain
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} start-domain ${DOMAIN_NAME}

# Enable Admin Console (*:4848)
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} enable-secure-admin

# Remove legacy MEMORY options
for JVM_OPTION in $(${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} list-jvm-options | grep -E "Xm[sx]"); do
  ${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} delete-jvm-options ${JVM_OPTION}
done

# Add Logback Configuration (?)
#${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} create-jvm-options "\-Dlogback.configurationFile=${CONFIG_DIR}/logback.xml"

# Shutdown Payara Domain
${PAYARA_DIR}/bin/asadmin --user ${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} stop-domain --kill=true ${DOMAIN_NAME}

# ----------------------
# Update File/Folder Permissions
# ----------------------

chown -R ${PAYARA_USER}:${PAYARA_USER} ${PAYARA_DIR}
