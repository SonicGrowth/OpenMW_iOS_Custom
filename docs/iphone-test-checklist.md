# iPhone Beta Acceptance Checklist

**Preflight**
- [ ] Original Build 67 still launches and has untouched game files/saves.
- [ ] Settings and saves backed up to Files/iCloud.
- [ ] Beta IPA identifier differs from stable; display name is **OpenMW Beta**.
- [ ] SideStore signing and free-account app limits checked.

**Baseline**
- [ ] Beta installs alongside stable without replacing it.
- [ ] Beta creates separate Files storage.
- [ ] User copies only test game files and a disposable test save.
- [ ] Morrowind launches, displays proper menus and saves/loads.

**Controller**
- [ ] Xbox controller connected before game start: movement, camera, A/B/X/Y, triggers, D-pad.
- [ ] Controller menus work with `controller menus = true`.
- [ ] Spells and enchanted-item selection works; no binding regressions.
- [ ] Connect/disconnect controller during gameplay; touchscreen recovery verified.

**Feature 001**
- [ ] Overlay auto-hides when controller connects.
- [ ] Overlay returns when controller disconnects.
- [ ] Manual show/hide works, with an always-accessible recovery route.
- [ ] Preference survives restart.
- [ ] No crashes, HUD loss or performance regression.

Include beta build/run ID, timestamp, iOS version, app version, screenshots and any crash logs with final result.
