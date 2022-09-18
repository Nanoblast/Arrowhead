#!/bin/sh

#GET SERVICE PARAMETERS FROM FORM
SERVICE_NAME=$(printenv v_serviceName)
SERVICE_DEFINITION=$(printenv v_serviceDefinition)
SERVICE_PORT=$(printenv v_port)
systemName="$PWD/$SERVICE_NAME"

#GENERATE CERTIFICATE
mkdir $systemName/
./requestCertificate.sh "${SERVICE_NAME}"
mv $systemName.* $SERVICE_NAME/

#ASSEMBLE JSON DATA PAYLOAD
PAYLOAD='{"serviceDefinition":'"\"$SERVICE_DEFINITION\""',"providerSystem":{"systemName": '"\"$SERVICE_NAME\""',"address": "127.0.0.1","port":'"\"$SERVICE_PORT\""',"authenticationInfo": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB"},"serviceUri": "registeredService","endOfValidity": "2023-08-24T11:03:02Z","secure": "NOT_SECURE","version": 0,"interfaces": ["HTTP-SECURE-JSON"]}'
#PAYLOAD=$(cat ServiceRegistry/payload)
echo $PAYLOAD > ServiceRegistry/data.json

#CALL SERVICE REGISTRY
curl -v -s --insecure --cert-type P12 --cert $systemName/$SERVICE_NAME.p12:123456 -X POST -H "Content-Type: application/json" -d @ServiceRegistry/data.json https://127.0.0.1:8443/serviceregistry/register > response

