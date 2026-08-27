#!/usr/bin/env bash
# Grapefruit OS — ISO build script
#
# Produces (or prepares the configuration for) a hybrid BIOS/UEFI live ISO
# that ships a Linux kernel aligned with docs/kernel-features.md and
# configs/grapefruit-kernel.fragment.
#
# Usage:
#   ./scripts/build-iso.sh              # prepare + show next commands
#   ./scripts/build-iso.sh --auto       # attempt a full live-build run
#   ./scripts/build-iso.sh --clean      # remove previous build artifacts
#
# This script is intended to be run on an Ubuntu 24.04/25.04 or Debian
# host with live-build installed. It is deliberately explicit so that
# each step can be inspected or run manually.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-$HOME/grapefruit-iso-build}"
AUTO=0
CLEAN=0

for arg in "$@"; do
  case "$arg" in
    --auto)  AUTO=1 ;;
    --clean) CLEAN=1 ;;
    -h|--help)
      echo "Usage: $0 [--auto] [--clean]"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

echo "Grapefruit OS ISO Builder"
echo "========================="
echo "Repository : $REPO_ROOT"
echo "Build dir  : $BUILD_DIR"
echo

if [[ "$CLEAN" -eq 1 ]]; then
  echo "Cleaning previous build directory..."
  rm -rf "$BUILD_DIR"
  echo "Done."
  exit 0
fi

# ------------------------------------------------------------
# 1. Dependency check
# ------------------------------------------------------------
echo "==> Checking build host dependencies"

REQUIRED=(lb debootstrap squashfs-tools xorriso)
MISSING=()
for cmd in "${REQUIRED[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING+=("$cmd")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Missing required tools: ${MISSING[*]}"
  echo "On Ubuntu/Debian install with:"
  echo "  sudo apt update"
  echo "  sudo apt install live-build debootstrap squashfs-tools xorriso isolinux grub-efi-amd64-bin"
  if [[ "$AUTO" -eq 1 ]]; then
    exit 1
  fi
else
  echo "All basic tools present."
fi

# ------------------------------------------------------------
# 2. Prepare build directory
# ------------------------------------------------------------
echo
echo "==> Preparing live-build directory at $BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [[ ! -d config ]]; then
  echo "Running initial 'lb config'..."
  lb config \
    -d noble \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --bootappend-live "boot=live components quiet splash" \
    --debian-installer none \
    --archive-areas "main restricted universe multiverse" \
    --apt-indices false \
    --memtest none
fi

# ------------------------------------------------------------
# 3. Inject Grapefruit package lists, hooks, policies, and branding
# ------------------------------------------------------------
echo
echo "==> Installing Grapefruit package lists, hooks, and policies"

