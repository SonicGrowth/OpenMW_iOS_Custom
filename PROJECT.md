# Project charter

**Purpose:** Maintain a safe, reproducible experimental iPhone OpenMW build and make small, verifiable usability improvements, initially to Xbox-controller and touch-overlay behaviour.

**Owner/tester:** The repository owner defines desired behaviour and tests on an iPhone 15 Pro with an Xbox controller.

**Baseline:** Upstream Build 67, OpenMW 0.51.0; source pinned by SHA. Stable installed application stays untouched.

**Architecture:** Repository contains project governance, build scripts, manual GitHub Actions workflow, reviewable custom patches and tests. Upstream source is fetched and verified per build rather than vendored or modified in place.

**Definition of done:** Feature scope approved; implementation reviewed; clean upstream checkout + patches reproduces; automated checks pass; beta IPA generated with separate app identifier; physical iPhone acceptance tests pass; release notes and licence obligations reviewed.

**Not in initial scope:** Mod manager, renderer rewrite, changes to Morrowind game balance, shipping game data, App Store distribution.

**First milestone:** Build an *unchanged* OpenMW 0.51 iOS beta from pinned Build 67 source and verify that it runs alongside the existing installation. No feature patch until baseline passes.
