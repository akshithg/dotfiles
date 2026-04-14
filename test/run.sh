#!/bin/sh
# Build and validate dotfiles in container test environments.
# Usage: ./test/run.sh [ubuntu|debian|all]
set -eu

cd "$(dirname "$0")/.."

target="${1:-all}"
distros="ubuntu debian"
[ "$target" != "all" ] && distros="$target"

for distro in $distros; do
    echo "=========================================="
    echo "  Testing: $distro"
    echo "=========================================="
    if docker build -f "test/$distro.Dockerfile" -t "dotfiles-test-$distro" . ; then
        echo "PASS: $distro"
    else
        echo "FAIL: $distro"
        exit 1
    fi
    echo
done

echo "All passed. Run interactively with: docker run --rm -it dotfiles-test-<distro>"
