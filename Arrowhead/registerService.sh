#!/bin/sh
echo "Start"

SERVICE_NAME=$(printenv v_serviceName)
SERVICE_DEFINITION=$(printenv v_serviceDefinition)
SERVICE_PORT=$(printenv v_port)
authinfo=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB

#echo $SERVICE_NAME 
echo $SERVICE_PORT 
echo $SERVICE_DEFINITION
echo echo "{"serviceDefinition": $SERVICE_DEFINITION,"providerSystem": {"systemName": "$SERVICE_NAME","address": "127.0.0.1","port": $SERVICE_PORT,"authenticationInfo": "$authinfo"},"serviceUri": "\registeredService","endOfValidity": "string","secure": "NOT_SECURE","version": 0,"interfaces": ["HTTP-SECURE-JSON"]}"
