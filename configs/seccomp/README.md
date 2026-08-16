# Seccomp Policies for Grapefruit OS

Seccomp-BPF is one of the primary tools we use to reduce the system-call attack surface for sandboxed and multi-agent workloads.

## Design Intent

- Default system-wide policy should remain relatively permissive so that a normal desktop or server session works without friction.
- Individual services, agents, containers, and high-risk processes should be started under tighter profiles.
- Profiles are expressed as JSON (libseccomp / podman / docker / systemd style) or as BPF programs where more control is needed.

## Recommended Starting Points

### 1. Systemd service example (tight)

Many services can use:

```ini
[Service]
SystemCallFilter=@system-service
SystemCallErrorNumber=EPERM
NoNewPrivileges=yes
```

or a more restrictive filter list once the exact needs of the service are known.

### 2. Container / agent runtimes

Prefer runtimes that apply a strong default seccomp profile (Docker/Podman default, or a custom one based on the OCI runtime-spec default + further removals).

### 3. Development / research agents

Start from a known-good profile and only add syscalls that are proven necessary. Log violations (`SCMP_ACT_LOG`) during development, then switch to `SCMP_ACT_ERRNO` or `SCMP_ACT_KILL`.

## Files in this directory

Future concrete profiles will live here, for example:

- `agent-base.json` — starting point for sandboxed agents
- `network-service.json` — tighter profile for network-facing daemons
- `untrusted-code.json` — very restrictive profile for evaluating untrusted binaries

Until those are populated, use the distribution defaults plus the guidance above, and prefer Landlock + namespaces + cgroups as additional layers.

## Related Mechanisms

- **Landlock** — path-based restrictions (see `configs/landlock/`)
- **Namespaces + cgroups v2** — the broader isolation envelope
- **sysctl settings** — `configs/sysctl.d/99-grapefruit.conf`
