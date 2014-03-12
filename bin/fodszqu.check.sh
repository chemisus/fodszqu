#!/bin/bash

curl localhost:8000/messages > check

while read line
do
    ID=$line
    ./fodszqu.receive.sh $ID
done < check
