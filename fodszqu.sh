#!/bin/sh

FODSZQU=http://fodszqu.com
API=${FODSZQU}/api

MESSAGES_URL=${API}/messages
KEYS_URL=${API}/keys

PEM=sending/id_rsa.pem.pub
KEY=id_rsa.pub

HEAD_P=sending/head_p
BODY_P=sending/body_p
HEAD_E=sending/head_e
BODY_E=sending/body_e

function sendMail {
    echo "sending mail";

    # compose the message
    mkdir sending

    nano ${HEAD_P}
    nano ${BODY_P}

    # generate the key to encrypt
    # openssl rsa -in ~/.ssh/id_rsa -pubout > ${PEM}
    TO=`cat ${HEAD_P}`

    # encrypt the message
    cat ${HEAD_P} | openssl rsautl -encrypt -pubin -inkey keys/${TO} > ${HEAD_E}
    cat ${BODY_P} | openssl rsautl -encrypt -pubin -inkey keys/${TO} > ${BODY_E}

    # send the message
    ID=`curl -s -F head=@${HEAD_E} -F body=@${BODY_E} ${MESSAGES_URL}`

    # delete the local files
    rm -r sending

    echo "Message sent @ ${FODSZQU}/message/${ID}"
}

function publishKey {
    echo "publishing key";

    openssl rsa -in ~/.ssh/id_rsa -pubout > ${KEY}

    ID=`curl -s -F key=@${KEY} ${KEYS_URL}`

    rm ${KEY}

    echo "Key published @ ${FODSZQU}/keys/${ID}"
}

function fetchMail {
    echo "fetching mail $1";

    HEAD_URL=${MESSAGES_URL}/${1}/head
    BODY_URL=${MESSAGES_URL}/${1}/body

    HEAD=`curl -s ${HEAD_URL} | openssl rsautl -decrypt -inkey ~/.ssh/id_rsa`
    BODY=`curl -s ${BODY_URL} | openssl rsautl -decrypt -inkey ~/.ssh/id_rsa`

    mkdir received

    echo "HEAD ${1}" > received/${1}
    echo "" >> received/${1}
    echo ${HEAD} >> received/${1}
    echo "" >> received/${1}
    echo "BODY ${1}" >> received/${1}
    echo "" >> received/${1}
    echo ${BODY} >> received/${1}
}

function checkMail {
    echo "checking mail";

    IDS=`curl -s ${MESSAGES_URL}`

    while IFS= read -r ID
    do
        fetchMail ${ID}
    done <<< "${IDS}"
}

function fetchKey {
    echo "fetching key $1 as $2";

    curl -s ${KEYS_URL}/${1} > keys/${2}
}

function main {
    if [ "$1" == "send" ]
    then
        sendMail;
    elif [ "$1" == "check" ]
    then
        checkMail;
    elif [ "$1" == "fetch" ]
    then
        fetchMail $2;
    elif [ "$1" == "publish" ]
    then
        publishKey;
    elif [ "$1" == "key" ]
    then
        fetchKey $1 $2;
    fi
}

main $1 $2