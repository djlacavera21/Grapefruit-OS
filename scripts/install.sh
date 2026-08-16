#!/usr/bin/env bash
# Grapefruit OS — One-command installer (scaffolding)
#
# Intended usage (once fully implemented):
#   curl -fsSL https://raw.githubusercontent.com/djlacavera21/Grapefruit-OS/main/scripts/install.sh | bash
#
# This script will eventually:
#   - Detect architecture and existing OS
#   - Offer to install into a new partition / VM / container-friendly root
#   - Pull the Grapefruit package set and a kernel matching docs/kernel-features.md
#   - Configure bootloader, networking, and baseline hardening
#   - Preserve the isolation-first defaults (cgroups v2, namespaces, seccomp, etc.)
#
# Current status: intentional scaffold so the README links remain valid
# while the real installer is developed alongside the ISO.

set -euo pipefail

echo "Grapefruit OS Installer"
echo "======================="
echo
echo "This is currently a scaffold."
echo "A full installer will be implemented in parallel with the ISO build pipeline."
echo
echo "Design goals once complete:"
echo "  - Safe defaults that match the kernel feature priorities"
echo "  - Clear warnings before touching disks"
echo "  - Support for both bare-metal and virtualized targets"
echo "  - Preservation of the hardened, isolation-oriented configuration"
echo
echo "For now, prefer the Live ISO method described in the README."
echo
exit 0
