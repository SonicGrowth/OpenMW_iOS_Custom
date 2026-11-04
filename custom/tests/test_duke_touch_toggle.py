"""Source-level regression checks for Feature 001 (the initial Duke-style toggle).

These checks do not compile the UIKit Objective-C++ overlay. The real iOS build
and physical-device tests are separate acceptance gates.
"""
import pathlib
import re
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]
SOURCE = ROOT / "build" / "upstream-port" / "ios" / "openmw_ios_touch_controls.mm"
PATCH = ROOT / "custom" / "patches" / "0001-duke-style-hide-virtual-controls.patch"


class DukeStyleTouchToggleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not SOURCE.is_file():
            raise RuntimeError("Run scripts/prepare-port.sh before Feature 001 tests")
        cls.source = SOURCE.read_text(encoding="utf-8")

    def body(self, selector: str, next_selector: str) -> str:
        start = self.source.index(selector)
        end = self.source.index(next_selector, start + len(selector))
        return self.source[start:end]

    def test_patch_is_present_and_only_changes_ios_touch_overlay(self):
        patch = PATCH.read_text(encoding="utf-8")
        headers = re.findall(r"^diff --git (.*)$", patch, flags=re.M)
        self.assertEqual(headers, [
            "a/ios/openmw_ios_touch_controls.mm b/ios/openmw_ios_touch_controls.mm"
        ])
        self.assertIn("UILongPressGestureRecognizer", patch)
        self.assertIn("SHOW PAD", patch)

    def test_user_preference_is_saved_and_defaults_to_controls_visible(self):
        self.assertIn('TouchControlsDisabledKey = @"OpenMWIOSTouchControlsDisabledV1"', self.source)
        self.assertIn("boolForKey:TouchControlsDisabledKey", self.source)
        self.assertIn("setBool:_touchControlsDisabled forKey:TouchControlsDisabledKey", self.source)
        self.assertIn("_touchControlsDisabled = !_touchControlsDisabled", self.source)

    def test_touch_overlay_remains_hit_testable_when_gamepad_is_hidden(self):
        hit = self.body("- (BOOL)pointInside:", "- (void)rebuildLayout")
        self.assertIn("if (_editing || _touchControlsDisabled)", hit)
        self.assertIn("return YES;", hit)

    def test_drawing_and_touch_events_are_suppressed_without_hiding_editor(self):
        for first, last in (
            ("- (void)touchesBegan:", "- (void)touchesMoved:"),
            ("- (void)touchesMoved:", "- (void)finishTouches:"),
            ("- (void)finishTouches:", "- (void)touchesEnded:"),
            ("- (void)drawRect:", "@end"),
        ):
            self.assertRegex(
                self.body(first, last),
                r"if \(_touchControlsDisabled && !_editing\)\s+return;"
            )
        self.assertNotIn("self.hidden = _touchControlsDisabled", self.source)

    def test_recovery_is_non_cancelling_two_second_hold(self):
        self.assertIn("_recoveryHold.minimumPressDuration = 2.0", self.source)
        self.assertIn("_recoveryHold.allowableMovement = 32.f", self.source)
        self.assertIn("_recoveryHold.cancelsTouchesInView = NO", self.source)
        self.assertIn("[self addGestureRecognizer:_recoveryHold]", self.source)
        recovery = self.body("- (void)recoveryHoldActivated:", "- (void)diagnose:")
        self.assertIn("UIGestureRecognizerStateBegan", recovery)
        self.assertIn("_touchControlsDisabled && !_editing && _inputReady", recovery)
        self.assertIn("[self enterEditor]", recovery)
        self.assertIn("_recoveryHold.enabled = NO", self.body("- (void)enterEditor", "- (void)leaveEditorSaving"))
        self.assertIn("_recoveryHold.enabled = _touchControlsDisabled", self.body("- (void)leaveEditorSaving", "- (void)resetEditorLayout"))

    def test_toolbar_toggle_releases_virtual_inputs_before_hiding(self):
        actions = self.body("- (void)activateEditorToolbarItem:", "- (void)recoveryHoldActivated:")
        self.assertIn("case 5:", actions)
        self.assertIn("if (_touchControlsDisabled)\n                [self releaseAllInputs];", actions)
        self.assertIn('@"SHOW PAD"', self.source)
        self.assertIn('@"HIDE PAD"', self.source)
        self.assertIn("CGRectGetWidth(toolbar) / 6.f", self.source)
        self.assertIn("return MIN(5,", self.source)

    def test_existing_physical_controller_backend_untouched(self):
        self.assertIn("SDL_JoystickAttachVirtualEx", self.source)
        self.assertIn("SDL_JoystickSetVirtualAxis", self.source)
        self.assertIn("SDL_JoystickSetVirtualButton", self.source)
        self.assertIn("SDL_CONTROLLER_BUTTON_START", self.source)

    def test_first_preview_intentionally_does_not_passthrough_menu_taps(self):
        # This is explicitly Duke parity, not the user's final hybrid-touch UX.
        # Revisit in Feature 001 follow-up after direct iPhone testing.
        hit = self.body("- (BOOL)pointInside:", "- (void)rebuildLayout")
        self.assertIn("if (_editing || _touchControlsDisabled)", hit)
        began = self.body("- (void)touchesBegan:", "- (void)touchesMoved:")
        self.assertIn("if (_touchControlsDisabled && !_editing)", began)


if __name__ == "__main__":
    unittest.main()
