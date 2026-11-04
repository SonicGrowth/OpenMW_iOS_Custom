# Feature 001 — Hide iPhone touchscreen controls

**Status:** Planned, not implemented. Revised 4 November 2026 after developer confirmed his published update concerns **eDukeiOS, not OpenMW**.

## User problem
OpenMW Build 67 displays virtual touch controls even while Morrowind is played with an Xbox controller. Minimum opacity does not fully hide them.

## Phase 1 — manual switch
Adapt the developer's documented [eDukeiOS implementation](research/developer-example.md) to OpenMW's different UIKit/SDL touch system.

- Add a persistent **Touch Controls On/Off** action to the existing OpenMW editor (long-press Pause to open).
- Default touch controls to **On**.
- With controls Off outside editing, draw no virtual buttons and forward no regular game-touch input.
- Maintain a reliable **hold anywhere for two seconds** recovery gesture to reopen the editor, even with the Xbox controller disconnected.
- Release pressed SDL virtual controller inputs before switching Off; don't leave movement/attack stuck.
- Preserve game HUD, menus, Xbox controller bindings, spells, save files and other gameplay.
- Record on-device test results and extend `validation/test_ios_touch_controls.py`.

## Phase 2 — optional automatic mode
Consider automatic hiding on **physical** controller connection and restoring on disconnect only after manual mode works. This is more complex because OpenMW creates its own **virtual SDL joystick** and must not mistake that for Xbox hardware. See [controller architecture research](research/controller-authoritative-method.md).

## Acceptance criteria
- [ ] Milestone 0: unchanged beta builds and runs.
- [ ] Editor toggle and persistent preference work across restarts.
- [ ] When Off, no touch buttons are drawn or normal gameplay touch inputs sent.
- [ ] Long-press anywhere restores editor; touch can be switched On with no controller attached.
- [ ] Existing controller and menu behaviour remains functional.
- [ ] Tests cover switching, persistence, touch suppression and recovery.
- [ ] Feature passes iPhone 15 Pro / Xbox controller testing before merge.

Reference: [eDukeiOS Touch Controls Preview 1](https://github.com/arjunkl/eDukeiOS/releases/tag/touch-controls-preview-1), feature commit `9b0b9fdd8a2c39c3b3e18b3253a43693bb408091`. **Do not install the eDuke IPA for Morrowind.**
