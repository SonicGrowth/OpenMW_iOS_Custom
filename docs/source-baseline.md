# Verified upstream source baseline — 4 November 2026

- Port repo: https://github.com/arjunyerevan95-dot/OpenMWiOS
- Release: https://github.com/arjunyerevan95-dot/OpenMWiOS/releases/tag/ios-fast-67
- Release date: 2026-09-02 (UTC)
- Release IPA: `OpenMW-iOS-unsigned.ipa` (unsigned; requires signing/sideloading)
- Published IPA SHA-256: `9312ea3b1ad757e9cee8a22785907f93ad9c68a33e02d845210ff5f733660593`
- Source commit: `457ab881442302a9bd59435c1878ed4e72f6e52b`
- Engine revision in `versions.env`: `f4bec41444214a7903bebd178389ca22ca13f646` (OpenMW 0.51.0)
- Target: iOS 16.3+ arm64; SDL2 + GL4ES.
- Original workflow: `.github/workflows/ios-fast.yml`, uses macOS Intel runner and pinned Xcode 16.4.

Source file references:
- https://github.com/arjunyerevan95-dot/OpenMWiOS/blob/457ab881442302a9bd59435c1878ed4e72f6e52b/ios/openmw_ios_touch_controls.mm
- https://github.com/arjunyerevan95-dot/OpenMWiOS/blob/457ab881442302a9bd59435c1878ed4e72f6e52b/versions.env
- https://github.com/arjunyerevan95-dot/OpenMWiOS/blob/457ab881442302a9bd59435c1878ed4e72f6e52b/.github/workflows/ios-fast.yml

The experimental WO40 branch (reference commit `5b55597d9e183a50e7eed4594f9bc1444ec4dd6a`) is OpenMW 0.52 / Zink-MoltenVK with a different source layout. Treat its controller handling as design/reference material, not a drop-in patch.

**Provenance model:** Clone the upstream git repository at the exact pinned commit, verify `HEAD`, then apply our independent patch series. We preserve provenance via the original upstream commit and its Git history in the source checkout; we do not claim this custom repository is a fork containing the entire upstream commit graph.

**Unverified:** First clean reproduction, current GitHub runner/Xcode availability, signing/SideStore install, device performance, binary equivalence, licensing for every bundled dependency. All require acceptance evidence.
