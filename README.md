# container-image-payara-server
![build](https://github.com/kred-no/container-image-payara-server/actions/workflows/zulu.yml/badge.svg)
![build](https://github.com/kred-no/container-image-payara-server/actions/workflows/zulu-legacy.yml/badge.svg)

**Container builds for `Payara Server Full` (Community Edition)**

* [Download from Docker Hub](https://hub.docker.com/r/kdsda/payara-server-ce)
* [Dockerfile](src/docker/Dockerfile)

**Default Credentials**

| USERNAME | PASSWORD  |
| :--      | :--       |
| `Admin`  | `Admin123`|


## ENVIRONMENT VARIABLES

| NAME                   | DEFAULT  |
| --:                    | :--      |
| LC_ALL                 | `C` |
| CONFIG_DIR             | `/opt/payara/config` |
| SCRIPT_DIR             | `/opt/payara/scripts` |
| DEPLOY_DIR             | `/opt/payara/deploy` |
| PATH_POSTBOOT_COMMANDS | `/opt/payara/config/postboot-commands.asadmin` |
| PATH_PREBOOT_COMMANDS  | `/opt/payara/config/preboot-commands.asadmin` |
| JAVA_TOOL_OPTIONS      | `-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError` |
| TZ                     | ` ` |

## BUILD & RUN

#### LOCAL

```bash
# Docker (buildx)
docker buildx build -f Dockerfile -t local/payara:latest .

# RedHat Buildah
buildah bud -f Dockerfile -t local/payara:latest .
```

```bash
# Docker
docker run --rm -d -e TZ=Europe/Oslo -e LC_ALL=nb_NO.ISO-8859-1 -p 4848:4848 -p 8080:8080 --name payara-ce local/payara:latest

# RedHat Podman
podman run --rm -d -e TZ=Europe/Oslo -e LC_ALL=nb_NO.ISO-8859-1 -p 4848:4848 -p 8080:8080 --name payara-ce local/payara:latest
```
