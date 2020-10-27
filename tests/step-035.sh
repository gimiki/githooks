#!/bin/sh
# Test:
#   Direct template execution: do not trust the repository

mkdir -p ~/.githooks/release && cp /var/lib/githooks/*.sh ~/.githooks/release || exit 1
mkdir -p /tmp/test35 && cd /tmp/test35 || exit 1
git init || exit 1

mkdir -p .githooks/pre-commit &&
    touch .githooks/trust-all &&
    echo 'echo "Accepted hook" > /tmp/test35.out' >.githooks/pre-commit/test &&
    TRUST_ALL_HOOKS=N ACCEPT_CHANGES=Y \
        ~/.githooks/release/base-template.sh "$(pwd)"/.git/hooks/pre-commit

if ! grep -q "Accepted hook" /tmp/test35.out; then
    echo "! Expected hook was not run"
    exit 1
fi

echo 'echo "Changed hook" > /tmp/test35.out' >.githooks/pre-commit/test &&
    TRUST_ALL_HOOKS="" ACCEPT_CHANGES=N \
        ~/.githooks/release/base-template.sh "$(pwd)"/.git/hooks/pre-commit

if grep -q "Changed hook" /tmp/test35.out; then
    echo "! Changed hook was unexpectedly run"
    exit 1
fi

if ! CFG=$(git config --get githooks.trust.all) || [ "$CFG" != "false" ]; then
    echo "! Unexpected config found"
    exit 1
fi
