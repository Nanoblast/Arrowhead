#!/bin/sh

IN_FILE="${1}"
OUT_FILE="${IN_FILE}.authinfo"
REMOVE_1="-----BEGIN PUBLIC KEY-----"
REMOVE_2="-----END PUBLIC KEY-----"
sed "s/${REMOVE_1}//" $IN_FILE > $OUT_FILE
sed -i "s/${REMOVE_2}//" $OUT_FILE

tr '\r\n' ' ' <  $OUT_FILE > t
sed 's/ //g' t >  $OUT_FILE
cat $OUT_FILE
rm t

