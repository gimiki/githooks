#!/bin/sh

cat <<EOF | docker build --force-rm -t githooks:testsuite-go -
FROM golang:1.15.6-alpine
RUN apk add git curl git-lfs --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main --allow-untrusted
RUN apk add bash

RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b \$(go env GOPATH)/bin v1.34.1

EOF

if ! docker run --rm -it -v "$(pwd)":/data -w /data githooks:testsuite-go sh "tests/exec-testsuite-go.sh"; then
    echo "! Check rules had failures."
    exit 1
fi

exit 0
