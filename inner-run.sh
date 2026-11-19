#/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

cd "$(dirname "$0")"

rustc --version
cargo --version

cargo run binary

RUSTFLAGS="-Dunused-crate-dependencies" cargo run binary

pushd binary && cargo add bitflags && popd

set +o errexit
cargo run binary
EXIT_CODE=$?
set -o errexit
echo "Exit code: $EXIT_CODE"
if [ "$EXIT_CODE" -eq "0" ]; then
    echo "The command succeeded unexpectedly."
    exit 1
else
    pushd binary && cargo remove bitflags && popd
    exit $EXIT_CODE
fi
