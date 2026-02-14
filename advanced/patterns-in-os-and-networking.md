---
layout: default
title: "Patterns in OS & Networking"
parent: "Advanced Patterns"
nav_order: 22
---

# Patterns in Practice: OS & Networking

Design patterns aren't just textbook concepts — they're deeply embedded in the systems we use every day. This page maps well-known patterns to their concrete implementations in operating system services and networking infrastructure.

## Operating System Services

### D-Bus — Mediator + Publish-Subscribe

**System**: D-Bus is the standard Linux inter-process communication (IPC) mechanism for desktop and system services.

**Pattern(s)**: Mediator, Publish-Subscribe

**How It Works**: The bus daemon (`dbus-daemon` or `dbus-broker`) routes all IPC messages between processes. Processes never talk directly to each other; instead, the daemon mediates all communication via Unix domain sockets. Signals implement pub-sub: processes subscribe via match rules, and the daemon multicasts matching signals to all subscribers.

**Why This Pattern**: Mediator decouples processes from knowing about each other — services only need to know method names and interfaces. Pub-Sub enables event-driven notifications without tight coupling. Example: NetworkManager emits `StateChanged` signal, desktop environment subscribes and updates UI when network status changes.

### systemd — State Machine + Dependency Chain

**System**: systemd is the init system and service manager for most modern Linux distributions.

**Pattern(s)**: State Machine, Dependency Chain

**How It Works**: Each unit (service, socket, mount, etc.) has well-defined states: `inactive → activating → active → deactivating → failed`. Dependencies via `Requires=`, `Wants=`, `After=`, `Before=` directives form a directed acyclic graph (DAG). State transitions are triggered by `systemctl` commands or events (process exit, socket activation, filesystem changes).

**Why This Pattern**: State Machine ensures predictable lifecycle management with clear transitions. Dependency Chain allows complex ordering constraints — services start in topologically sorted order. This prevents race conditions and ensures prerequisites are met before activation.

### udev — Observer Pattern

**System**: udev is the Linux device manager that handles dynamic device nodes and hotplug events.

**Pattern(s)**: Observer

**How It Works**: The Linux kernel emits `uevents` via netlink socket whenever devices change (added, removed, changed). The `udevd` daemon subscribes to the `NETLINK_KOBJECT_UEVENT` multicast group, matches rules in `/etc/udev/rules.d/`, performs actions (create device nodes, set permissions, run helpers), then re-emits events on a different multicast group for other userspace observers.

**Why This Pattern**: Observer decouples the kernel from userspace policy. Multiple independent consumers can react to the same event — desktop environments update device lists, automount daemons mount filesystems, power management adjusts settings — all without knowing about each other.

### procfs / sysfs — Proxy Pattern

**System**: `/proc` and `/sys` are virtual filesystems that expose kernel and hardware information.

**Pattern(s)**: Proxy

**How It Works**: These filesystems present kernel data structures as regular files. Reading `/proc/cpuinfo` doesn't perform disk I/O; it calls a kernel function that formats CPU data on-the-fly. Writing to `/sys/class/leds/.../brightness` invokes the kernel's LED driver `store()` function. Standard file permissions provide access control.

**Why This Pattern**: Proxy provides a familiar file interface to non-file resources. Applications use standard `open()`, `read()`, `write()` system calls — no special APIs needed. The kernel controls what data is exposed and how writes are validated, while userspace tools remain simple (cat, echo, shell scripts).

### Linux VFS — Adapter / Bridge

**System**: The Virtual File System (VFS) is the kernel abstraction layer that unifies all filesystems.

**Pattern(s)**: Adapter, Bridge

**How It Works**: VFS defines uniform operation tables: `file_operations`, `inode_operations`, `super_operations`, `dentry_operations`. Each filesystem (ext4, XFS, NFS, FAT, tmpfs) provides its own implementations of these operations. The kernel dispatches via function pointers — new filesystems can be added as loadable kernel modules without changing VFS code.

**Why This Pattern**: Adapter translates filesystem-specific operations into a common interface. Bridge separates the abstraction (VFS) from implementation (individual filesystems). Applications use POSIX API (`open`, `read`, `write`, `stat`) regardless of the underlying filesystem, achieving true portability.

## Networking

### TCP/IP Stack — Layered Architecture / Chain of Responsibility

**System**: The Internet protocol suite implementing network communication.

**Pattern(s)**: Layered Architecture, Chain of Responsibility

