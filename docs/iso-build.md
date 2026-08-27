# Building the Grapefruit OS ISO

This document describes how the official Grapefruit OS live ISO is produced. The resulting image ships a Linux kernel (and userland policies) aligned with the priorities in [kernel-features.md](kernel-features.md).

## High-Level Approach

We use a **Debian/Ubuntu live-build** style pipeline. The repository contains:

- Package lists under `iso/config/package-lists/` (core, desktop, security)
- Hooks under `iso/config/hooks/live/`
- Default sysctl, nftables, NetworkManager, sshd, seccomp, and Calamares files
- A concrete automation script: `scripts/build-iso.sh`

## Quick Start

On an Ubuntu 24.04 / 25.04 (or similar) host:

```bash
sudo apt update
sudo apt install live-build debootstrap squashfs-tools xorriso isolinux grub-efi-amd64-bin

git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS

./scripts/build-iso.sh          # prepares the live-build tree and shows next steps
./scripts/build-iso.sh --auto   # runs the full build (requires root, takes time)
```

## What Gets Injected

- Package lists from `iso/config/package-lists/`
- Live hooks (defaults, network/firewall enablement)
- `configs/sysctl.d/99-grapefruit.conf` → `/etc/sysctl.d/`
- `configs/nftables/grapefruit.nft` → `/etc/nftables.conf`
- sshd and NetworkManager drop-in configs
- seccomp profiles under `/usr/share/grapefruit/seccomp/`
- first-boot documentation under `/usr/share/doc/grapefruit/`
- Calamares settings, branding, welcome, and users modules

## After the Image Boots

Follow [first-boot.md](first-boot.md) to verify isolation features and understand the network defaults.

## Current Limitations

- The first fully automated, published ISO has not yet been released.
- Custom kernel packaging from the Grapefruit fragment is still an advanced/manual step.
- Plymouth theme is planned but not implemented (`docs/plymouth.md`).
