# Grapefruit OS

**Grapefruit OS** — A modern, modular Linux-based operating system focused on sovereignty, strong isolation, predictable performance, and clean design.

Grapefruit OS currently follows a pragmatic foundation: a carefully configured and hardened **Linux kernel** that enables the isolation, scheduling, I/O, and security features we consider essential. This lets us ship a usable system and ISO quickly while keeping a clear path open for more radical kernel designs later.

## Design Priorities (Kernel Level)

1. **Strong, cheap isolation** — namespaces, cgroups v2, seccomp, Landlock
2. **Predictable performance** under mixed and multi-agent workloads
3. **A manageable trusted computing base** even while using Linux
4. **Clean hardware enablement** and modern I/O (io_uring, eBPF, IOMMU)

Full discussion: **[docs/kernel-features.md](docs/kernel-features.md)**  
Architecture decision: **[docs/adr/0001-linux-kernel-foundation.md](docs/adr/0001-linux-kernel-foundation.md)**

## Current Status

- [x] Kernel feature philosophy and recommended config fragment
- [x] Concrete live-build package lists + hooks
- [x] Default sysctl hardening
- [x] Concrete seccomp profiles (`agent-base`, `untrusted-code`) + Landlock guidance
- [x] Calamares settings and branding scaffold
- [x] Expanded, usable `scripts/build-iso.sh` that injects all of the above
- [x] Roadmap and first Architecture Decision Record
- [x] Grapefruit OS v1.0 Revision A implementation review and engineering expansion backlog
- [ ] First published bootable hybrid ISO
- [ ] Complete installer experience
- [ ] Implementation-ready Executive, agent protocol, memory, semantic filesystem, plugin, and enterprise contracts

See **[docs/roadmap.md](docs/roadmap.md)** for the full phased plan and **[Revision A Implementation Review](docs/grapefruit-os-v1.0-revision-a-implementation-review.md)** for the specification-to-implementation backlog.

## Building the ISO

```bash
git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS
./scripts/build-iso.sh          # prepares configuration, shows next steps
./scripts/build-iso.sh --auto   # attempts a full live-build (requires root + dependencies)
```

The script checks dependencies, creates a live-build tree, injects package lists, hooks, sysctl policy, seccomp profiles, Landlock docs, kernel fragment, and Calamares branding, then can run `lb build`.

Details: **[docs/iso-build.md](docs/iso-build.md)**

## Installation (once an ISO exists)

1. Download the ISO from Releases and verify the SHA256 checksum.
2. Write it to USB (`dd`, Rufus, balenaEtcher, etc.).
3. Boot and install (Calamares branding is already scaffolded).

## Repository Layout

```
Grapefruit-OS/
├── README.md
├── docs/
│   ├── grapefruit-os-v1.0-revision-a-implementation-review.md
│   ├── kernel-features.md
│   ├── iso-build.md
│   ├── roadmap.md
│   └── adr/0001-linux-kernel-foundation.md
├── configs/
│   ├── grapefruit-kernel.fragment
│   ├── sysctl.d/99-grapefruit.conf
│   ├── seccomp/
│   │   ├── README.md
│   │   ├── agent-base.json
│   │   └── untrusted-code.json
│   └── landlock/README.md
├── iso/
│   └── config/
│       ├── package-lists/
│       ├── hooks/live/
│       └── includes.chroot/etc/calamares/...
└── scripts/
    ├── build-iso.sh
    └── install.sh
```

## Kernel & Policy Highlights

- **Kernel fragment** enables cgroups v2, namespaces, seccomp, Landlock, io_uring, eBPF, IOMMU, and modern scheduler options.
- **sysctl** policy hardens common attack surfaces.
- **seccomp** profiles provide ready-to-use baselines for agents and untrusted code.
- **Landlock** guidance supports unprivileged path-based sandboxing.
- **Calamares** branding and settings are pre-seeded for a future graphical installer.

## Technical Specification Direction

The Grapefruit OS v1.0 Revision A architecture defines the long-term AI-first automation platform: GPT Executive planning and verification, supervised agents, typed communication, Linux-enforced privilege, semantic storage and memory, model routing, SDKs, plugins, enterprise deployment, Zero-Trust controls, conformance testing, and the roadmap through Version 5.0.

The **[Revision A Implementation Review](docs/grapefruit-os-v1.0-revision-a-implementation-review.md)** identifies the concrete work required to turn that architecture into implementation-ready subsystem contracts. P0 work centers on the Executive scheduler, agent runtime/protocol, and Linux enforcement boundary; P1 adds semantic storage, memory, model routing, desktop workflows, plugins/SDKs, and Zero-Trust controls; P2 completes enterprise/federated deployment and reproducible conformance/performance engineering.

## Long-Term Direction

Short term we ship a solid, hardened Linux-based system.  
Long term the same isolation primitives give us a clean migration path if we ever move critical components onto a smaller microkernel or hybrid core. That option is deliberately kept open (see the ADR).

## Documentation Index

| Document | Purpose |
|----------|---------|
| [Kernel Features](docs/kernel-features.md) | Design rationale for the kernel |
| [ADR 0001](docs/adr/0001-linux-kernel-foundation.md) | Why we start with Linux |
| [ISO Build](docs/iso-build.md) | How the bootable image is produced |
| [Roadmap](docs/roadmap.md) | Phased plan |
| [Revision A Implementation Review](docs/grapefruit-os-v1.0-revision-a-implementation-review.md) | Implementation gaps, priorities, acceptance targets, and recommended engineering sequence |

## License

To be determined.

---

*Grapefruit OS turns deliberate decisions about isolation, performance, and sovereignty into a concrete, bootable system.*
