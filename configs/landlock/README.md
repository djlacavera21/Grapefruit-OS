# Landlock Policies for Grapefruit OS

Landlock is a Linux Security Module that allows unprivileged processes to create scoped, path-based access-control policies for themselves and their children. It is one of the most important tools for the kind of fine-grained, low-overhead sandboxing Grapefruit OS aims to support.

## Why Landlock Matters Here

- Works without requiring CAP_SYS_ADMIN or root after the initial setup in many cases.
- Composes cleanly with namespaces, cgroups, and seccomp.
- Lets an agent or service restrict itself to only the directories and files it actually needs.
- Ideal for multi-agent systems, build isolation, and running less-trusted code.

## Basic Usage Pattern

1. Create a ruleset with the access rights you want to allow (read, write, execute, etc.).
2. Add path beneath rules for the specific trees the process should be able to touch.
3. Enforce the ruleset on the current process (and optionally its future children).
4. The restrictions are irreversible for that process tree — this is a feature.

## Example Directions (Conceptual)

- A build agent might Landlock itself to only its source directory, a scratch build directory, and a read-only sysroot.
- A network-facing helper might be restricted to its configuration directory and a log directory.
- A document viewer or converter can be limited to the input file and a temporary output location.

Concrete helper programs and library wrappers will be added to the Grapefruit userland over time. Until then, applications can use the Landlock kernel API or existing userspace libraries that wrap it.

## Integration with the Rest of the Stack

Landlock should be used **together with**:

- seccomp (limit the system calls that remain available)
- namespaces (PID, mount, network, user, etc.)
- cgroups v2 (resource limits)
- the sysctl hardening in `configs/sysctl.d/99-grapefruit.conf`

No single mechanism is sufficient; the combination is what produces strong, practical isolation.

## References

- Kernel documentation: Documentation/userspace-api/landlock.rst (upstream)
- Landlock ruleset access rights and ABI versions evolve; always target a recent kernel that matches the Grapefruit configuration fragment.
