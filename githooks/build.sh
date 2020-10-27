#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

buildFlags="$@"


cd "$DIR" &&
    GOPATH="$DIR/.go" \
        GOBIN="$DIR/bin" \
        go install -tags debug $buildFlags ./...