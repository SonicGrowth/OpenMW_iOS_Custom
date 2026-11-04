# Expert-backed design research — Feature 001 (Xbox controller-only mode)

**Status:** Design investigation; **not implemented or tested on hardware**. Applies to OpenMW iOS Build 67, port commit `457ab881442302a9bd59435c1878ed4e72f6e52b` (OpenMW 0.51.0).

## Authoritative references to study before coding

1. **Apple's published game-porting skill:** [`using-game-controller/SKILL.md`](https://github.com/apple/game-porting-toolkit/blob/main/game-porting-skills/skills/using-game-controller/SKILL.md). Read its Controller Lifecycle and Best Practices sections, including the [platform notes](https://github.com/apple/game-porting-toolkit/blob/main/game-porting-skills/skills/using-game-controller/reference/platform-notes.md).
2. **Apple's explicit show/hide design:** [Adding virtual controls to games that support game controllers in iOS](https://developer.apple.com/documentation/gamecontroller/adding-virtual-controls-to-games-that-support-game-controllers-in-ios). Apple's documented pattern is to show touch controls without an external controller and hide them when a physical controller connects; it includes connection/disconnection handling.
3. **Apple controller discovery:** [GCController.controllers()](https://developer.apple.com/documentation/gamecontroller/gccontroller/controllers%28%29) and notifications for controller connection/disconnection. Do not assume the controller array is ordered, or that every `GCController` object is physical.
4. **SDL2 device classification:** [SDL_JoystickIsVirtual](https://wiki.libsdl.org/SDL2/SDL_JoystickIsVirtual) differentiates SDL virtual and nonvirtual joysticks. [SDL controller-device events](https://wiki.libsdl.org/SDL2/SDL_ControllerDeviceEvent) report devices arriving/leaving, with an **index** on addition and an **instance ID** on removal. [SDL_JoystickAttachVirtualEx](https://wiki.libsdl.org/SDL2/SDL_JoystickAttachVirtualEx) describes the virtual input mechanism used by the port.
5. **OpenMW engineering convention:** [CONTRIBUTING.md](https://github.com/OpenMW/openmw/blob/master/CONTRIBUTING.md). Keep changes small, separate from gameplay changes, and prove regression avoidance in the implementation/PR.
6. **Actual port source:** [`ios/openmw_ios_touch_controls.mm`](https://github.com/arjunyerevan95-dot/OpenMWiOS/blob/457ab881442302a9bd59435c1878ed4e72f6e52b/ios/openmw_ios_touch_controls.mm), [`ios/openmw_ios_touch_model.hpp`](https://github.com/arjunyerevan95-dot/OpenMWiOS/blob/457ab881442302a9bd59435c1878ed4e72f6e52b/ios/openmw_ios_touch_model.hpp), and [`validation/test_ios_touch_controls.py`](https://github.com/arjunyerevan95-dot/OpenMWiOS/blob/457ab881442302a9bd59435c1878ed4e72f6e52b/validation/test_ios_touch_controls.py).

These are published **expert references**, not proof that any specific patch works in this experimental port.

## Source facts verified in Build 67

- `OpenMWTouchOverlay` is a UIKit `UIView` implemented in Objective-C++. It owns touch layout, pressed-state tracking, a `CADisplayLink`, and a virtual SDL joystick/controller.
- In `ensureVirtualController`, the code calls `SDL_JoystickAttachVirtualEx` to install **its own** `OpenMW iOS Touch Controller`. This **must not** be mistaken for the Xbox hardware.
- `updateInputMode:` currently computes `_inputReady` and `_gameplayMode`, then sets `self.hidden = !_inputReady`. It returns early if those two values are unchanged. Physical-controller connection is not an input to its current visibility decision.
- In `loadProfile` / the editor, idle opacity is clamped to **0.05–0.85**, explaining why opacity cannot remove controls entirely.
- The editor's current controls are opacity -, opacity +, done, reset and cancel. The profile persists via `NSUserDefaults`.
- Existing test `validation/test_ios_touch_controls.py` checks touch editor persistence, opacity, controller behaviour, and other invariants. We should extend its coverage rather than simply add UI code without tests.

## Architecture decision to validate before implementation

**Desired scope:** Only change visibility and/or touch-interaction handling in the iOS overlay; leave engine gameplay, save format, controller button mappings and renderer untouched.

**Spike A — identify a real physical controller:** Prototype a read-only diagnostic check of connected gamepads. Compare SDL enumeration (e.g. game-controller status and `SDL_JoystickIsVirtual(index)`) with Apple's `GCController` connection notifications on real iOS hardware. Do **not** use `SDL_NumJoysticks() > 0` alone or `GCController.controllers.count > 0` without checking virtual devices. Confirm whether the SDL virtual joystick appears separately from Apple's `GCController` registry and whether both accurately follow an Xbox controller's Bluetooth state.

**Spike B — decide one authoritative visibility state:** Evaluate:
- current SDL input/video readiness;
- gameplay vs menus and editor;
- user setting (automatic-hide enabled vs disabled);
- connection state of a **physical** supported gamepad;
- a guaranteed return path to visible touch UI.

The controller presence check needs to handle *hot-plug changes* even when `_inputReady` and `_gameplayMode` are unchanged; the existing early return cannot be copied unchanged.

**Spike C — transition lifecycle:** On switching to controller-only mode, safely release any held virtual touch inputs, then hide the overlay's visuals/touch interception. On disconnect, restore the overlay (including normal pause/editor access), request redraw, and re-evaluate after app foreground/background transitions. All UIKit view updates must happen on the main thread. Missing or ambiguous device status should fail safe to visible controls.

**Implementation order:** First implement **automatic visibility on physical connect/disconnect** (one small feature); only then add an optional manually controlled setting and persistence in a second small reviewable change. The first phase should not allow a persistent no-controller mode that traps the player without touch input.

## Test matrix / acceptance gates

| Scenario | Expected behaviour |
|---|---|
| App launches without hardware gamepad | Touch controls visible and usable |
| App launches with Xbox gamepad connected | Overlay hidden when auto-hide is enabled; controller gameplay works |
| Only SDL virtual joystick exists | No false physical-controller detection |
| Xbox connects while playing | Overlay disappears; no stuck virtual buttons/axes |
| Xbox disconnects while playing | Touch overlay returns automatically without restarting |
| Connect / disconnect during menu, edit mode or background | Menus remain usable, visibility recovers correctly |
| Xbox reconnects | Overlay hides again; existing Xbox bindings unaffected |
| Disabled auto-hide preference (later phase) | Touch controls remain visible even with controller |
| No gamepad, controller mapping error or uncertain detection | Touch controls visible (safe fallback) |

Automated tests should verify the state-decision logic and that the UIKit adapter calls it. Static assertions are not enough: the iPhone tester must check controller pairing, real disconnection and game menu behaviour.

## What we must **not** assume

- That Apple's `GCVirtualController` example can be pasted into this port: Build 67 draws its own UIKit overlay and produces an **SDL virtual joystick**, not Apple's `GCVirtualController`.
- That automatically hiding the entire `UIView` always leaves a way to reopen its editor; design and verify a recovery path.
- That a passing macOS CI build proves physical iPhone behaviour.
- That controller detection at launch is sufficient: hot-plug, sleep/resume, and disconnect are important.

## Status and next step

No code has been written for Feature 001 yet. After [Milestone 0](https://github.com/SonicGrowth/OpenMW_iOS_Custom/issues/1) passes, implement Spike A and its diagnostic tests as a narrowly scoped feature branch. Capture on-device evidence before choosing the final detection source.