mkdir -p config/package-lists
cp -v "$REPO_ROOT"/iso/config/package-lists/*.list.chroot config/package-lists/ 2>/dev/null || true

mkdir -p config/hooks/live
cp -v "$REPO_ROOT"/iso/config/hooks/live/*.chroot config/hooks/live/ 2>/dev/null || true
chmod +x config/hooks/live/*.chroot 2>/dev/null || true

mkdir -p config/includes.chroot/etc/sysctl.d
cp -v "$REPO_ROOT"/configs/sysctl.d/99-grapefruit.conf config/includes.chroot/etc/sysctl.d/ 2>/dev/null || true

mkdir -p config/includes.chroot/usr/share/doc/grapefruit
mkdir -p config/includes.chroot/usr/share/grapefruit/seccomp
mkdir -p config/includes.chroot/usr/share/grapefruit/nftables
cp -v "$REPO_ROOT"/configs/seccomp/README.md config/includes.chroot/usr/share/doc/grapefruit/seccomp-README.md 2>/dev/null || true
cp -v "$REPO_ROOT"/configs/seccomp/*.json config/includes.chroot/usr/share/grapefruit/seccomp/ 2>/dev/null || true
cp -v "$REPO_ROOT"/configs/landlock/README.md config/includes.chroot/usr/share/doc/grapefruit/landlock-README.md 2>/dev/null || true
cp -v "$REPO_ROOT"/docs/first-boot.md config/includes.chroot/usr/share/doc/grapefruit/first-boot.md 2>/dev/null || true
cp -v "$REPO_ROOT"/iso/config/includes.chroot/usr/share/doc/grapefruit/FIRST-BOOT.txt \
      config/includes.chroot/usr/share/doc/grapefruit/ 2>/dev/null || true

mkdir -p config/includes.chroot/usr/share/grapefruit
cp -v "$REPO_ROOT"/configs/grapefruit-kernel.fragment config/includes.chroot/usr/share/grapefruit/ 2>/dev/null || true
cp -v "$REPO_ROOT"/configs/nftables/grapefruit.nft config/includes.chroot/usr/share/grapefruit/nftables/ 2>/dev/null || true
cp -v "$REPO_ROOT"/configs/nftables/grapefruit.nft config/includes.chroot/etc/nftables.conf 2>/dev/null || true

mkdir -p config/includes.chroot/etc/ssh/sshd_config.d
mkdir -p config/includes.chroot/etc/NetworkManager/conf.d
cp -v "$REPO_ROOT"/configs/ssh/sshd_config.d/10-grapefruit.conf \
      config/includes.chroot/etc/ssh/sshd_config.d/ 2>/dev/null || true
cp -v "$REPO_ROOT"/configs/network/NetworkManager.conf.d/00-grapefruit.conf \
      config/includes.chroot/etc/NetworkManager/conf.d/ 2>/dev/null || true

mkdir -p config/includes.chroot/etc/calamares/branding/grapefruit
mkdir -p config/includes.chroot/etc/calamares/modules
cp -v "$REPO_ROOT"/iso/config/includes.chroot/etc/calamares/settings.conf config/includes.chroot/etc/calamares/ 2>/dev/null || true
cp -v "$REPO_ROOT"/iso/config/includes.chroot/etc/calamares/branding/grapefruit/branding.desc \
      config/includes.chroot/etc/calamares/branding/grapefruit/ 2>/dev/null || true
cp -v "$REPO_ROOT"/iso/config/includes.chroot/etc/calamares/modules/*.conf \
      config/includes.chroot/etc/calamares/modules/ 2>/dev/null || true

echo "Configuration, hooks, policies, and branding files copied."

# ------------------------------------------------------------
# 4. Summary of kernel priorities that the final image should satisfy
# ------------------------------------------------------------
echo
echo "==> Kernel feature checklist (must be true of the running kernel in the ISO)"
echo "    [ ] cgroups v2 + controllers"
echo "    [ ] namespaces (pid, mount, user, net, uts, ipc, cgroup, ...)"
echo "    [ ] seccomp + Landlock"
echo "    [ ] io_uring"
echo "    [ ] eBPF + BTF"
echo "    [ ] IOMMU support"
echo "    [ ] Modern scheduler options"
echo
echo "The stock distribution kernel already provides most of these."
echo "For a fully custom kernel, merge configs/grapefruit-kernel.fragment"
echo "and rebuild before generating the ISO."

# ------------------------------------------------------------
# 5. Build or instruct
# ------------------------------------------------------------
echo
if [[ "$AUTO" -eq 1 ]]; then
  echo "==> Starting live-build (this will take a long time and requires root)"
  echo "    Working directory: $BUILD_DIR"
  sudo lb build
  echo
  echo "Build finished. Look for a *.iso in $BUILD_DIR"
  echo "Generate checksums with:"
  echo "  sha256sum *.iso > SHA256SUMS"
else
  echo "==> Dry run complete. To build for real, re-run with --auto:"
  echo "    $0 --auto"
  echo
  echo "Or enter the build directory and run manually:"
  echo "    cd $BUILD_DIR"
  echo "    sudo lb build"
  echo
  echo "See docs/iso-build.md and docs/first-boot.md."
fi
