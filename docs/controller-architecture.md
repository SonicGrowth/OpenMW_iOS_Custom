# Build 67 touch-controller architecture (research notes)

Reference source: [upstream OpenMW iOS commit 457ab881](https://github.com/arjunyerevan95-dot/OpenMWiOS/blob/457ab881442302a9bd59435c1878ed4e72f6e52b/ios/openmw_ios_touch_controls.mm). These observations are source-inspection findings, **not** results from running a modified iPhone build.

## Key files
- `ios/openmw_ios_touch_controls.mm`: Objective-C++ UIKit overlay implementation, SDL virtual controller input bridge and editor, approximately 1,124 lines.
- `ios/openmw_ios_touch_model.hpp`: persisted touch profiles, layout and touch ownership model.
- `validation/test_ios_touch_controls.py`: existing static/behavioural validation around touch model and editor.
- `scripts/build-ios.sh`: iOS Xcode project generation; `PRODUCT_BUNDLE_IDENTIFIER` can be overridden.
- `.github/workflows/ios-fast.yml`: pinned iOS build and diagnostics workflow.

## Existing state model
- `OpenMWTouchOverlay : UIView` owns `_virtualController`, `_virtualJoystick`, `_inputReady`, `_gameplayMode`, `_editing` and `_profile`.
- `loadProfile` and `saveProfile` store a dictionary under `OpenMWIOSTouchProfileV1` via `NSUserDefaults`.
- Editor toolbar `activateEditorToolbarItem:` currently defines opacity decrease/increase, Done, Reset and Cancel. Opacity is clamped to **0.05–0.85**, explaining why it cannot become invisible in the current build.
- `updateInputMode:` determines input readiness using SDL video state, gameplay mode via cursor visibility, and sets `self.hidden = !_inputReady`. It currently returns early when both input and gameplay mode are unchanged.
- The screen overlay creates a **virtual SDL controller**, so a detection method for a **physical** controller must distinguish it from the overlay's own virtual joystick.

## Implementation implications
1. The manual show/hide action likely belongs in the touch editor's toolbar, plus persistent profile state or a separate preference.
2. Any automatic hide rule should reliably detect *physical* controller presence and respond to changes while gameplay mode remains constant; simply reusing the present early-return path might miss hot-plug events.
3. Hide must not trap the user without a recovery path after controller disconnect, crash, sleep or Bluetooth failure.
4. Avoid breaking the SDL virtual controller and preserve the existing `controller menus = true` game UI behaviour.
5. Update the corresponding tests; the source already contains test coverage for persistence and opacity limits.

## Expert references
- [OpenMW CONTRIBUTING.md](https://github.com/OpenMW/openmw/blob/f4bec41444214a7903bebd178389ca22ca13f646/CONTRIBUTING.md): prefer small scoped changes, discuss features, and keep game logic faithful.
- [WO40 experimental branch](https://github.com/arjunyerevan95-dot/OpenMWiOS/tree/codex/wo40-zink-touch): relevant design comparison but incompatible engine/platform stack.

**Next technical gate:** Successfully compile and run the unchanged beta before modifying the overlay.
