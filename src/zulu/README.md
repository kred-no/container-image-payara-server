# PAYARA-SERVER-CE (FULL)

## Included Libraries

| Name                 | Path | Description |
| --:                  | :--  | :--         |
| ActiveMQ RAR         | `../glassfish/lib/activemq-rar.rar`              | ActiveMQ Resoruce Adapter |
| Postgres JDBC        | `../glassfish/lib/postgresql.jar`                | Postgres JDBC Driver |
| Microsoft SQL JDBC   | `../glassfish/lib/mssql-jdbc.jre11.jar`          | Microsoft SQL JDBC Driver |
| Logback (delegation) | `../glassfish/lib/payara-logback-delegation.jar` | Logback Delegation |
| Logback (libs)       | `../glassfish/lib/payara-logback-libs.jar`       | Logback Libs |
| Logback (encoder)    | `../glassfish/lib/logstash-logback-encoder`      | Logback Encoder |

## Build

* Multi-staged build

```bash
# Docker
docker build -t local/payara:dev -f Dockerfile .

# Buildah
buildah bud -t local/payara:dev -f Dockerfile .
```

## Resources

  * Payara Versions: `https://nexus.payara.fish/#browse/browse:payara-community`
  * Disable OpenMQ: `https://blog.payara.fish/disabling-openmq-in-payara-server`
  * Using ActiveMQ `https://blog.payara.fish/connecting-to-activemq-with-payara-server`
