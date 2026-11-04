# Developer's actual implementation: eDukeiOS, NOT OpenMW

**Verified 4 November 2026** from the developer's [release](https://github.com/arjunkl/eDukeiOS/releases/tag/touch-controls-preview-1) and [PR #10 diff](https://github.com/arjunkl/eDukeiOS/pull/10).

The Reddit reply pointed to **eDukeiOS (Duke Nukem 3D / Ion Fury)**, not Morrowind/OpenMW. The new IPA cannot run Morrowind, but its implementation is a useful expert reference.

- Release tag: `touch-controls-preview-1`; published 3 November 2026.
- Feature commit: `9b0b9fdd8a2c39c3b3e18b3253a43693bb408091`.
- Source: [`platform/Apple/iOS/EDuke32Controls.mm`](https://github.com/arjunkl/eDukeiOS/blob/9b0b9fdd8a2c39c3b3e18b3253a43693bb408091/platform/Apple/iOS/EDuke32Controls.mm).
- Developer notes: preview IPA verified as a package; physical iPhone/Xbox testing was still pending.

## Exact pattern used in eDukeiOS

The patch adds `_touchControlsDisabled`, persists it via `NSUserDefaults` with key `eDukeiOS.touchControls.disabled`, and offers a **Touch Controls On/Off** button in the touch editor. When disabled outside the editor, `drawRect:` skips painting the virtual buttons and `touchesBegan:` stops forwarding gameplay touches. Crucially, a **two-second long-press gesture anywhere on the screen** still opens the editor, enabling controls to be turned back on. This does not change the hardware controller input backend.

## Safe adaptation to pinned OpenMW Build 67

OpenMW's `ios/openmw_ios_touch_controls.mm` also uses a UIKit overlay but has its **own** Pause-long-press arbitration, a five-item toolbar, and an SDL virtual controller. Its code is not directly compatible with eDukeiOS.

1. Add a saved setting, default **On**, and a clear editor toggle.
2. When Off, stop drawing overlay controls and stop their normal game-touch handling; release any pressed virtual buttons or axes first.
3. Preserve a two-second long-press-**anywhere** recovery gesture, including when no physical gamepad is connected.
4. Test saved preferences, menus, screen orientation, Xbox controller bindings, and restoring touch after Bluetooth disconnect.
5. Extend `validation/test_ios_touch_controls.py` and test a separately signed iPhone beta before accepting changes.

**Recommended order:** Manual toggle and recovery gesture **first**. Optional automatic physical controller detection **later**, separately, using Apple's published controller lifecycle guidance and SDL2 virtual joystick filtering.

No OpenMW patch is implemented yet; this is an engineering reference.
