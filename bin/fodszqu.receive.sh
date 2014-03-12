#!/bin/bash

curl localhost:8000/message/$1/head | base64 --decode > head_received_encrypted
curl localhost:8000/message/$1/body | base64 --decode > body_received_encrypted

mkdir received

openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in head_received_encrypted -out received/${1}_head
openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in body_received_encrypted -out received/${1}_body
