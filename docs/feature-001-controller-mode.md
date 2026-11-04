# Feature 001 — Hide iPhone touchscreen controls

**Status:** Planned, not implemented. Revised 4 November 2026 after developer confirmed his published update concerns **eDukeiOS, not OpenMW**.

## User problem
OpenMW Build 67 displays virtual touch controls even while Morrowind is played with an Xbox controller. Minimum opacity does not fully hide them.

## Phase 1 — manual switch
Adapt the developer's documented [eDukeiOS implementation](research/developer-example.md) to OpenMW's different UIKit/SDL touch system.

- Add a persistent **Touch Controls On/Off** action to the existing OpenMW editor (long-press Pause to open).
- Default touch controls to **On**.
- With controls Off outside editing, draw no virtual gamepad buttons/joystick and do not dispatch virtual joystick, gamepad actions, movement or look gestures from the overlay. **Do not disable normal touchscreen interaction with the actual Morrowind interface.**
- Maintain a reliable **hold anywhere for two seconds** recovery gesture to reopen the editor, even with the Xbox controller disconnected.
- **Menu input must keep working:** Morrowind inventory, dialogue, journal, settings, save/load and confirmation dialogs must still receive native taps and scrolling while virtual controls are hidden. The overlay's existing `pointInside:withEvent:` already passes most GUI touches to the underlying SDL view; preserve that passthrough. The existing gameplay-mode hit-test covers the whole screen, so do **not** naively set `self.hidden = YES` or add an unconditional `touchesBegan: return` without designing for both GUI passthrough and recovery.
- A suggested division to validate: while editing, capture editor touches; while in GUI, let ordinary touches reach the underlying game; while in gameplay, suppress virtual gamepad actions and still support a recovery long-press. The gesture recognizer must not interfere with quick menu taps or swipes.
- **Duke-specific limitation confirmed:** its full-screen overlay has no `pointInside:` override and its hidden-mode `touchesBegan:` returns immediately. Thus its shipped approach does **not** establish native menu tap passthrough. Our implementation must be different: keep OpenMW's GUI hit-test passthrough and test a non-cancelling long-press recovery recognizer attached to an appropriate ancestor view (not solely an overlay which declines hit testing). See [full comparison](research/developer-example.md).
- Release pressed SDL virtual controller inputs before switching Off; don't leave movement/attack stuck.
- Preserve game HUD, menus, Xbox controller bindings, spells, save files and other gameplay.
- Record on-device test results and extend `validation/test_ios_touch_controls.py`.

## Phase 2 — optional automatic mode
Consider automatic hiding on **physical** controller connection and restoring on disconnect only after manual mode works. This is more complex because OpenMW creates its own **virtual SDL joystick** and must not mistake that for Xbox hardware. See [controller architecture research](research/controller-authoritative-method.md).

## Acceptance criteria
- [ ] Milestone 0: unchanged beta builds and runs.
- [ ] Editor toggle and persistent preference work across restarts.
- [ ] When Off, no touch buttons are drawn and no **virtual gamepad** actions are generated, but normal menu taps and scrolling still reach Morrowind.
- [ ] Long-press anywhere restores editor; touch can be switched On with no controller attached.
- [ ] Xbox controller gameplay remains functional; with the virtual controls hidden, finger taps select inventory items, dialogue responses, OK/Cancel and settings; menu swipe/scroll works.
- [ ] Editor recovery is possible with the controller disconnected and does not steal menu taps.
- [ ] Tests cover switching, persistence, touch suppression and recovery.
- [ ] Feature passes iPhone 15 Pro / Xbox controller testing before merge.

Reference: [eDukeiOS Touch Controls Preview 1](https://github.com/arjunkl/eDukeiOS/releases/tag/touch-controls-preview-1), feature commit `9b0b9fdd8a2c39c3b3e18b3253a43693bb408091`. **Do not install the eDuke IPA for Morrowind.**
