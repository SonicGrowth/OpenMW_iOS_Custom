---
name: openmw-ios-build
description: Use whenever building, debugging, optimizing, validating, or packaging the OpenMW iOS Custom project, especially for controller and iOS changes, GitHub Actions, toolchain dependencies, and cache performance.
---

# Efficient OpenMW iOS builds

This repository-local Codex skill selects the least expensive verification that can catch an error. Read `AGENTS.md`, `docs/source-baseline.md`, and [Build #2 lessons](references/build-2-lessons.md) before acting.

## Choose the validation tier

- **Docs or skill instructions only:** review changed files, links, and offline preflight. **Do not** initiate a full IPA build.
- **CI scripts, source pin, patch metadata:** run the fast source-backed preflight / **Quick OpenMW CI checks** (Ubuntu), not the 2-hour macOS build.
- **C++ touch model or Objective-C++ overlay patch:** run quick checks and upstream touch-model tests; after review run one actual beta build.
- **Toolchain/engine/dependency/renderer changes:** review ABI/cache invalidation and build a full iPhone beta; do not use stale objects.
- **Device release:** a successful IPA build alone is insufficient; require on-device Xbox/controller and save-data acceptance.

## Run quick preflight before full CI

From repository root:

```bash
bash .agents/skills/openmw-ios-build/scripts/preflight.sh --offline
bash .agents/skills/openmw-ios-build/scripts/preflight.sh --with-source
```

The source-backed variant fetches the pinned Build 67 revision, checks the SHA, patch application, the two upstream workflow fixtures missing in failed Build #1, the engine pin, diff whitespace and upstream touch-model tests. If network is unavailable, perform only offline checks and explicitly report what wasn't tested.

GitHub also runs [Quick OpenMW CI checks](../../../.github/workflows/quick-checks.yml) on relevant PRs. This **does not** compile the iPhone application.

## Efficient full-build procedure

1. Develop a small patch on a feature branch; inspect the diff and run quick checks.
2. Only when the patch warrants device compilation, manually dispatch `.github/workflows/ios-beta.yml` on that branch with `benchmark_mode=none`. The other benchmark modes intentionally touch files to force recompilation.
3. Inspect `cache-fingerprints.txt` and `fast-timings.tsv` in the last artifact. The original Build #2 saved source-download, vcpkg binary and qualified incremental-state caches; GitHub can restore accessible default-branch caches on feature branches.
4. Let ABI/source-fingerprint checks invalidate stale outputs. Do not fake a cache hit, disable validation, or change the pinned upstream engine to accelerate builds.
5. Compare cached rebuild durations with the **122-minute cold Build #2**, labelling cold vs warm. The warmed build time is **not yet known**.
6. Check successful staging, bundle identifier `org.openmw.ios.custom.beta`, product upload, unsigned IPA, checksum and 7-day artifact retention.

## Diagnose slow or failed jobs

- Fetch the exact workflow run and **currently active or failed job step**; inspect current log timestamps. An old job is not necessarily hung.
- Read the meaningful compiler or validation error and targeted failure diagnostics before editing code. Fix the *first real root cause* and start a **new** run for the corrected commit, not a rerun of the old SHA.
- Distinguish dependency preparation from actual Xcode compile/link. Check the configured 180-minute timeout; avoid cancelling an actively compiling job.
- Do not run expensive full builds for documentation-only changes.
- After each meaningful build, record stage timing, cache hit/miss state, source SHA, IPA checksum, and actual device results.

## Boundaries

Read `docs/research/developer-example.md` for the real eDukeiOS touch toggle pattern, but never paste incompatible engine code blindly. Do not bundle Morrowind data, signing keys, or personal saves. A green GitHub badge proves compilation and package verification, **not** working gameplay. Follow `docs/iphone-test-checklist.md` for hardware validation.

A skill is a reusable procedure; **it does not automatically accelerate the compiler**. Speed comes from avoiding unnecessary full builds, maintaining safe caches and verifying work cheaply first.
