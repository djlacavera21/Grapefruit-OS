# Grapefruit OS Kernel Features

> Based on a structured analysis of modern OS kernel design, tailored for a Linux-based pragmatic foundation with a clear path toward stronger isolation and sovereignty.

An operating system kernel is the privileged core that sits between hardware and everything else. It owns the CPU, memory, devices, and the rules of isolation. Every higher-level feature of Grapefruit OS ultimately rests on the design decisions made here.

Grapefruit OS currently follows the **pragmatic short-term path**: a carefully configured and hardened Linux kernel. This gives us immediate access to mature drivers, broad hardware support, and a vast ecosystem while we deliberately enable (and document) the features that matter most for sovereignty, containers, multi-agent workloads, and long-term maintainability.

---

## 1. Fundamental Responsibilities

Every serious kernel must provide:

- **Process / thread abstraction** — creating, destroying, and switching between execution contexts.
- **Virtual memory** — address space isolation, demand paging, copy-on-write, shared memory.
- **Scheduling** — deciding which thread runs on which core and for how long.
- **Interrupt and exception handling** — the bridge from hardware events to software.
- **Device I/O and drivers** — abstracting hardware so user space does not talk to it directly.
- **IPC and synchronization primitives** — the ways processes talk and coordinate.
- **System call interface** — the stable contract with user space.

These are non-negotiable. Everything else is an elaboration or a policy choice layered on top.

In Grapefruit OS we treat the Linux kernel as the current implementation of these responsibilities and focus on enabling the right configuration options and user-space policies around them.

---

## 2. Kernel Architecture Style

| Style              | Examples                  | Strengths                                      | Weaknesses                                      | Grapefruit OS Position                          |
|--------------------|---------------------------|------------------------------------------------|-------------------------------------------------|-------------------------------------------------|
| **Monolithic**     | Linux, FreeBSD            | High performance, mature drivers, single address space | Large TCB, harder formal verification          | **Current foundation** (pragmatic)             |
| **Microkernel**    | seL4, Fuchsia Zircon, QNX | Extremely small TCB, strong isolation, restartable servers | Higher IPC cost, more complex system design   | Long-term research / alternative path          |
| **Hybrid**         | Windows NT, XNU, Haiku    | Balance of performance and modularity          | Can become undisciplined                        | Possible evolution target                      |
| **Exokernel / Library OS** | MirageOS, Unikernels | Extreme specialization                         | Poor general-purpose usability                  | Interesting for future specialized appliances  |

**Decision for Grapefruit OS (2026):**  
Start with a **modular, hardened Linux** kernel. This gives rapid hardware enablement and lets us ship a usable ISO quickly. We deliberately enable the strongest isolation features Linux offers (namespaces, cgroups v2, seccomp, Landlock, io_uring, eBPF, etc.) so that the userland can already behave as if it were running on a more capability-oriented system. A future microkernel or hybrid core remains an explicit long-term option.

---

## 3. Process, Thread, and Scheduling Features

Grapefruit OS expects (and configures) the following:

- Lightweight threads with low creation cost
- Completely Fair Scheduler (CFS) + real-time scheduling classes
- Full **cgroups v2** support for CPU, memory, I/O, and device controllers
- CPU affinity and NUMA awareness
- Preemption (voluntary + involuntary) with low-latency options
- Energy-aware scheduling where hardware supports it

**Enabled Linux config highlights:**
- `CONFIG_CGROUPS=y`
- `CONFIG_CGROUP_SCHED=y`
- `CONFIG_FAIR_GROUP_SCHED=y`
- `CONFIG_CFS_BANDWIDTH=y`
- `CONFIG_RT_GROUP_SCHED=y`
- `CONFIG_NUMA=y` (where applicable)

Edge cases we care about: priority inversion handling, scheduler latency under interrupt load, and fairness under multi-tenant / multi-agent workloads.

---

## 4. Memory Management

Core Linux features we rely on and strengthen:

- Full virtual address spaces with modern page-table support
- Demand paging, swap, and controlled overcommit
- Copy-on-write (`fork` / `clone`)
- Shared memory and `mmap`
- Transparent Huge Pages (with careful defaults)
- ASLR, KASLR, and related hardening
- Memory protection keys where hardware provides them

**Grapefruit priorities:**
- Cheap, hard isolation boundaries for containers and future multi-agent systems
- Resistance to fragmentation and side-channel leakage in the allocator
- Support for memory tagging / MTE on capable ARM hardware

---

## 5. Inter-Process Communication (IPC)

We leverage the high-performance modern Linux paths:

- Classic: pipes, Unix domain sockets, shared memory + futexes
- High-performance: **io_uring**, cross-memory attach, zero-copy techniques
- eBPF-assisted observability and policy

While pure capability-based IPC (seL4 style) is not native to Linux, we approximate strong isolation using namespaces + seccomp + Landlock + careful capability bounding sets. This gives us most of the practical benefits today.

---

## 6. Device Drivers and I/O Subsystem

- Modern driver model with module versioning
- Threaded interrupts and NAPI-style polling
- **IOMMU support** (mandatory for security — prevents devices from DMA-attacking memory)
- Block layer + modern filesystems
- **io_uring** as the preferred asynchronous I/O interface
- Network stack with XDP and eBPF acceleration available

Critical drivers remain in-kernel for performance and hardware coverage. User-space driver experiments are possible later via VFIO or similar.

---

## 7. Security and Isolation Features

This is a first-class priority for Grapefruit OS:

- **Namespaces** (PID, mount, network, user, cgroup, time, etc.)
- **cgroups v2** as the resource control backbone
- **seccomp-BPF** for system-call filtering
- **Landlock** LSM for unprivileged sandboxing
- Optional stronger MAC (AppArmor or SELinux profiles)
- KASLR, KPTI, control-flow integrity features where available
- Strict capability bounding and no-new-privs support

Goal: Make it straightforward to create extremely tight sandboxes with a minimal trusted computing base visible to each workload.

---

## 8. Modern and Emerging Features

Actively enabled / planned:

- **eBPF** — safe in-kernel programmability for networking, security policy, and observability
- **io_uring** — low-overhead asynchronous I/O
- Rust support in the kernel (where upstream allows) for new drivers and components
- Hardware virtualization (KVM) with nested paging
- Real-time patches / configuration options for mixed-criticality workloads
- Confidential computing hooks (TDX / SEV) as optional future support
- Strong power and thermal management

---

## 9. Implications for Grapefruit OS ISO and Distribution

The live ISO and installed system ship with a kernel configured according to the priorities above. The build process (see `docs/iso-build.md` and `scripts/build-iso.sh`) applies a curated kernel configuration fragment that turns on the isolation, scheduling, I/O, and security features we care about while disabling unnecessary attack surface where possible.

**Short-term (current):**  
Hardened, feature-rich Linux kernel → usable ISO and installer quickly.

**Long-term:**  
The same userland interfaces (namespaces, cgroups, io_uring, etc.) give us a clean migration path if we ever move critical services onto a smaller microkernel or hybrid core.

---

## Summary — What Actually Matters

The most important kernel properties for Grapefruit OS are:

1. **Strong, cheap isolation** (namespaces + cgroups + seccomp + Landlock)
2. **Predictable performance** under mixed workloads
3. **A manageable trusted computing base** (even while using Linux)
4. **A clean path for drivers and hardware enablement**

Everything in the ISO build, package selection, and default policies is aligned with these goals.
