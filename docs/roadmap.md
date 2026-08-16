# Grapefruit OS Roadmap

This roadmap reflects the current pragmatic direction: a hardened, isolation-first Linux-based system that can later evolve toward stronger kernel architectures if desired.

## Phase 0 — Foundation (Current)

- [x] Repository structure and core documentation
- [x] Kernel feature philosophy and recommended config fragment
- [x] ISO build design and scaffolding
- [x] Initial package lists and live-build configuration layout
- [x] Default sysctl, seccomp, and Landlock policy sketches
- [x] Architecture Decision Record for the Linux foundation choice
- [ ] First bootable hybrid ISO (manual or semi-automated build)
- [ ] Basic branding and live session defaults

## Phase 1 — Usable Live System & Installer (Next)

- Fully automated `scripts/build-iso.sh` that produces a signed, checksummed hybrid ISO
- Working live environment with the Grapefruit kernel configuration active
- Calamares or a simple text/graphical installer that preserves isolation defaults
- One-command `install.sh` for existing Linux systems (or clear documentation why ISO is preferred)
- Baseline desktop or minimal window-manager option (still undecided — sway/labwc vs full DE)
- Persistent package repository or clear instructions for updates

## Phase 2 — Hardening & Isolation Polish

- Refined Landlock + seccomp profiles for common workloads
- Default cgroup v2 hierarchy and resource policies for multi-tenant / multi-agent use
- AppArmor or SELinux profiles (optional, documented)
- Secure boot / measured boot exploration
- First-class support for rootless containers and sandboxed agents
- Documentation and examples for running high-isolation workloads

## Phase 3 — Developer & Power-User Experience

- Clean development container / toolbox story
- Easy custom kernel building using the Grapefruit fragment
- Observability defaults (eBPF-friendly, good tracing story)
- Optional real-time or low-latency configuration variants
- Reproducible builds and supply-chain considerations

## Phase 4 — Strategic Options (Longer Term)

- Evaluate whether critical services should move toward a smaller microkernel or hybrid core while keeping the same userland isolation interfaces
- Confidential computing (TDX/SEV) enablement where hardware allows
- Specialized “appliance” images (kiosk, agent-runtime, etc.)
- Formal methods or stronger assurance on selected components if the project grows in that direction

## Guiding Principles for All Phases

1. Strong, cheap isolation comes first.
2. Predictable performance under mixed workloads matters.
3. Keep the trusted computing base as understandable as practical.
4. Prefer mechanisms that leave future architectural options open.

---

*This roadmap is a living document. Major changes in direction will be recorded as new Architecture Decision Records.*
