# Feature 001 — Controller-only mode

**Status:** Planned; no implementation or build yet.

## User problem
When playing Morrowind on iPhone using an Xbox controller, the virtual touchscreen buttons remain visible and clutter the display. Manual opacity reduction or stacking buttons does not truly hide them.

## Proposed behaviour
- Detect when a usable physical game controller is connected.
- Offer a setting to automatically hide virtual game controls while the physical controller is active.
- Restore touchscreen controls on disconnection or controller-input failure.
- Provide an accessible manual show/hide override.
- Persist chosen preference across app restarts.
- Do **not** hide the core Morrowind HUD, inventory, map or native iOS system UI.
- Do not change controller bindings, spell cycling, menu navigation or touch responsiveness when the overlay is enabled.

## Safety/UX cases
- Starting without a controller.
- Controller connects mid-session.
- Controller disconnects while game is active, backgrounded, or in a menu.
- Bluetooth disconnects unexpectedly: recover touch controls without restarting.
- Physical controller input stops: ensure a reliable touch recovery path.
- Test with iPhone 15 Pro landscape mode and `[GUI] controller menus = true`.

## Definition of done
- Recorded functional design and code review.
- Patch applies cleanly to pinned Build 67.
- Relevant automated checks and an unsigned beta IPA build succeed.
- iPhone tester confirms hidden/visible modes, reconnect behaviour and menu operation.
- No impact on stable app data; separate bundle identifier.
