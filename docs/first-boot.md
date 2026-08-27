# First Boot Guide — Grapefruit OS

This document describes what happens the first time you boot the live ISO or an installed Grapefruit OS system, and what you should verify.

## Live Session

On first boot from USB/ISO:

1. The kernel starts with the distribution kernel (or a custom kernel built from `configs/grapefruit-kernel.fragment`).
2. systemd comes up on the unified **cgroup v2** hierarchy.
3. NetworkManager starts and attempts DHCP on available interfaces.
4. **nftables** loads `/etc/nftables.conf` (default: allow outgoing + established, deny unsolicited incoming).
5. sysctl settings from `/etc/sysctl.d/99-grapefruit.conf` are applied.
6. You land at a console or graphical greeter depending on which package lists were included.

The live user (when using live-config) is typically `user` with password `live`. Change this immediately if you expose the machine to a network.

## After Installation

Calamares (when present) copies the live system to disk and should preserve:

- sysctl hardening
- nftables policy
- Grapefruit documentation under `/usr/share/doc/grapefruit/`
- seccomp profiles under `/usr/share/grapefruit/seccomp/`
- the kernel fragment under `/usr/share/grapefruit/`

Then:

1. Create a strong password for your user (the installer should already have asked).
2. If you need remote access, install and explicitly enable `openssh-server`. It is **not** enabled by default.
3. Confirm isolation primitives are present (see checks below).
4. Update packages once a repository story exists; until then treat the image as snapshot-based.

## Verification Checklist

Run these after first boot to confirm the isolation-oriented kernel features are actually live:

```bash
# cgroup v2
mount | grep cgroup2
cat /sys/fs/cgroup/cgroup.controllers

# namespaces
ls /proc/self/ns

# seccomp / Landlock support in the kernel
grep -E 'SECCOMP|LANDLOCK' /boot/config-$(uname -r) || zcat /proc/config.gz 2>/dev/null | grep -E 'SECCOMP|LANDLOCK'

# io_uring
grep IO_URING /boot/config-$(uname -r) || echo "check kernel config fragment"

# eBPF
ls /sys/fs/bpf 2>/dev/null || echo "bpf fs not mounted (optional)"

# firewall
sudo nft list ruleset

# sysctl policy
sysctl kernel.kptr_restrict kernel.dmesg_restrict kernel.unprivileged_bpf_disabled
```

## Recommended First-Hour Hardening

- Do not enable password SSH from the public internet.
- Prefer key-based SSH if you enable the daemon at all.
- Keep the nftables default-deny incoming policy unless you have a specific service to expose.
- For agent or untrusted workloads, start from `/usr/share/grapefruit/seccomp/agent-base.json` or `untrusted-code.json` and add Landlock path rules.
- If this machine will host multiple agents, put each in its own user namespace + cgroup + seccomp profile rather than running them as your login user.

## Troubleshooting

| Symptom | Likely cause | What to try |
|---------|--------------|-------------|
| No network | NetworkManager not running or no carrier | `systemctl status NetworkManager`; `nmcli device` |
| Cannot reach the machine from outside | Expected — incoming is denied | Add a targeted nftables rule or temporarily stop nftables for debugging |
| Missing graphical session | Desktop package list was not included | Rebuild ISO including `desktop.list.chroot` |
| Isolation checks fail | Stock kernel missing an option | Rebuild with `configs/grapefruit-kernel.fragment` merged |

## Related Documents

- [Kernel Features](kernel-features.md)
- [ISO Build](iso-build.md)
- [Roadmap](roadmap.md)
- [ADR 0002 — Network and Firewall Defaults](adr/0002-network-and-firewall-defaults.md)
