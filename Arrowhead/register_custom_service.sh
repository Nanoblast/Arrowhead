#!/bin/sh

systemName="Arrowhead_IC_test_system"
serviceDefinition="Custom_system"
SYSTEM_PORT=8080
authinfo="$(cat log.txt)"
secure="CERTIFICATE"
serviceUri="/$serviceDefinition"

out_file_request="register_${serviceDefinition}_service.request"
out_file_response="register_${serviceDefinition}_service.response"

## COSTUMIZE REGISTER_SERVICE REQUEST
jq ".interfaces = [\"HTTP-SECURE-JSON\"] | del ( .metadata ) | del ( .version ) | .providerSystem.port = $SYSTEM_PORT | .providerSystem.authenticationInfo  = \"${authinfo}\" | .providerSystem.systemName = \"$systemName\" | .secure = \"$secure\" | .serviceDefinition = \"$serviceDefinition\" | .serviceUri = \"$serviceUri\" " register_service.request.template > $out_file_request 


## SEND REQUEST / STORE RESPONSE
curl -v -s --insecure --cert-type P12 --cert tc2-alpine1provider.p12:123456 -X POST https://127.0.0.1:8443/serviceregistry/register > http_response.log
