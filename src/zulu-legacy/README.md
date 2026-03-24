# PAYARA SERVER (COMMUNITY EDITION)

## Generate Certificate

```bash

``` 
```bash
SUBJECT="/C=NO/ST=Nordland/L=Bodo/O=Kreditorforeningen SA/OU=IT Department/CN=localhost"
# Create Private Key
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout selfsigned.key -out selfsigned.crt -subj $SUBJECT

# Combine to single file
openssl pkcs12 -export -in selfsigned.crt -inkey selfsigned.key -out selfsigned.p12 -name selfsigned_certificate
```

```bash
# Import to keystore.jks
keytool -importkeystore -destkeystore keystore.jks -srckeystore mycert.p12 -srcstoretype PKCS12 -alias mydomain_certificate

# Import to cacerts.jks
keytool -importcert -trustcacerts -destkeystore cacerts.jks -file mycert.crt -alias mydomain_certificate
```
