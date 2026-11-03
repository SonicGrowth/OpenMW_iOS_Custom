# OpenMW iOS Custom

An experimental, independent project to improve controller and touchscreen usability in the [OpenMW iOS port](https://github.com/arjunyerevan95-dot/OpenMWiOS).

> **Status:** Bootstrap. No custom IPA has been built or validated. The user's working Build 67 installation must remain untouched.

## Verified source baseline

- **Port:** [OpenMW iOS Build 67](https://github.com/arjunyerevan95-dot/OpenMWiOS/releases/tag/ios-fast-67)
- **Port source commit:** `457ab881442302a9bd59435c1878ed4e72f6e52b`
- **OpenMW engine:** 0.51.0 (`f4bec41444214a7903bebd178389ca22ca13f646`)
- **iOS target:** arm64, iOS 16.3+
- **Input/rendering:** SDL2, GL4ES

This project's initial task is to import and reproduce the *unmodified* port source and build an isolated beta. Work on the touchscreen feature starts only after that baseline is verified.

## Development process

1. Research the relevant upstream implementation and OpenMW's engineering conventions.
2. Record a GitHub issue with acceptance criteria.
3. Implement one small change per feature branch.
4. Require source review, automated checks and a traceable IPA build.
5. Install beta with a **different iOS bundle identifier** to protect the existing working app.
6. Test on iPhone; only release after explicit acceptance.

The WO40 Zink Touch branch is experimental OpenMW 0.52-based reference material, **not** a drop-in compatible patch for Build 67.

## First planned feature

**Controller-only mode:** provide a way to hide touchscreen overlays while using a physical Xbox controller and restore them when necessary. Preserve controller inputs, menus, saves and manual touchscreen access.

## Licensing and game data

OpenMW is GPLv3-licensed and other included components have their own licenses. Preserve upstream notices and verify distribution obligations before publishing binaries. No Bethesda Morrowind game assets, user saves, signing certificates, or account credentials belong in this repository.

See `AGENTS.md` and `docs/source-baseline.md` for project conventions and provenance.
