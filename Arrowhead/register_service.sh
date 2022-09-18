#!/bin/sh

#GET SERVICE PARAMETERS FROM FORM
SERVICE_NAME=$(printenv v_serviceName)
SERVICE_DEFINITION=$(printenv v_serviceDefinition)
SERVICE_PORT=$(printenv v_port)
systemName="$PWD/../../../../test-service-to-register/test-service-to-register"

#ASSEMBLE JSON DATA PAYLOAD
#PAYLOAD='{"serviceDefinition":"Arrowhead-test","providerSystem":{"systemName": "test-service-to-register","address": "127.0.0.1","port":9001,"authenticationInfo": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB"},"serviceUri": "registeredService","endOfValidity": "2023-08-24T11:03:02Z","secure": "NOT_SECURE","version": 0,"interfaces": ["HTTP-SECURE-JSON"]}'
PAYLOAD=$(cat payload)

#CALL SERVICE REGISTRY
#curl -v -s --insecure --cert-type P12 --cert $systemName.p12:123456 -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "https://127.0.0.1:8443/serviceregistry/register" > response

echo $PAYLOAD
printenv
