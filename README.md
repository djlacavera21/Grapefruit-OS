# Grapefruit OS

**Grapefruit OS** — A modern, modular Linux-based operating system focused on sovereignty, strong isolation, predictable performance, and clean design.

Grapefruit OS currently follows a pragmatic foundation: a carefully configured and hardened **Linux kernel** that enables the isolation, scheduling, I/O, and security features we consider essential. This lets us ship a usable system and ISO quickly while keeping a clear path open for more radical kernel designs later.

## Design Priorities (Kernel Level)

The kernel (and therefore the ISO and installed system) is shaped by these goals:

1. **Strong, cheap isolation** — namespaces, cgroups v2, seccomp, Landlock
2. **Predictable performance** under mixed and multi-agent workloads
3. **A manageable trusted computing base** even while using Linux
4. **Clean hardware enablement** and modern I/O (io_uring, eBPF, IOMMU)

Full discussion: **[docs/kernel-features.md](docs/kernel-features.md)**

## Current Status

- Repository scaffolding and documentation are in place
- Recommended kernel configuration fragment exists (`configs/grapefruit-kernel.fragment`)
- ISO build process is documented and scripted at the conceptual level
- Live ISO and full installer are the next major implementation targets

## Installation

### Method 1: Live ISO (Recommended)

Once releases are published:

1. Download the latest Grapefruit OS ISO from the [Releases](https://github.com/djlacavera21/Grapefruit-OS/releases) page.
2. Verify the SHA256 checksum.
3. Write to USB (`dd`, Rufus, balenaEtcher, etc.).
4. Boot and choose **Install Grapefruit OS**.

The ISO is built so that the live environment already runs the same isolation-oriented kernel configuration that the installed system will use. See **[docs/iso-build.md](docs/iso-build.md)** for how the image is produced.

### Method 2: One-Command Script (Future)

```bash
curl -fsSL https://raw.githubusercontent.com/djlacavera21/Grapefruit-OS/main/scripts/install.sh | bash
```

Currently a scaffold; the real installer will land alongside the first ISO.

### Method 3: Docker / Development Container

```bash
git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS
# docker compose support coming
```

### Method 4: Build from Source / Custom ISO

```bash
git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS
./scripts/build-iso.sh          # currently documents the process
```

Detailed instructions: **[docs/iso-build.md](docs/iso-build.md)**

## Repository Layout

```
Grapefruit-OS/
├── README.md
├── docs/
│   ├── kernel-features.md     # Full kernel design discussion
│   └── iso-build.md           # How the bootable ISO is produced
├── configs/
│   └── grapefruit-kernel.fragment   # Recommended Linux kernel options
└── scripts/
    ├── build-iso.sh           # ISO build wrapper (scaffold)
    └── install.sh             # One-command installer (scaffold)
```

## Kernel Configuration Highlights

The fragment in `configs/grapefruit-kernel.fragment` turns on (among other things):

- Full **cgroups v2** + controllers
- All major **namespaces**
- **seccomp** + **Landlock**
- **io_uring**
- **eBPF** + BTF
- **IOMMU** support
- Modern scheduler and NUMA options

These choices directly implement the priorities listed above.

## Long-Term Direction

Short term we ship a solid, hardened Linux-based system.  
Long term the same isolation primitives (namespaces, cgroups, careful capability use, modern IPC) give us a clean migration path if we ever move critical components onto a smaller microkernel or hybrid core. That decision is deliberately left open.

## Documentation

- [Kernel Features](docs/kernel-features.md) — the design rationale
- [ISO Build Process](docs/iso-build.md) — turning the design into a bootable image

## License

To be determined.

---

*Grapefruit OS exists to turn deliberate kernel-level decisions about isolation, performance, and sovereignty into a concrete, usable system.*
