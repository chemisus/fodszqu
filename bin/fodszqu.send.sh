#!/bin/bash

# compose the message
nano head_send
nano body_send

# generate the key to encrypt
ssh-keygen -f ~/.ssh/id_rsa.pub -e -m PKCS8 > id_rsa.pem.pub

# encrypt the message
openssl rsautl -encrypt -pubin -inkey id_rsa.pem.pub -ssl -in head_send -out "head_send_encrypted"
openssl rsautl -encrypt -pubin -inkey id_rsa.pem.pub -ssl -in body_send -out "body_send_encrypted"

# load the variables
HEAD=`cat head_send_encrypted | base64`
BODY=`cat body_send_encrypted | base64`

# send the message
curl -F "head=$HEAD" -F "body=$BODY" localhost:8000/message

# delete the local files
rm head_send
rm body_send
rm head_send_encrypted
rm body_send_encrypted
