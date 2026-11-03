# Downstream patch series

This directory will contain **only approved modifications** to the pinned upstream OpenMW iOS Build 67 source.

Use names such as `0001-ios-hide-touch-overlay-with-controller.patch`. Each patch should:
- Apply cleanly to commit `457ab881442302a9bd59435c1878ed4e72f6e52b`.
- Explain the affected file(s), rationale, risks and relevant issue/PR.
- Have a related test or explicit manual acceptance check.
- Avoid unrelated formatting changes.

The bootstrap script applies `custom/patches/*.patch` in lexicographic order, after verifying the upstream commit. There are **no feature patches yet**.
