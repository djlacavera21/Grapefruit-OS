# Building the Grapefruit OS ISO

This document describes how the official Grapefruit OS live ISO is produced. The resulting image ships a Linux kernel (and userland policies) aligned with the priorities in [kernel-features.md](kernel-features.md).

## High-Level Approach

We use a **Debian/Ubuntu live-build** style pipeline. The repository contains:

- Package lists under `iso/config/package-lists/`
- Default sysctl policy and isolation documentation that are copied into the image
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

The script creates a build directory (default `~/grapefruit-iso-build`), runs `lb config`, injects Grapefruit package lists and policies, and can invoke `lb build`.

## What Gets Injected

- `iso/config/package-lists/grapefruit.list.chroot` — core system packages
- `iso/config/package-lists/desktop.list.chroot` — optional graphical packages
- `configs/sysctl.d/99-grapefruit.conf` → `/etc/sysctl.d/` inside the image
- Kernel fragment and seccomp/Landlock documentation under `/usr/share/grapefruit/` and `/usr/share/doc/grapefruit/`

## Kernel Configuration

The stock distribution kernel already provides the majority of features we care about (cgroups v2, namespaces, seccomp, Landlock, io_uring, eBPF, etc.). For a fully custom kernel, merge `configs/grapefruit-kernel.fragment` on top of a base config and rebuild before generating the ISO.

## Output

A successful `lb build` produces a hybrid BIOS/UEFI ISO in the build directory. Generate checksums with:

```bash
sha256sum *.iso > SHA256SUMS
```

## Design Notes

- The live environment runs under the same isolation-oriented defaults we want on the installed system.
- Package selection deliberately stays relatively lean; desktop components are optional.
- The build script is written to be inspectable — every major step can be run or modified manually.

## Current Limitations

- The first fully automated, published ISO has not yet been released.
- Custom kernel packaging (i.e. building a `.deb` from the Grapefruit fragment) is still a manual/advanced step.
- Installer experience (Calamares or otherwise) is future work.

See the [roadmap](roadmap.md) for the planned sequence of improvements.
