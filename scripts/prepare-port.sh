#!/usr/bin/env bash
set -euo pipefail

# Fetch a reproducible exact upstream snapshot; do not change the user's working iPhone app.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_URL="https://github.com/arjunyerevan95-dot/OpenMWiOS.git"
SOURCE_COMMIT="457ab881442302a9bd59435c1878ed4e72f6e52b"
SRC_DIR="${ROOT}/build/upstream-port"
COPY_TO_ROOT=0
if [[ "${1:-}" == "--copy-to-root" ]]; then COPY_TO_ROOT=1; fi

mkdir -p "${ROOT}/build"
if [[ ! -d "${SRC_DIR}/.git" ]]; then
  git init -q "${SRC_DIR}"
  git -C "${SRC_DIR}" remote add origin "${UPSTREAM_URL}"
fi
git -C "${SRC_DIR}" fetch -q --depth=1 origin "${SOURCE_COMMIT}"
git -C "${SRC_DIR}" -c advice.detachedHead=false checkout --force --detach "${SOURCE_COMMIT}" >/dev/null
ACTUAL="$(git -C "${SRC_DIR}" rev-parse HEAD)"
[[ "${ACTUAL}" == "${SOURCE_COMMIT}" ]] || { echo "Wrong upstream commit: ${ACTUAL}" >&2; exit 1; }

# Always start patches from a clean upstream snapshot.
if compgen -G "${ROOT}/custom/patches/*.patch" >/dev/null; then
  for patch in "${ROOT}"/custom/patches/*.patch; do
    git -C "${SRC_DIR}" apply --check "${patch}"
    git -C "${SRC_DIR}" apply "${patch}"
    echo "Applied ${patch##*/}"
  done
fi

if [[ ${COPY_TO_ROOT} -eq 1 ]]; then
  # Only CI should use this option. It copies source into the ephemeral checkout
  # so the original upstream build workflow's relative paths still work.
  # Protect this downstream README and custom workflow from replacement.
  rsync -a --exclude='.git' --exclude='README.md' --exclude='.github/' "${SRC_DIR}/" "${ROOT}/"

  # Upstream's test_multiconfig_manifests and cheap YAML validation require
  # these original workflow files at their standard paths. Copy them only
  # into the ephemeral CI checkout: keep our custom ios-beta.yml unchanged.
  mkdir -p "${ROOT}/.github/workflows"
  for workflow in ios.yml ios-fast.yml; do
    test -s "${SRC_DIR}/.github/workflows/${workflow}" || {
      echo "Missing pinned upstream workflow: ${workflow}" >&2
      exit 1
    }
    cp "${SRC_DIR}/.github/workflows/${workflow}" "${ROOT}/.github/workflows/${workflow}"
  done
fi

echo "Verified pinned OpenMW iOS port: ${SOURCE_COMMIT}"
echo "Source checkout: ${SRC_DIR}"
