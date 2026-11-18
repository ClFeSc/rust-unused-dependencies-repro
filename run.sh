#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ -z "${1+xxx}" ]; then echo "Usage: \"$0\" [containerized executable (e.g. podman or docker)] [rust version (e.g. 1.99)]"; exit 1; fi
if [ -z "${2+xxx}" ]; then echo "Usage: \"$0\" \"$1\" [rust version (e.g. 1.99)]"; exit 1; fi
CONTAINERIZED_EXECUTABLE="$1"
RUST_VERSION="$2"

"$CONTAINERIZED_EXECUTABLE" --version

if "$CONTAINERIZED_EXECUTABLE" info >/dev/null 2>&1; then
    "$CONTAINERIZED_EXECUTABLE" run --rm --volume ".:/workspace" "docker.io/rust:$RUST_VERSION" bash -c '/workspace/inner-run.sh'
else
    sudo "$CONTAINERIZED_EXECUTABLE" run --rm --volume ".:/workspace" "docker.io/rust:$RUST_VERSION" bash -c '/workspace/inner-run.sh'
fi
