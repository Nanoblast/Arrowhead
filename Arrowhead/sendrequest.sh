#!/bin/sh
systemName="$PWD/../../../test-service-to-register/test-service-to-register"
curl -v -s --insecure --cert-type P12 --cert $systemName.p12:123456 -X POST -H "Content-Type: application/json" -d @request https://127.0.0.1:8443/serviceregistry/register
