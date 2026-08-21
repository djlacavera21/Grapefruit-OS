# Grapefruit OS v1.0 Revision A — Implementation Review

**Status:** Engineering follow-up to Technical Specification v1.0 Revision A  
**Purpose:** Identify the sections that should be expanded or corrected before the specification is treated as an implementation-ready build contract.

## Overall assessment

Revision A is a strong reference architecture and governance baseline. Its next step is to move the highest-risk subsystems from architectural intent into executable contracts: concrete algorithms, state machines, schemas, transport semantics, service definitions, deployment artifacts, and conformance tests.

The implementation sequence should prioritize the GPT Executive, agent runtime/protocol, Linux enforcement boundary, memory/semantic filesystem, plugin/runtime isolation, and security/conformance harnesses because those components define the platform's trust and execution model.

## P0 — GPT Executive Engine

Expand the Executive from architectural responsibilities into an executable scheduler specification.

Required additions:

- Canonical `Intent`, `Plan`, `PlanNode`, `TaskLease`, `Evidence`, `Approval`, `Checkpoint`, and `Compensation` schemas.
- Plan DAG construction and validation algorithm.
- Priority, deadline, dependency, and resource-aware scheduling rules.
- Critical-path calculation and starvation prevention.
- Lease acquisition, renewal, timeout, cancellation, and preemption semantics.
- Deterministic state transitions for `proposed`, `validated`, `awaiting_approval`, `scheduled`, `running`, `verifying`, `succeeded`, `failed`, `compensating`, `cancelled`, and `quarantined`.
- Verification/critique loop termination rules.
- Escalation thresholds and human approval gates.
- Checkpoint and compensation behavior for partially completed plans.
- Recovery after process, node, model-provider, or storage failure.

Acceptance target: an engineer should be able to implement a conforming Executive scheduler without inventing lifecycle or failure semantics.

## P0 — Agent Runtime and Supervision

Define the runtime as a supervised distributed system rather than only a capability abstraction.

Required additions:

- Bootstrap and cryptographic registration.
- Capability advertisement and version negotiation.
- Heartbeat cadence and health states.
- Task leasing and lease fencing.
- Graceful shutdown and forced termination.
- Crash restart policy and exponential backoff.
- Quarantine criteria and re-admission flow.
- Capability revocation while work is in flight.
- Agent migration between local, edge, and clustered runtimes.
- Supervisor failure and leadership rules.
- Resource ceilings for CPU, memory, I/O, accelerator, network, and storage.

Suggested state machine:

`NEW -> REGISTERING -> READY -> LEASED -> RUNNING -> VERIFYING -> READY`

Exceptional paths should include `DEGRADED`, `DRAINING`, `QUARANTINED`, `FAILED`, and `RETIRED`.

## P0 — Agent Communication Protocol

Turn the typed message envelope into a complete versioned protocol.

Required additions:

- Protocol version and feature negotiation.
- Canonical serialization rules and schema evolution.
- Authentication and peer identity binding.
- Correlation, causation, trace, span, idempotency, and conversation identifiers.
- Request/response, event, stream, cancellation, progress, and acknowledgement message classes.
- Delivery guarantees: at-most-once, at-least-once, and the exact conditions under which each applies.
- Ordering guarantees and partition behavior.
- Retry budgets and retryable/non-retryable errors.
- Dead-letter handling.
- Replay detection and freshness windows.
- Fragmentation, streaming, compression, and maximum message sizes.
- Backpressure and queue saturation behavior.
- Explicit compatibility matrix between protocol revisions.

## P0 — Linux Enforcement Boundary

Replace conceptual Linux integration with concrete system interfaces.

Required additions:

- systemd unit files and dependency ordering.
- D-Bus interface definitions.
- polkit actions and policy examples.
- cgroups v2 hierarchy and controller ownership.
- namespace topology.
- seccomp profile ownership and update rules.
- Landlock/AppArmor/SELinux integration policy.
- OCI runtime configuration for agent sandboxes.
- device and accelerator access mediation.
- package/update integration and rollback.
- kernel capability requirements and feature detection.
- boot-time health checks and fail-safe startup behavior.

The Linux kernel and trusted user-space services must remain the authority for process, memory, device, identity, filesystem, and network controls; model output must never act as an authorization primitive.

## P1 — Semantic Filesystem and Knowledge Layer

Specify persistent objects and provenance in storage-engine terms.

Required additions:

- Canonical object identifier format.
- Metadata schema and schema-version rules.
- Content hashing and deduplication.
- Provenance DAG representation.
- Revision and branch model.
- Semantic index ingestion pipeline.
- Embedding/model-version provenance.
- ACL and policy inheritance.
- Tombstones, retention, legal hold, and secure deletion.
- Replication and conflict resolution.
- Snapshot and restore.
- Offline mutation reconciliation.
- Corruption detection and index rebuild procedures.

## P1 — Memory Subsystems

Separate working, episodic, preference, semantic, and long-term memory into independently enforceable stores.

Required additions:

- Store-specific schemas and APIs.
- Admission policy.
- Retention and eviction policy.
- Confidence and provenance fields.
- User correction and deletion semantics.
- Namespace and tenant isolation.
- Encryption at rest and in transit.
- Replication and backup.
- Memory compaction/summarization rules.
- Retrieval ranking and recency weighting.
- Protection against memory poisoning and untrusted retrieved instructions.
- Benchmark datasets for recall, precision, provenance fidelity, and deletion correctness.

## P1 — Model Orchestration

Define the router in operational terms.

Required additions:

