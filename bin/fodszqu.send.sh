#!/bin/bash

SEND_URL=http://fodszqu.com/message
KEY=sending/id_rsa.pem.pub

# compose the message
mkdir sending

nano sending/head_send
nano sending/body_send

# generate the key to encrypt
ssh-keygen -f ~/.ssh/id_rsa.pub -e -m PKCS8 > ${KEY}

# encrypt the message
HEAD=`openssl rsautl -encrypt -pubin -inkey ${KEY} -ssl -in sending/head_send | base64`
BODY=`openssl rsautl -encrypt -pubin -inkey ${KEY} -ssl -in sending/body_send | base64`

# send the message
curl -F "head=$HEAD" -F "body=$BODY" ${SEND_URL}

# delete the local files
rm sending -r

