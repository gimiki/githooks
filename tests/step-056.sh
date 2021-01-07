#!/bin/sh
# Test:
#   Cli tool: disable a hook

"$GITHOOKS_BIN_DIR/installer" --stdin || exit 1

mkdir -p /tmp/test056/.githooks/pre-commit &&
    echo 'echo "Hello"' >/tmp/test056/.githooks/pre-commit/first &&
    echo 'echo "Hello"' >/tmp/test056/.githooks/pre-commit/second &&
    cd /tmp/test056 &&
    git init ||
    exit 1

if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore add --pattern "**/first"; then
    echo "! Failed to disable a hook"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'ignored'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'active'"; then
    echo "! Unexpected cli list output (1)"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore add --pattern "pre-commit/**"; then
    echo "! Failed to disable a hook"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'ignored'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'ignored'"; then
    echo "! Unexpected cli list output (2)"
    exit 1
fi

# Negate the pattern
if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore add --pattern "!**/second"; then
    echo "! Failed to disable a hook"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'ignored'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'active'"; then
    echo "! Unexpected cli list output (3)"
    exit 1
fi

# Negate the pattern more
if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore add --pattern "!**/*"; then
    echo "! Failed to disable a hook"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'active'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'active'"; then
    echo "! Unexpected cli list output (4)"
    exit 1
fi

# Exclude all
if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore add --pattern "**/*"; then
    echo "! Failed to disable a hook"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'ignored'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'ignored'"; then
    echo "! Unexpected cli list output (5)"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore remove --all; then
    echo "! Failed to disable alls hooks"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'active'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'active'"; then
    echo "! Unexpected cli list output (6)"
    exit 1
fi

# with full matches by  namespace paths
if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore add --pattern "pre-commit/first"; then
    echo "! Failed to disable a hook"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'ignored'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'active'"; then
    echo "! Unexpected cli list output (7)"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" ignore add --pattern "pre-commit/second"; then
    echo "! Failed to disable a hook"
    exit 1
fi

if ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "first" | grep -q "'ignored'" ||
    ! "$GITHOOKS_EXE_GIT_HOOKS" list | grep "second" | grep -q "'ignored'"; then
    echo "! Unexpected cli list output (8)"
    exit 1
fi
