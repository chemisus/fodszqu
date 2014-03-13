#!/bin/bash

URL=http://fodszqu.com/check

IDS=`curl -s ${URL}`

echo ${IDS}

while IFS= read -r ID
do
    ./bin/fodszqu.receive.sh $ID
done <<< "$IDS"
