# Feature 001A — Duke-style manual hide controls (first iPhone experiment)

**Status:** Implemented as a reviewable patch; automated and physical iPhone testing required. This is intentionally the **same basic interaction model** as the developer's [eDukeiOS Touch Controls Preview 1](https://github.com/arjunkl/eDukeiOS/releases/tag/touch-controls-preview-1).

## Scope

- A sixth control-editor action, **HIDE PAD / SHOW PAD**, toggles all drawn OpenMW virtual gamepad buttons and the floating joystick visualization.
- The choice persists in `NSUserDefaults` under `OpenMWIOSTouchControlsDisabledV1`. Default is **controls visible**.
- When controls are hidden, the full-screen touch overlay **absorbs** ordinary touches, as Duke's overlay does. It does not dispatch virtual joystick actions or gestures.
- A **two-second long-press anywhere** reopens the control editor. The recovery recognizer is enabled only while virtual controls are hidden and the editor is closed; the existing 0.75-second long-press MENU continues to open the editor while controls are visible.
- Toggling off releases pressed virtual actions and movement before suppressing touch dispatch. Editor remains usable; preference commits immediately even if Cancel is used for layout changes.
- The physical Xbox controller backend, OpenMW engine and baseline source pin are unchanged.

## Explicitly deferred

**Touchscreen menu tapping while the virtual gamepad is hidden is intentionally NOT supported in this first experiment.** This follows Duke's implemented behaviour. Native UIKit hit-testing still routes those touches to the topmost full-screen control overlay, which returns early without forwarding them. The controller can still navigate in-game menus.

This is a conscious simplification requested for the first beta. After a real-device test, a second patch can retain the hide switch but enable touch passthrough for inventory, dialogue, OK/Cancel and scrolling, using OpenMW's existing mode-aware `pointInside:withEvent:` implementation.

No automatic controller connection detection or alternate graphics changes yet.

## Build and test plan

1. Run the [`openmw-ios-build` skill](../.agents/skills/openmw-ios-build/SKILL.md) and **Quick OpenMW CI checks**. Preflight applies the numbered patch to a fresh pinned upstream checkout, executes original touch tests plus `custom/tests` regressions. No Mac compilation at this stage.
2. Review the small patch on its own feature branch. Do not merge without user acceptance.
3. After quick CI passes, manually dispatch **Build OpenMW iOS Custom Beta** for `feature/001-duke-toggle`, `benchmark_mode=none`. Cached rebuild speed remains unmeasured.
4. Download the unsigned IPA from the successful Actions run, sign via SideStore, install as **OpenMW Beta** (bundle ID `org.openmw.ios.custom.beta`), without overwriting Build 67.
5. On iPhone: open editor using long-press MENU; tap HIDE PAD, Done, confirm controls gone; navigate gameplay/menus using Xbox; hold anywhere 2 seconds; tap SHOW PAD; confirm controls work again; close/reopen app and check saved preference; test without Bluetooth controller.

## Device acceptance log

- Unsigned IPA build: not run yet.
- Device installation: not run.
- Xbox play: not verified.
- Touch input while hidden: expected **suppressed** (Duke parity).
- Gesture recovery and preference persistence: source-backed tests only until physical device test.
