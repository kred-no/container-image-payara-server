#!/usr/bin/dumb-init /bin/sh

# -----------------------------------------------
# Validation
# -----------------------------------------------

# Required
if [ -z ${PAYARA_DIR} ]; then echo "[ERROR] Required variable PAYARA_DIR is not set."; exit 1; fi
if [ -z ${PAYARA_USER} ]; then echo "[ERROR] Required variable PAYARA_USER is not set."; exit 1; fi
if [ -z ${CONFIG_DIR} ]; then echo "[ERROR] Required variable CONFIG_DIR is not set."; exit 1; fi
if [ -z ${SCRIPT_DIR} ]; then echo "[ERROR] Required variable SCRIPT_DIR is not set."; exit 1; fi
if [ -z ${DEPLOY_DIR} ]; then echo "[ERROR] Required variable DEPLOY_DIR is not set."; exit 1; fi
if [ -z ${DOMAIN_NAME} ]; then echo "[ERROR] Required variable DOMAIN_NAME is not set."; exit 1; fi
if [ -z ${ADMIN_USER} ]; then echo "[ERROR] Required variable ADMIN_USER is not set."; exit 1; fi
if [ -z ${PATH_ADMIN_SECRET} ]; then echo "[ERROR] Required variable PATH_ADMIN_SECRET is not set."; exit 1; fi
if [ -z ${PATH_PREBOOT_COMMANDS} ]; then echo "[ERROR] Required variable PATH_PREBOOT_COMMANDS is not set."; exit 1; fi
if [ -z ${PATH_POSTBOOT_COMMANDS} ]; then echo "[ERROR] Required variable PATH_POSTBOOT_COMMANDS is not set."; exit 1; fi

# Optional
if [ -z ${PAYARA_ARGS} ]; then echo "[INFO] Variable PAYARA_ARGS is empty."; fi
if [ -z ${JVM_ARGS} ]; then echo "[INFO] Variable JVM_ARGS is empty."; fi
if [ -z ${DEPLOY_PROPS} ]; then echo "[INFO] Variable DEPLOY_PROPS is empty."; fi

# -----------------------------------------------
# ISSUE: https://github.com/payara/Payara/issues/2267
# Append hostname to hostsfile on startup
# -----------------------------------------------

echo 127.0.0.1 `cat /etc/hostname` | tee -a /etc/hosts

# -----------------------------------------------
# Prestart Scripts (root user)
# -----------------------------------------------

printf "[INFO] Creating ${CONFIG_DIR}, if missing\n"
mkdir -p ${CONFIG_DIR}

printf "[INFO] Creating ${SCRIPT_DIR}/init.d, if missing\n"
mkdir -p ${SCRIPT_DIR}/init.d

printf '#!/usr/bin/env bash\necho "init-scripts.."\n' > ${SCRIPT_DIR}/init_0_dummy.sh
printf '#!/usr/bin/env bash\necho "user-scripts.."\n' > ${SCRIPT_DIR}/init.d/dummy.sh

# Init-scripts
for file in ${SCRIPT_DIR}/init_*.sh; do
  printf "[Entrypoint] Running ${file}\n"
  chmod +x ${file}
  . ${file}
done

