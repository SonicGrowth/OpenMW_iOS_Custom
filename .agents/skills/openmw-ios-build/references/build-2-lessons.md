# Build #2 retrospective — 4 November 2026

## Verified evidence

[Successful run #2](https://github.com/SonicGrowth/OpenMW_iOS_Custom/actions/runs/41743131269), `main` commit `d15b670d366f5f799109bbee600aeeb54969d402`, began 2026-11-03 23:57:13 UTC, completed 2026-11-04 01:59:51 UTC (**2h 2m 38s**). Source pin: `457ab881442302a9bd59435c1878ed4e72f6e52b`.

Approximate wall-time distribution from build logs:

| Stage | Duration | Observation |
| --- | --- | --- |
| Setup, source verification and dependency configure/build | ~53 min | Cold vcpkg packages, including FFmpeg, ICU, SDL2, Boost, etc. |
| Native ARM64 OpenMW compile and link | ~65 min | Xcode built the full original engine and components |
| IPA verification/upload and cache saves | ~4 min | Validation passed; cached build state archive was ~1.46 GB |
| **Total** | **~122 min** | First successful **cold** build |

### Outcome

- All upstream source validation checks, ARM64 production compilation, packaging and resource/bundle checks passed.
- Correct beta identity: `org.openmw.ios.custom.beta`; staging applies display name `OpenMW Beta`.
- GitHub artifact `OpenMW-iOS-custom-beta-2`, ID `13288981369`; archive SHA-256 `d98ec71b2398ed6610f9e1ea1a25565a04e2c4cf64290653d2efab5b87d8e14c`. **This is the artifact ZIP digest**, not the embedded IPA digest (see `product-sha256.txt` in artifact).
- GitHub artifact retention 7 days, expiring 2026-11-11T01:55:46Z.
- Source downloads, vcpkg compiled packages, and qualified incremental-state caches all **saved successfully**; relevant cache prefixes are `ios-source-downloads-v5`, `vcpkg-ios-v4`, `ios-fast-state-v4`.

### Lessons

**Run #1 failure:** Our custom checkout excluded upstream `.github/`, so source validation could not find original `.github/workflows/ios.yml`. [PR #4](https://github.com/SonicGrowth/OpenMW_iOS_Custom/pull/4) fixed this by copying two original workflows into the disposable CI checkout only. The new fast preflight explicitly checks those fixtures.

**Time:** The 2 hours mostly came from building the unmodified game and dependencies, **not** from a small touchscreen change. Running a full compile on every minor code edit or documentation update wastes runner time.

**Caching:** Saved caches should improve eligible subsequent builds, but restoring a large archive also costs time, and source/ABI changes may force recompilation. **No warm build has yet been measured**, so don't promise specific savings. GitHub cache lookup may use default-branch caches on feature branches, subject to cache scope rules. Never bypass ABI validation.

### Repeatable procedure

1. Docs-only: no full compile.
2. Patch, script or workflow change: run [Quick OpenMW CI checks](../../../../.github/workflows/quick-checks.yml) on Ubuntu, including pinned source preparation and upstream touch-model tests.
3. On reviewable feature milestone: manually run `ios-beta.yml` with benchmark mode `none` and capture cache-hit status.
4. Only close an iPhone feature after physical-device tests. Report cache hits/misses and stage timing with each meaningful run.

Reference: [GitHub dependency caching](https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching).
