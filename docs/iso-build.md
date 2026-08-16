# Building the Grapefruit OS ISO

This document describes how the official Grapefruit OS live ISO is produced. The goal is a bootable image that ships a Linux kernel configured according to the priorities in [kernel-features.md](kernel-features.md): strong isolation (namespaces, cgroups v2, seccomp, Landlock), modern I/O (io_uring), eBPF, security hardening, and good hardware support.

## High-Level Approach

Grapefruit OS ISOs are currently built using a **Debian/Ubuntu live-build style pipeline** (or the Cubic GUI frontend on Ubuntu hosts). This gives us:

- A reliable, reproducible way to produce hybrid BIOS/UEFI ISOs
- Easy inclusion of a custom kernel package
- Ability to pre-install packages, set defaults, and run late-commands for hardening
- Compatibility with the one-command installer and the live environment described in the main README

Future versions may move to a more from-scratch or declarative builder, but the live-build approach gets us to a usable ISO quickly while we refine the kernel and userland.

## Prerequisites on the Build Host

- Ubuntu 24.04 or 25.04 (recommended) or Debian equivalent
- `live-build`, `debootstrap`, `squashfs-tools`, `xorriso`, `isolinux` / `grub-efi` packages
- Sufficient disk space (at least 30–40 GB free recommended)
- Root privileges for the build

Optional but useful:
- Cubic (for a more visual, iterative workflow)
- A powerful machine (the squashfs and ISO generation steps are I/O and CPU heavy)

## Kernel Configuration

The ISO includes a kernel built (or selected) with a configuration fragment that enables the features discussed in the kernel documentation:

- Full cgroups v2 + controllers
- All major namespaces
- seccomp, Landlock, and related LSM hooks
- io_uring
- eBPF + BTF
- IOMMU support
- Modern scheduler options
- Hardening (KASLR, etc.) where practical

See `configs/` (once populated) for the exact fragment applied on top of a upstream or distribution kernel config.

## Build Steps (Conceptual)

1. **Prepare the build environment**
   ```bash
   sudo apt update
   sudo apt install live-build debootstrap squashfs-tools xorriso isolinux grub-efi-amd64-bin
   ```

2. **Create a build directory and configuration**
   ```bash
   mkdir -p ~/grapefruit-iso && cd ~/grapefruit-iso
   lb config -d noble --architectures amd64 --binary-images iso-hybrid \
     --bootappend-live "boot=live components quiet splash" \
     --debian-installer live
   ```

3. **Inject Grapefruit-specific packages, kernel, and configuration**
   - Place custom kernel `.deb` packages (or point to a repository) into `config/packages.chroot`
   - Add package lists for the live and installed system
   - Use `config/hooks/` and `config/includes.chroot/` to install Grapefruit branding, default configs, seccomp profiles, and sysctl hardening

4. **Apply kernel command-line and bootloader settings** that match our isolation and performance goals.

5. **Build**
   ```bash
   sudo lb build
   ```

6. **Result**
   - `live-image-amd64.hybrid.iso` (or similarly named) — this is the Grapefruit OS ISO
   - Generate SHA256 and optionally GPG-sign it for the Releases page

## Scripts in This Repository

- `scripts/build-iso.sh` — high-level wrapper that documents and (eventually) automates the above
- Future: more declarative configuration under `iso/` or `live-build/`

## Design Notes Related to Kernel Features

- The live environment itself runs under the same hardened kernel configuration so that testing isolation features is realistic.
- Default sysctl, seccomp, and Landlock policies are applied early so that even the live session demonstrates the sovereignty-oriented defaults.
- The installer (when present) preserves the kernel and the isolation-related packages into the target system.

## Current Status

The repository currently contains the design, documentation, and scaffolding. Concrete package lists, the exact kernel config fragment, and a fully automated `build-iso.sh` are the next implementation targets. Once those land, tagged releases will include downloadable `.iso` files.

---

*This build process exists to turn the kernel feature decisions into a tangible, bootable system as quickly as possible while keeping the long-term architecture options open.*
