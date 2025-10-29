# PAYARA-SERVER-CE (FULL)

## BASE IMAGE CONTENT

| Name               | Description |
| :--                | :--         |
| Payara             | Payara Server (Full) |
| ActiveMQ RAR       | ActiveMQ Resoruce Adapter |
| Postgres JDBC      | Postgres JDBC Driver |
| Microsoft SQL JDBC | Microsoft SQL JDBC Driver |

#### SUB IMAGE CONTENT

  * Based on `BASE_IMAGE`
  * Deployment-files included

## BUILDING

```bash
# Docker
docker build -t local/payara:dev -f Dockerfile .

# Buildah
buildah bud -t local/payara:dev -f Dockerfile .
```
