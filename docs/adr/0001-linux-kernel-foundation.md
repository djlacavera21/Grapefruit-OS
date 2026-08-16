# ADR 0001: Linux Kernel as the Pragmatic Foundation

**Status:** Accepted  
**Date:** 2026-08-16  
**Deciders:** Project lead

## Context

Grapefruit OS needs a kernel that provides:

- Strong isolation primitives (namespaces, cgroups, seccomp, Landlock, etc.)
- Modern high-performance I/O (io_uring) and programmability (eBPF)
- Broad hardware support and mature drivers
- A path to a usable live ISO and installer in a reasonable timeframe
- The ability to keep future architectural options open (including a possible later move toward a smaller microkernel or hybrid core)

A pure microkernel (seL4-style), a new hybrid, or a from-scratch kernel would give a smaller trusted computing base and cleaner capability model, but would significantly delay a bootable, useful system and force us to re-implement or re-port large amounts of driver and userspace infrastructure.

## Decision

We will use a **carefully configured and hardened Linux kernel** as the foundation for the initial releases of Grapefruit OS.

We will:

- Maintain a curated kernel configuration fragment (`configs/grapefruit-kernel.fragment`) that explicitly enables the isolation, scheduling, I/O, and security features we care about.
- Treat namespaces + cgroups v2 + seccomp + Landlock as first-class mechanisms and design userland policies around them.
- Prefer io_uring and eBPF where they improve performance or observability.
- Document the long-term possibility of moving selected services or eventually the core onto a smaller kernel while keeping the same isolation interfaces visible to applications.

## Consequences

### Positive

- Rapid path to a bootable ISO and usable system.
- Excellent hardware and driver coverage.
- Ability to leverage the existing Linux ecosystem (containers, observability tools, etc.).
- The isolation features we enable already give us most of the practical benefits we would seek from a more capability-oriented kernel for multi-agent and sandboxed workloads.

### Negative / Risks

- Larger trusted computing base than a microkernel.
- Some isolation properties are “best-effort” or policy-dependent rather than enforced by a tiny core.
- Future migration to a different kernel architecture will require careful interface discipline.

### Mitigations

- Aggressive use of the strongest Linux isolation mechanisms available.
- Clear documentation of the design rationale and the long-term options.
- Keeping userland interfaces (especially around sandboxing and resource control) clean so they are not tightly coupled to Linux-specific details beyond what is necessary.

## Related Documents

- [docs/kernel-features.md](../kernel-features.md)
- [docs/roadmap.md](../roadmap.md)
- [configs/grapefruit-kernel.fragment](../../configs/grapefruit-kernel.fragment)
