# Seccomp Policies for Grapefruit OS

Seccomp-BPF is one of the primary tools we use to reduce the system-call attack surface for sandboxed and multi-agent workloads.

## Design Intent

- Default system-wide policy should remain relatively permissive so that a normal desktop or server session works without friction.
- Individual services, agents, containers, and high-risk processes should be started under tighter profiles.
- Profiles are expressed as JSON (libseccomp / podman / docker / systemd / OCI style).

## Concrete Profiles in this Directory

| File | Purpose |
|------|---------|
| `agent-base.json` | Starting point for sandboxed agents and services. Allows a broad but still limited set of syscalls needed by most modern userspace programs (including io_uring). |
| `untrusted-code.json` | Very restrictive profile intended for evaluating untrusted binaries or running high-risk code. Only a minimal set of syscalls is permitted. |

Both profiles default to returning an error (`SCMP_ACT_ERRNO`) for anything not explicitly allowed.

## Recommended Usage Patterns

### Systemd service

```ini
[Service]
SystemCallFilter=@system-service
SystemCallErrorNumber=EPERM
NoNewPrivileges=yes
```

or point at a custom filter once the exact needs of the service are known.

### Containers / agents

Prefer runtimes that can load an OCI-style seccomp profile. The JSON files here are intended to be usable as a starting point for Podman, Docker, or custom agent runners.

### Development workflow

1. Start with `agent-base.json` or even broader logging (`SCMP_ACT_LOG`).
2. Run the workload and collect violations.
3. Tighten to the minimum necessary set, then switch to `SCMP_ACT_ERRNO` or `SCMP_ACT_KILL`.

## Related Mechanisms

- **Landlock** — path-based restrictions (`configs/landlock/`)
- **Namespaces + cgroups v2** — the broader isolation envelope
- **sysctl settings** — `configs/sysctl.d/99-grapefruit.conf`

No single mechanism is sufficient; the combination produces strong, practical isolation.
