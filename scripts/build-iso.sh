#!/usr/bin/env bash
# Grapefruit OS — ISO build wrapper (scaffolding)
#
# This script documents and will eventually automate the production of a
# Grapefruit OS live ISO that ships a Linux kernel configured for the
# isolation, scheduling, I/O, and security features described in
# docs/kernel-features.md.
#
# Current status: scaffolding + clear next steps.
# Real automation will land once package lists and the kernel config
# fragment are finalized.

set -euo pipefail

echo "Grapefruit OS ISO Builder"
echo "========================="
echo
echo "This is currently a high-level scaffold."
echo "See docs/iso-build.md for the full process."
echo
echo "Planned responsibilities of this script:"
echo "  1. Verify build host dependencies (live-build, debootstrap, etc.)"
echo "  2. Prepare a clean live-build configuration directory"
echo "  3. Inject Grapefruit package lists, hooks, and includes"
echo "  4. Apply the curated kernel configuration fragment"
echo "  5. Run 'lb build' (or Cubic / alternative backend)"
echo "  6. Produce a hybrid BIOS/UEFI ISO + checksums"
echo
echo "Kernel priorities that must be present in the resulting image:"
echo "  - cgroups v2 + full controllers"
echo "  - All major namespaces"
echo "  - seccomp + Landlock"
echo "  - io_uring"
echo "  - eBPF + BTF"
echo "  - IOMMU support"
echo "  - Modern scheduler + NUMA awareness where applicable"
echo
echo "Next concrete steps for contributors:"
echo "  - Populate configs/ with a kernel config fragment"
echo "  - Create live-build package lists under iso/ or config/"
echo "  - Turn this script into a real, idempotent builder"
echo
echo "Exiting without building (scaffold only)."
exit 0
