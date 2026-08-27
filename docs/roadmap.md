# Grapefruit OS Roadmap

This roadmap reflects the current pragmatic direction: a hardened, isolation-first Linux-based system that can later evolve toward stronger kernel architectures if desired.

## Phase 0 — Foundation (Current)

- [x] Repository structure and core documentation
- [x] Kernel feature philosophy and recommended config fragment
- [x] ISO build design and concrete automation script
- [x] Real package lists (core, optional desktop, security/isolation userland)
- [x] Default sysctl hardening
- [x] Seccomp guidance + concrete profiles (`agent-base.json`, `untrusted-code.json`)
- [x] Landlock guidance
- [x] nftables default-deny-incoming policy + NetworkManager defaults
- [x] sshd hardening fragment (server remains disabled by default)
- [x] Live-build hooks for defaults, branding, and network policy
- [x] Calamares settings, branding, welcome, and users modules
- [x] First-boot guide and verification checklist
- [x] Plymouth / splash direction recorded (theme not yet implemented)
- [x] Architecture Decision Records (kernel foundation, network defaults)
- [x] MIT license and contributor guidelines
- [ ] First bootable hybrid ISO (run `scripts/build-iso.sh --auto` on a real host)
- [ ] Polished live session experience

## Phase 1 — Usable Live System & Installer (Next)

- Fully tested `scripts/build-iso.sh --auto` producing a signed, checksummed hybrid ISO
- Working live environment with Grapefruit policies active
- Calamares installer that preserves isolation defaults and branding
- Decision on default session (minimal Wayland compositor vs fuller desktop)
- Persistent update story (repository or image-based)

## Phase 2 — Hardening & Isolation Polish

- Expanded and tested Landlock + seccomp profiles for common workloads
- Default cgroup v2 hierarchy and resource policies useful for multi-agent systems
- Optional AppArmor/SELinux profiles with clear documentation
- Secure boot / measured boot exploration
- First-class examples for rootless containers and sandboxed agents

## Phase 3 — Developer & Power-User Experience

- Clean development container / toolbox story
- Easy custom kernel building using the Grapefruit fragment
- Observability defaults (eBPF-friendly tooling)
- Optional real-time or low-latency configuration variants
- Reproducible builds and basic supply-chain considerations

## Phase 4 — Strategic Options (Longer Term)

- Evaluate moving selected services toward a smaller microkernel or hybrid core while keeping the same userland isolation interfaces
- Confidential computing (TDX/SEV) enablement where hardware allows
- Specialized “appliance” images (kiosk, agent-runtime, etc.)
- Stronger assurance or formal methods on selected components if the project grows in that direction

## Guiding Principles for All Phases

1. Strong, cheap isolation comes first.
2. Predictable performance under mixed workloads matters.
3. Keep the trusted computing base as understandable as practical.
4. Prefer mechanisms that leave future architectural options open.
