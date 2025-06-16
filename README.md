# container-image-payara-server

![build](https://github.com/kred-no/container-image-payara-server/actions/workflows/build-and-push.yml/badge.svg)

Container image builds for Payara Server Full (Community Edition)

**Payara Server (Community Edition)**

  * Secure Admin enabled
  * Postgres JDBC driver
  * MSSQL JDBC driver
  * ActiveMQ Client  (RAR)
    * Disable OpenMQ: `https://blog.payara.fish/disabling-openmq-in-payara-server`
    * Using ActiveMQ `https://blog.payara.fish/connecting-to-activemq-with-payara-server`
    * Location: `glassfish/domains/payara/lib/activemq-rar.rar`

**Default Credentials**

  * Username: `Admin`
  * Password: `Admin123`

## Build & Run locally

```bash
docker buildx build -f Dockerfile -t local/payara:latest .
```

```bash
# Example
docker run --rm -it -p 4848:4848 -p 8080:8080 --name payara local/payara:latest
```
