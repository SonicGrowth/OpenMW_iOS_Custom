# AGENTS.md — instructions for Codex and coding agents

Project: OpenMW iOS Custom, built as a pinned upstream source + small patch overlay.

1. Before coding, read `PROJECT.md`, `docs/source-baseline.md`, and the relevant feature issue/specification.
2. Treat upstream port, OpenMW engine, iOS platform layer, and Morrowind proprietary game data as separate components.
3. Pin all upstream revisions. Do not silently change `457ab881442302a9bd59435c1878ed4e72f6e52b` or the OpenMW engine version.
4. Develop in short-lived `feature/<issue>-<topic>` branches. One logical change per pull request; no unrelated formatting or refactors.
5. Research whether a setting, upstream implementation, or game mod already solves the problem before changing engine code. For game-controller and touchscreen changes, **first read** `docs/research/controller-authoritative-method.md` and its linked official Apple game-porting skill, Apple's iOS virtual-control guidance, SDL2 joystick APIs, and OpenMW development conventions. Distinguish SDL's own virtual joystick from a physical Xbox controller.
6. Compare upstream and experimental WO40 implementations *for reference only*. WO40 uses a different OpenMW 0.52/Zink layout, not a drop-in patch.
7. Store actual port modifications as numbered `custom/patches/*.patch` with explanation, tests and affected source references.
8. **Mandatory for OpenMW build, build failure, release, cache, or iOS patch work:** read and use `.agents/skills/openmw-ios-build/SKILL.md`. Start with its fast preflight and the lightweight `Quick OpenMW CI checks` workflow. Only run the full macOS IPA build when the change demands it. Check patches using `git apply --check`; passing CI does not prove behaviour on iPhone.
9. Never overwrite the user's installed Build 67; test with an isolated bundle ID `org.openmw.ios.custom.beta`. Check iOS storage independence and back up saves before user testing.
10. Record source SHA, patch SHA, workflow run, IPA checksum, signing/install method, known failures and physical-device findings.
11. Preserve original licence notices and attribution. Do not commit Bethesda game assets, private saves, Apple credentials, signing keys, or provisioning profiles.
12. Do not merge without an explicit acceptance report and user approval.

Always distinguish observed facts from assumptions and unverified technical claims.