# Other scripts
for file in ${SCRIPT_DIR}/init.d/*.sh; do
  printf "[Entrypoint] Running ${file}\n"
  chmod +x ${file}
  . ${file}
done

# -----------------------------------------------
# Pre- and post-boot files
# -----------------------------------------------

printf "[INFO] Creating pre-boot command file, if missing\n"
touch ${PATH_PREBOOT_COMMANDS}

printf "[INFO] Creating post-boot command file, if missing\n"
touch ${PATH_POSTBOOT_COMMANDS}

# -----------------------------------------------
# Auto-deployment
# -----------------------------------------------

printf "[INFO] Creating deployment directory, if missing\n"
mkdir -p ${DEPLOY_DIR}

# Define function for appending deployments to postboot-command-file
deploy() {
  # Check if input is empty
  if [ -z ${1} ]; then
    printf "Nothing to deploy\n"
    return 0;
  fi

  # Check if command already exists in post-boot deployments
  if grep -q ${1} ${PATH_POSTBOOT_COMMANDS}; then
    echo "Ignoring already included deployment: ${1}"
  else
    echo "Adding deployment to postboot-command: ${1}"
    echo "deploy ${DEPLOY_PROPS} ${1}" >> ${PATH_POSTBOOT_COMMANDS}
  fi
}

# Check for rar-files/folders to deploy first
printf "[INFO] Adding rar-deployments to post-boot (files/folders)\n"
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 -name "*.rar"); do
  deploy ${deployment}
done

# Check for war, jar, ear-files or directory to deploy (exluding *.rar files/folders)
printf "[INFO] Deploying other deployments to post-boot (files/folders)\n"
for deployment in $(find ${DEPLOY_DIR} -mindepth 1 -maxdepth 1 ! -name "*.rar" -a -name "*.war" -o -name "*.ear" -o -name "*.jar" -o -type d); do
  deploy ${deployment}
done

# -----------------------------------------------
# Validate payara command (dry-run)
# -----------------------------------------------

printf "[INFO] Validating payara command\n"
OUTPUT=`${PAYARA_DIR}/bin/asadmin --user=${ADMIN_USER} --passwordfile=${PATH_ADMIN_SECRET} start-domain --dry-run --prebootcommandfile=${PATH_PREBOOT_COMMANDS} --postbootcommandfile=${PATH_POSTBOOT_COMMANDS} ${PAYARA_ARGS} ${DOMAIN_NAME}`
OUTPUT_STATUS=${?}

if [ "${OUTPUT_STATUS}" -ne 0 ]
  then
    # Print to stderr & exit
    printf "[ERROR] Dry-run failed\n"
    echo "${OUTPUT}" >&2
    exit 1
fi

# -----------------------------------------------
# Add JVM-parameters to startup command
# -----------------------------------------------

printf "[INFO] Appending JVM_ARGS to payara command\n"
COMMAND=`echo "${OUTPUT}" | sed -n -e '2,/^$/p' | sed "s|glassfish.jar|glassfish.jar ${JVM_ARGS} |g"`

# Print command, line by line
printf "[INFO] Startup Command:\n"
echo "${COMMAND}" | tr ' ' '\n'

# -----------------------------------------------
# Start payara instance (interactive)
# -----------------------------------------------

set -e
set -- ${COMMAND} < ${PATH_ADMIN_SECRET} 

# Run as unprivileged user (if 'PAYARA_USER' user exists)
if id ${PAYARA_USER} >/dev/null 2<&1; then
  printf "[INFO] Starting server as user \"${PAYARA_USER}\"..\n\n"
  chown -HR ${PAYARA_USER}:${PAYARA_USER} ${PAYARA_DIR}
  chown -HR ${PAYARA_USER}:${PAYARA_USER} ${CONFIG_DIR}
  chown -HR ${PAYARA_USER}:${PAYARA_USER} ${DEPLOY_DIR}
  chown -HR ${PAYARA_USER}:${PAYARA_USER} ${SCRIPT_DIR}

  # Make JVM-variable(s) global, if running as non-root. Not passed when using gosu
  echo JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS} | tee -a /etc/environment
  set -- gosu ${PAYARA_USER} ${@}
else
  printf "[WARNING] User \"${PAYARA_USER}\" undefined. Starting server as \"root\"\n"
fi

printf "\n\n*** CONTAINER INFO ***\n"
printf "  Host: $(hostname)\n"
printf "    IP: $(hostname -I)\n"
printf "    OS: $(cat /etc/issue.net)\n"
printf "*** CONTAINER INFO ***\n\n"

exec "${@}"
