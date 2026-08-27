# Grapefruit OS

**Grapefruit OS** — A modern, modular Linux-based operating system focused on sovereignty, strong isolation, predictable performance, and clean design.

Grapefruit OS currently follows a pragmatic foundation: a carefully configured and hardened **Linux kernel** that enables the isolation, scheduling, I/O, and security features we consider essential. This lets us ship a usable system and ISO quickly while keeping a clear path open for more radical kernel designs later.

## Design Priorities (Kernel Level)

1. **Strong, cheap isolation** — namespaces, cgroups v2, seccomp, Landlock
2. **Predictable performance** under mixed and multi-agent workloads
3. **A manageable trusted computing base** even while using Linux
4. **Clean hardware enablement** and modern I/O (io_uring, eBPF, IOMMU)

Full discussion: **[docs/kernel-features.md](docs/kernel-features.md)**  
Architecture decisions: [ADR 0001](docs/adr/0001-linux-kernel-foundation.md) · [ADR 0002](docs/adr/0002-network-and-firewall-defaults.md)

## Current Status

- [x] Kernel feature philosophy and recommended config fragment
- [x] Concrete live-build package lists + hooks
- [x] sysctl, nftables, NetworkManager, and sshd policy files
- [x] Concrete seccomp profiles + Landlock guidance
- [x] Calamares settings, branding, welcome, and users modules
- [x] First-boot verification guide
- [x] `scripts/build-iso.sh` injects the full policy set into the live-build tree
- [ ] First published bootable hybrid ISO
- [ ] Complete installer experience

See **[docs/roadmap.md](docs/roadmap.md)** for the full phased plan.

## Building the ISO

```bash
git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS
./scripts/build-iso.sh          # prepares configuration, shows next steps
./scripts/build-iso.sh --auto   # attempts a full live-build (requires root + dependencies)
```

Details: **[docs/iso-build.md](docs/iso-build.md)**  
After the image boots: **[docs/first-boot.md](docs/first-boot.md)**

## Network Defaults

- Outgoing connectivity via NetworkManager
- Incoming traffic denied by nftables unless established/related
- SSH server is **not** enabled by default

## Repository Layout

```
Grapefruit-OS/
├── README.md
├── LICENSE
├── docs/           # design, ADRs, first-boot, roadmap, contributing
├── configs/        # kernel fragment, sysctl, seccomp, nftables, ssh, NM
├── iso/            # live-build package lists, hooks, Calamares includes
└── scripts/        # build-iso.sh, install.sh
```

## License

MIT — see [LICENSE](LICENSE).

---

*Grapefruit OS turns deliberate decisions about isolation, performance, and sovereignty into a concrete, bootable system.*