- Provider/model capability registry.
- Local/cloud/edge routing policy.
- Privacy and data-residency constraints.
- Maximum latency and cost budgets.
- Context-window and token-budget accounting.
- Deterministic fallback order.
- Provider circuit breakers.
- Health probes and rate-limit handling.
- Model-version pinning for reproducibility.
- Output validation before privileged execution.
- Offline mode behavior.

## P1 — Desktop Command Center and Workflow Inspector

Convert the UI concepts into a stable shell contract.

Required additions:

- Navigation model and window hierarchy.
- Intent Composer contract.
- Approval and consent surface behavior.
- Workflow Inspector event model.
- Live plan graph representation.
- Cancellation and rollback controls.
- Evidence/provenance inspection.
- Notification framework.
- Accessibility tree and keyboard-only operation.
- Plugin surface isolation.
- UI event-loop and IPC boundaries.
- Degraded-mode behavior when Executive or indexing services are unavailable.

## P1 — Plugin Platform and SDKs

Expand the manifest into a complete developer and distribution contract.

Required additions:

- Manifest JSON Schema.
- Capability/permission vocabulary.
- ABI/API compatibility rules.
- Dependency resolution.
- Lifecycle hooks.
- Sandbox configuration.
- Secret access and connector mediation.
- Signing, transparency, revocation, and update workflow.
- Certification tiers and automated conformance tests.
- Marketplace policy and emergency kill switch.
- Python, Rust, C++, REST, and gRPC reference clients.
- Streaming, cancellation, authentication, retries, and typed errors in each SDK.

## P1 — Zero-Trust Security Architecture

Expand the existing threat-model material into buildable controls.

Required additions:

- Explicit trust-boundary diagrams.
- Machine and workload identity lifecycle.
- Key hierarchy and rotation.
- TPM-backed device identity and measured boot where available.
- Secure Boot integration.
- Remote attestation model.
- Secret storage and broker architecture.
- Signed policy bundles.
- Artifact and plugin signature verification.
- Audit-log integrity and retention.
- Incident-response states.
- Attack trees for Executive compromise, agent impersonation, malicious plugin, poisoned memory, connector compromise, and supply-chain compromise.
- STRIDE controls tied directly to requirements and tests.
- Illustrative MITRE ATT&CK mappings tied to telemetry sources and mitigations.

## P2 — Enterprise, Kubernetes, Edge, and Federation

Required additions:

- Kubernetes CRDs/operator behavior.
- Helm chart values and upgrade strategy.
- Reference service topology.
- Fleet enrollment.
- Certificate issuance and rotation.
- Multi-region HA.
- Backup/restore and disaster-recovery runbooks.
- RPO/RTO targets.
- Disconnected-operation queues and reconciliation.
- Federation trust establishment and revocation.
- Tenant isolation.
- Policy distribution and rollback.
- Edge-node resource classes.

## P2 — Performance and Conformance Engineering

Move from metric definitions to reproducible harnesses.

Required additions:

- Reference hardware profiles.
- Synthetic and real workflow corpus.
- P50/P95/P99 latency reporting.
- Plan scheduling throughput.
- Agent queue saturation tests.
- Semantic retrieval precision/recall benchmarks.
- Memory-pressure and disk-pressure tests.
- Model-provider outage tests.
- Network partition and clock-skew tests.
- Crash/restart and power-loss injection.
- Security-policy denial tests.
- Rollback correctness tests.
- Long-duration soak testing.
- Compatibility tests across schema, protocol, and SDK versions.

## Cross-cutting corrections

1. Replace remaining subsystem-generic prose with subsystem-specific contracts.
2. Give every externally visible state and error a stable identifier.
3. Add a formal glossary and canonical terminology rules.
4. Add architecture decision records for major implementation choices.
5. Add versioned compatibility matrices for protocols, APIs, plugins, and schemas.
6. Tie each normative `SHALL` requirement to one or more conformance tests.
7. Distinguish normative requirements from informative examples in every appendix.
8. Specify migration behavior before changing persistent schemas.
9. Define what happens under degraded dependencies instead of relying on generic retry language.
10. Keep authorization deterministic: models may recommend actions, but signed policy and trusted enforcement components grant authority.

## Recommended implementation sequence

### Milestone 1 — Execution Core

- Executive schemas and state machine.
- Agent runtime lifecycle.
- Message protocol v1.
- systemd/D-Bus/polkit contracts.
- Minimal evidence/audit store.

### Milestone 2 — Isolation and Knowledge

- OCI/cgroups/seccomp/Landlock integration.
- Semantic object model.
- Working and episodic memory.
- Provenance and indexing pipeline.

### Milestone 3 — Developer Platform

- REST/gRPC contracts.
- Python and Rust SDKs first.
- Plugin manifest/schema.
- Signing and sandbox certification.

### Milestone 4 — Desktop and Model Fabric

- Command Center.
- Workflow Inspector.
- Local/cloud model router.
- Approval and recovery surfaces.

### Milestone 5 — Enterprise and Conformance

- Kubernetes/operator deployment.
- Fleet identity and governance.
- HA/DR.
- Full conformance, fault-injection, performance, and security suites.

## Definition of implementation-ready

A subsystem should be considered implementation-ready only when it has:

1. Stable typed inputs and outputs.
2. Enumerated states and state transitions.
3. Explicit authorization boundary.
4. Timeout, cancellation, idempotency, and retry semantics where applicable.
5. Defined failure and recovery behavior.
6. Observable logs, metrics, traces, and audit evidence.
7. Versioning and compatibility rules.
8. Security requirements tied to controls.
9. At least one reference implementation or executable example.
10. A conformance suite with acceptance thresholds.

This review should be used as the implementation-expansion backlog for the next specification revision and as a guide for repository-level engineering work.