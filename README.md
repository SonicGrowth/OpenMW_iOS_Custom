# OpenMW iOS Custom

An independent, experimental development project to improve Xbox-controller and touchscreen usability in the [OpenMW iOS port](https://github.com/arjunyerevan95-dot/OpenMWiOS).

**Status:** Bootstrap. No custom IPA has been compiled or installed yet. Keep the existing working Build 67 installation unchanged.

## Reproducible source baseline

This is a **pinned-upstream + patch overlay** repository, rather than a duplicate of hundreds of upstream files. A script downloads the exact verified upstream revision into an isolated build directory, checks its SHA, and applies only reviewed patches from `custom/patches/`. This keeps the upstream project's Git history and our custom changes clearly separate.

- [Original Build 67 release](https://github.com/arjunyerevan95-dot/OpenMWiOS/releases/tag/ios-fast-67) — published 2 September 2026.
- Upstream iOS source commit: `457ab881442302a9bd59435c1878ed4e72f6e52b`.
- OpenMW engine 0.51.0 revision: `f4bec41444214a7903bebd178389ca22ca13f646`.
- Native iOS build target: arm64, minimum iOS 16.3, SDL2 + GL4ES.

## Development flow

1. Read `AGENTS.md`, `PROJECT.md`, `docs/source-baseline.md`, and the relevant issue.
2. Work on one `feature/<issue>-<name>` branch at a time.
3. Research upstream conventions before changing the engine; prefer configurations/mods over unnecessary forks.
4. Keep modifications as inspectable patches in `custom/patches/`; validate patch application.
5. Run unit/static tests and create a traceable **separate beta IPA** using the manual GitHub Actions workflow.
6. Test on an iPhone, record results and merge only approved changes.

**Never distribute copyrighted Morrowind game files or commit personal saves, Apple signing material, or credentials.**

## First feature

[Feature 001 — Controller-only mode](docs/feature-001-controller-mode.md): hide on-screen touch controls while using a physical gamepad and restore access when the controller disconnects.

OpenMW's GPLv3 and dependency notices apply; redistribution review is pending. See `docs/licensing-review.md`.
