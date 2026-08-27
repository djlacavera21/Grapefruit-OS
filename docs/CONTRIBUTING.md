# Contributing to Grapefruit OS

Thank you for helping build an isolation-first Linux system.

## How the Project Is Structured

- `docs/` — design, ADRs, roadmap, first-boot behavior
- `configs/` — kernel fragment, sysctl, seccomp, Landlock notes, nftables, sshd
- `iso/` — live-build package lists, hooks, and files copied into the image
- `scripts/` — ISO builder and future installer wrappers

Read [docs/adr/0001-linux-kernel-foundation.md](adr/0001-linux-kernel-foundation.md) and [docs/roadmap.md](roadmap.md) before proposing large changes.

## Guiding Principles

1. Strong, cheap isolation comes first.
2. Predictable performance under mixed workloads matters.
3. Keep the trusted computing base understandable.
4. Prefer mechanisms that leave future kernel-architecture options open.

## Practical Guidelines

- Prefer small, reviewable commits with a clear purpose.
- New default policies should be documented (ADR if the decision is hard to reverse).
- Do not enable incoming network services by default.
- Live-build hooks must be idempotent and safe to re-run.
- Package lists should stay lean; put optional desktop pieces in `desktop.list.chroot`.

## Building

See [docs/iso-build.md](iso-build.md) and `scripts/build-iso.sh`.

## Issues and Direction

Open issues at https://github.com/djlacavera21/Grapefruit-OS/issues.
Design discussion belongs in ADRs when it changes defaults or architecture.
