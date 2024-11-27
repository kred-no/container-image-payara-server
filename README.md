# container-image-payara-server

![build](https://github.com/kred-no/container-image-payara-server/actions/workflows/build-and-push.yml/badge.svg)

Container image builds for Payara Server Full (Community Edition)

| Release            | Java RE |
| :--                 | :--    |
| `6.2024.11`         | 17,21  |
| `7.2024.1 (Alpha2)` | 21     |

This build contains a standard installation of the Payara Server.

  * Secure Admin enabled
  * Postgres JDBC driver
  * MSSQL JDBC driver
  * ActiveMQ Client 
    * Disable OpenMQ: `https://blog.payara.fish/disabling-openmq-in-payara-server`
    * Using ActiveMQ `https://blog.payara.fish/connecting-to-activemq-with-payara-server`
    * Location: `glassfish/domains/payara/lib/activemq-rar.rar`

## Build locally

```bash
docker buildx build -f Dockerfile -t local/payara:latest .
```

## Using the image

Default Credentials:

  * Username: `Admin`
  * Password: `Admin123`
