# Plymouth / Boot Splash (Placeholder)

Grapefruit OS does not yet ship a custom Plymouth theme. This file records the intended direction so branding work has a home.

## Intent

- Quiet, dark splash consistent with the Calamares branding colors (`#1a1a1a` background, `#f0a000` accent).
- Short product name: **Grapefruit**.
- No noisy boot text in the default graphical ISO; verbose mode remains available via a boot menu option.

## Implementation Notes (Future)

1. Add `plymouth` and `plymouth-themes` to the desktop or a dedicated branding package list.
2. Create `iso/config/includes.chroot/usr/share/plymouth/themes/grapefruit/`.
3. Set the default theme in a live-build hook:
   `update-alternatives` / `plymouth-set-default-theme grapefruit`.
4. Ensure `splash` is present on the live kernel command line (already passed by `scripts/build-iso.sh` via `--bootappend-live`).

Until that lands, the distribution default splash (or none) is acceptable.
