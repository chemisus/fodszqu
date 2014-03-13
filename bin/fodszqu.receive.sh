#!/bin/bash

ID=${1}

URL=http://fodszqu.com/message/${ID}

HEAD_URL=${URL}/head
BODY_URL=${URL}/body

HEAD=`curl -s ${HEAD_URL} | base64 --decode | openssl rsautl -decrypt -inkey ~/.ssh/id_rsa`
BODY=`curl -s ${BODY_URL} | base64 --decode | openssl rsautl -decrypt -inkey ~/.ssh/id_rsa`

mkdir received

echo "HEAD ${ID}" > received/${ID}
echo "" >> received/${ID}
echo ${HEAD} >> received/${ID}
echo "" >> received/${ID}
echo "BODY ${ID}" >> received/${ID}
echo "" >> received/${ID}
echo ${BODY} >> received/${ID}

