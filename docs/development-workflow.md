# Methodical development workflow

1. Open a GitHub issue describing the problem and acceptance checks.
2. Read pinned upstream source and official OpenMW conventions; link relevant evidence.
3. Create a `feature/<issue>-<short-description>` branch.
4. Run `./scripts/prepare-port.sh` to fetch and verify upstream source into `build/upstream-port`.
5. Develop in the isolated checkout, capture the changes as numbered patches under `custom/patches/`, and document them.
6. Verify patch application using `git apply --check` and run available validation.
7. Open a PR with a diff, test evidence, risks and rollback instructions.
8. Manually run **Build OpenMW iOS Custom Beta** through GitHub Actions; record the resulting unsigned IPA, run URL and SHA-256.
9. User backs up settings/saves, installs the **separate beta bundle identifier**, and tests against `docs/iphone-test-checklist.md`.
10. Mark issue accepted/rejected; only merge approved work. Stable Build 67 is never overwritten by beta.

Do not execute costly builds on each documentation edit. The beta workflow is manual-only until explicitly changed.
