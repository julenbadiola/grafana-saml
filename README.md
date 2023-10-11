# Grafana OSS SAML integration

## Create an ssl certificate

https://medium.com/etc-a2z/setting-up-https-for-localhost-7e9a18253ca

1. Generate a RSA-2048 key and save it to a file rootCA.key. This file will be used as the key to generate the Root SSL certificate. You will be prompted for a pass phrase which you’ll need to enter each time you use this particular key to generate a certificate. Open terminal and run below command:
   
```
openssl genrsa -des3 -out rootCA.key 2048
```

2. Create a new OpenSSL configuration file server.csr.cnf so you can import these settings when creating a certificate instead of entering them on the command line.

```
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C=US
ST=ExampleState
L=ExampleCity
O=Organization
OU=OrganizationUnit
emailAddress=example@mail.com
CN = localhost
```

3. The key you generated to create a new Root SSL certificate. Now we can generate root certificate using the above key You’ll also be prompted for other optional information.
   
```
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem -config ./server.csr.cnf
```


4. Create a v3.ext file in order to create an X509 v3 certificate. Notice subjectAltName here.

```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
```

5. Create a certificate key for localhost using the configuration settings stored in server.csr.cnf. This key is stored in server.key.

```
openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout server.key -config ./server.csr.cnf
```

6. The root SSL certificate can now be used to issue a certificate specifically for your local development environment located at localhost. A certificate signing request is issued via the root SSL certificate to create a domain certificate for localhost. The output is a certificate file called server.crt.

```
openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 800 -sha256 -extfile v3.ext
```

1. Now SSL certificate server.key and server.crt are ready
   

## Create service metadata

bash mellon_create_metadata.sh urn:grafana https://localhost/secret/endpoint