**How It Works**: Four layers: Link (Ethernet, Wi-Fi) → Internet (IP) → Transport (TCP/UDP) → Application (HTTP, DNS). On send path, each layer adds headers (encapsulation) before passing down. On receive path, each layer strips headers and passes up. Netfilter hooks (iptables/nftables) add chain-of-responsibility at multiple points (`PREROUTING`, `INPUT`, `FORWARD`, `OUTPUT`, `POSTROUTING`).

**Why This Pattern**: Layering provides separation of concerns — IP doesn't care if it runs over Ethernet or Wi-Fi; TCP doesn't care if it runs over IPv4 or IPv6. Chain of Responsibility allows packet filtering, NAT, and mangling at specific processing points. Each layer can be upgraded independently.

### nginx — Reactor Pattern

**System**: nginx is a high-performance web server and reverse proxy.

**Pattern(s)**: Reactor

**How It Works**: Single-threaded event loop per worker process using `epoll` (Linux) or `kqueue` (BSD). The event loop waits on the I/O multiplexer for ready events across thousands of sockets. When events arrive, it dispatches to appropriate handlers (HTTP parser, upstream proxy, static file sender) without blocking. Each connection is tracked as a state machine.

**Why This Pattern**: Reactor achieves massive concurrency (C10K+ connections) with minimal memory overhead. No thread-per-connection means no context switching costs. Non-blocking I/O ensures the event loop never stalls waiting for slow clients or backends. Worker processes share nothing, simplifying development.

### Load Balancers — Strategy + Proxy

**System**: Load balancers distribute traffic across backend servers (nginx, HAProxy, cloud load balancers).

**Pattern(s)**: Strategy, Proxy

**How It Works**: The load balancing algorithm is a pluggable strategy: round-robin, least-connections, IP-hash, weighted round-robin, least-response-time. In nginx, this is the `least_conn;` directive; in HAProxy, the `balance` directive. The load balancer acts as a reverse proxy — clients see a single entry point and are unaware of backend topology.

**Why This Pattern**: Strategy allows algorithm selection at runtime based on workload characteristics. Proxy provides location transparency and failure isolation — backends can be added, removed, or fail without client awareness. Health checking and failover are handled transparently by the proxy.

### DNS — Chain of Responsibility + Caching Proxy

**System**: The Domain Name System translates domain names to IP addresses.

**Pattern(s)**: Chain of Responsibility, Caching Proxy

**How It Works**: Resolution follows a chain: stub resolver (in application) → recursive resolver → root nameserver → TLD nameserver (`.com`) → authoritative nameserver. Each server either answers the query or delegates to the next level in the hierarchy. The recursive resolver caches results with TTL and serves subsequent queries from cache.

**Why This Pattern**: Chain of Responsibility implements hierarchical delegation — each nameserver handles its zone and delegates subdomains. Caching Proxy dramatically improves performance by serving popular queries from cache. This distributed design scales to billions of queries per day without central bottlenecks.

### TLS/SSL — State Machine + Strategy

**System**: Transport Layer Security provides encrypted, authenticated communication.

**Pattern(s)**: State Machine, Strategy

**How It Works**: The TLS handshake is a strict state machine: `ClientHello → ServerHello → Certificate → KeyExchange → ChangeCipherSpec → Finished`. Invalid state transitions terminate the connection with fatal alerts. Cipher suite negotiation is Strategy selection — client and server agree on algorithms (AES-GCM, ChaCha20-Poly1305, ECDHE, etc.) from their supported lists.

**Why This Pattern**: State Machine ensures protocol security — the handshake sequence cannot be bypassed or reordered. Strategy allows cryptographic agility — new algorithms can be added and weak ones deprecated without protocol redesign. TLS 1.3 simplified the state machine from 2 round trips to 1 for better performance.

## Quick Reference

| System | Pattern(s) | Key Mechanism |
|--------|-----------|---------------|
| D-Bus | Mediator, Pub-Sub | Bus daemon routes all IPC |
| systemd | State Machine, Dependency Chain | Unit lifecycle + DAG ordering |
| udev | Observer | Kernel uevents via netlink |
| procfs/sysfs | Proxy | File interface to kernel data |
| Linux VFS | Adapter/Bridge | Operation tables per filesystem |
| TCP/IP | Layered, Chain of Responsibility | Protocol layers with encapsulation |
| nginx | Reactor | epoll-based event loop |
| Load Balancers | Strategy, Proxy | Pluggable algorithms + reverse proxy |
| DNS | Chain of Responsibility, Caching Proxy | Hierarchical delegation + TTL cache |
| TLS | State Machine, Strategy | Handshake states + cipher selection |
