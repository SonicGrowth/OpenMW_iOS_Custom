#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${ROOT}/build/upstream-port"
EXPECTED="457ab881442302a9bd59435c1878ed4e72f6e52b"
ENGINE="f4bec41444214a7903bebd178389ca22ca13f646"
test -d "${SRC}/.git" || { echo "Run scripts/prepare-port.sh first" >&2; exit 1; }
test "$(git -C "${SRC}" rev-parse HEAD)" = "${EXPECTED}"
grep -Fq "${ENGINE}" "${SRC}/versions.env"
test -f "${SRC}/ios/openmw_ios_touch_controls.mm"
test -f "${SRC}/.github/workflows/ios-fast.yml"
echo "Pinned source and required build files verified."
