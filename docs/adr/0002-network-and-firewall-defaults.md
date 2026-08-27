# ADR 0002: Network and Firewall Defaults

**Status:** Accepted  
**Date:** 2026-08-27  
**Deciders:** Project lead

## Context

Grapefruit OS emphasizes sovereignty and isolation. A live ISO and an installed system both need network access to be usable, but they should not be reachable from the network by default. Many live images leave incoming ports open or start SSH with a well-known password; that is incompatible with our goals.

## Decision

1. **NetworkManager** is the default network configuration service (DHCP on wired/wireless, user-friendly for live and desktop use).
2. **nftables** is the default packet filter.
3. Default policy:
   - Allow established/related connections
   - Allow outbound traffic
   - Allow loopback
   - Drop unsolicited incoming IPv4/IPv6 traffic
4. **openssh-server is not enabled by default** on the live image or the installed system. Remote access is an explicit choice.
5. ICMP echo is allowed in modest form so basic diagnostics still work; this can be tightened later.

## Consequences

### Positive

- A freshly booted machine is not an accidental server.
- The policy matches the isolation-first kernel story.
- nftables is the modern Linux firewall interface and composes well with namespaces.

### Negative / Risks

- Users who expect incoming SSH or file sharing out of the box will be surprised.
- A too-strict policy can complicate some LAN discovery protocols (mDNS, SMB, etc.).
- Live-session users who need to serve something must learn a small nftables snippet.

### Mitigations

- Document the defaults in `docs/first-boot.md`.
- Ship a readable `/etc/nftables.conf` with comments.
- Keep NetworkManager unrestricted for *outgoing* connectivity so the system remains pleasant to use.

## Related Documents

- [docs/first-boot.md](../first-boot.md)
- [configs/nftables/grapefruit.nft](../../configs/nftables/grapefruit.nft)
