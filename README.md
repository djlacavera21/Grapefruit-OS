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
- [x] Concrete live-build package lists
- [x] Default sysctl hardening + seccomp/Landlock guidance
- [x] Expanded, usable `scripts/build-iso.sh`
- [x] Initial roadmap and first Architecture Decision Record
- [ ] First published bootable hybrid ISO
- [ ] Full graphical or minimal installer experience

See **[docs/roadmap.md](docs/roadmap.md)** for the full phased plan.

## Building the ISO

```bash
git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS
./scripts/build-iso.sh          # prepares configuration, shows next steps
./scripts/build-iso.sh --auto   # attempts a full live-build (requires root + dependencies)
```

The script:

- Checks for `live-build` and related tools
- Creates a build directory and runs `lb config`
- Injects the Grapefruit package lists and sysctl policy
- Copies kernel fragment and isolation documentation into the image
- Can run `lb build` when invoked with `--auto`

Details: **[docs/iso-build.md](docs/iso-build.md)**

## Installation (once an ISO exists)

1. Download the ISO from Releases and verify the SHA256 checksum.
2. Write it to USB (`dd`, Rufus, balenaEtcher, etc.).
3. Boot and install.

A future one-command installer (`scripts/install.sh`) is planned; the Live ISO remains the preferred path.

## Repository Layout

```
Grapefruit-OS/
├── README.md
├── docs/
│   ├── kernel-features.md
│   ├── iso-build.md
│   ├── roadmap.md
│   └── adr/
│       └── 0001-linux-kernel-foundation.md
├── configs/
│   ├── grapefruit-kernel.fragment
│   ├── sysctl.d/99-grapefruit.conf
│   ├── seccomp/README.md
│   └── landlock/README.md
├── iso/
│   └── config/
│       └── package-lists/
│           ├── grapefruit.list.chroot
│           └── desktop.list.chroot
└── scripts/
    ├── build-iso.sh
    └── install.sh
```

## Kernel & Policy Highlights

- **Kernel fragment** enables cgroups v2, all major namespaces, seccomp, Landlock, io_uring, eBPF, IOMMU, and modern scheduler options.
- **sysctl** policy hardens common attack surfaces and sets sensible modern defaults.
- **seccomp** and **Landlock** guidance is included so services and agents can be tightly sandboxed.

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

## License

To be determined.

---

*Grapefruit OS turns deliberate decisions about isolation, performance, and sovereignty into a concrete, bootable system.*
