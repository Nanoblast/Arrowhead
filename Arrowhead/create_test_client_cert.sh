#!/bin/sh


AH_CONF_DIR=$PWD

echo $AH_CONF_DIR

AH_CLOUDS_DIR="${AH_CONF_DIR}"
AH_SYSTEMS_DIR="${AH_CONF_DIR}"

AH_PASS_CERT="123456"

SYSTEM_NAME="${1}"
SYSTEM_PASS="123456"
HOST_NAME="localhost"
IP_ADDRESS="127.0.0.1"
CLOUD_NAME="testcloud2"
CLOUD_ALIAS="testcloud2.aitia.arrowhead.eu"

$PWD/genSystemCert.sh "${SYSTEM_NAME}" "${SYSTEM_PASS}" "${HOST_NAME}" "${IP_ADDRESS}" "${CLOUD_NAME}" "${CLOUD_ALIAS}"


keytool -exportcert -alias  "${SYSTEM_NAME}" -keystore "${SYSTEM_NAME}.p12" -storepass "${SYSTEM_PASS}" -rfc | openssl x509 -out "${SYSTEM_NAME}.pub" -noout -pubkey

$PWD/normalize_pub.sh "${SYSTEM_NAME}.pub"
