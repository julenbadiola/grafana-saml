# Grafana OSS SAML integration

This approach uses an Apache webserver to act as a SAML Service Provider. 

When a valid SAMLresponse is POSTed to the /secret/endpoint, the "X-WEBAUTH-USER" header is added to the requests proxied to Grafana. This header contains the email address of the user in okta, which acts as the Identity Provider in this example.

Then, grafana uses this header to create the user's session.

## Run the example

```
docker-compose up -d
```

and navigate to:

https://localhost

## Additional information

### Create an ssl certificate

https://medium.com/etc-a2z/setting-up-https-for-localhost-7e9a18253ca

### Create service metadata

I have added a script that can be used to get the metadata of the service provider:

* urn_grafana.cert
* urn_grafana.key
* urn_grafana.xml

```
bash mellon_create_metadata.sh urn:grafana https://localhost/secret/endpoint
```

### Grafana configuration

Auth proxy:
```
[auth.proxy]
enabled = true
header_name = X-WEBAUTH-USER
header_property = username
header_email_name = X-WEBAUTH-EMAIL
header_email_property = email
header_full_name = X-WEBAUTH-NAME
header_full_property = fullname
auto_sign_up = true
```

And signout redirect URL, in order to successfully logout from mellon:
```
signout_redirect_url = /secret/endpoint/logout?ReturnTo=/login
```