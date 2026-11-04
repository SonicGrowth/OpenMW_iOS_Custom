#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "${ROOT}"
MODE="${1:---offline}"
case "${MODE}" in
  --offline|--with-source) ;;
  *) echo "Usage: $0 [--offline|--with-source]" >&2; exit 2 ;;
esac

echo "OpenMW iOS fast preflight (${MODE})"
test -s AGENTS.md
test -s docs/source-baseline.md
test -s .agents/skills/openmw-ios-build/SKILL.md
test -s .github/workflows/ios-beta.yml
test -s scripts/prepare-port.sh
test -s scripts/verify-source.sh

bash -n scripts/prepare-port.sh scripts/verify-source.sh
grep -Fq '457ab881442302a9bd59435c1878ed4e72f6e52b' scripts/prepare-port.sh
grep -Fq 'org.openmw.ios.custom.beta' .github/workflows/ios-beta.yml
grep -Fq 'for workflow in ios.yml ios-fast.yml; do' scripts/prepare-port.sh

if [[ "${MODE}" == "--with-source" ]]; then
  bash scripts/prepare-port.sh
  bash scripts/verify-source.sh
  test -s build/upstream-port/.github/workflows/ios.yml
  test -s build/upstream-port/.github/workflows/ios-fast.yml
  git -C build/upstream-port diff --check
  python3 -m unittest discover -s build/upstream-port/validation -p 'test_ios_touch_controls.py' -v
  if [[ -d custom/tests ]]; then
    python3 -m unittest discover -s custom/tests -p 'test_*.py' -v
  fi
else
  echo "Source-backed checks were not run (--offline)."
fi
echo "Fast preflight passed."
