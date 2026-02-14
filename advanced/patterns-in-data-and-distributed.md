---
layout: default
title: "Patterns in Data & Distributed Systems"
parent: "Advanced Patterns"
nav_order: 23
---

# Patterns in Practice: Data & Distributed Systems

Design patterns aren't confined to application code—they're fundamental building blocks in databases, distributed infrastructure, message queues, and programming runtimes. Understanding how PostgreSQL, Kubernetes, Kafka, and the JVM apply patterns reveals why these systems are architected the way they are.

## Databases

### Connection Pooling — Object Pool

**System**: HikariCP, pgBouncer, Go `database/sql`

**Pattern(s)**: Object Pool

**How It Works**: Connection pools pre-create a fixed number of database connections at startup. Connections are borrowed via `getConnection()` and returned (not closed) when done. HikariCP uses a `ConcurrentBag` of `PoolEntry` objects to minimize contention. Connections are validated before reuse and refreshed when stale.

**Why This Pattern**: Establishing a database connection requires TCP handshake, TLS negotiation, and authentication—typically 10-100ms. For web services handling thousands of requests per second, creating a connection per request would be a bottleneck. Pooling amortizes this cost across many operations, dramatically improving throughput.

### Query Optimizer — Strategy

**System**: PostgreSQL, MySQL, Oracle

**Pattern(s)**: Strategy

**How It Works**: PostgreSQL's query planner offers multiple join strategies: nested loop join, merge join, and hash join. For table access, it provides sequential scan, index scan, bitmap scan, and index-only scan. The cost-based optimizer uses table statistics from `ANALYZE` to estimate the cost of each strategy and selects the cheapest plan. Each strategy implements the same interface (produce result tuples) with different algorithms.

**Why This Pattern**: No single algorithm is optimal for all data distributions. Nested loop joins excel with small outer tables; hash joins dominate with large equi-joins; merge joins shine with pre-sorted data. The Strategy pattern allows the optimizer to switch algorithms based on runtime statistics without changing the query execution engine.

### MVCC — Memento-like Snapshots

**System**: PostgreSQL, MySQL InnoDB, Oracle

**Pattern(s)**: Memento-like

**How It Works**: PostgreSQL's Multi-Version Concurrency Control (MVCC) creates new row versions on updates rather than overwriting. Each tuple carries `xmin` (creating transaction ID) and `xmax` (deleting transaction ID). Each transaction sees a consistent snapshot based on its start time—only rows visible to that snapshot are returned. Old versions are cleaned up by `VACUUM` once no active transaction needs them.

**Why This Pattern**: Readers never block writers; writers never block readers. This eliminates read locks entirely, enabling high concurrency for mixed read/write workloads. Transactions get a stable view of the database without holding locks, simplifying application logic and preventing many deadlock scenarios.

### Write-Ahead Log (WAL) — Command + Event Sourcing

**System**: PostgreSQL, MySQL, SQLite

**Pattern(s)**: Command, Event Sourcing

**How It Works**: Every modification is recorded as a WAL record before data pages are changed. Records are serialized commands: "insert tuple X into page Y at offset Z." On commit, WAL is flushed to disk (data pages flushed later). Crash recovery replays WAL from the last checkpoint. Logical replication decodes WAL into an event stream (INSERT, UPDATE, DELETE) that standby servers consume.

**Why This Pattern**: Sequential WAL writes are orders of magnitude faster than random data page writes. WAL enables point-in-time recovery, streaming replication, and logical replication. Event sourcing properties—immutability, replayability, auditability—make WAL the foundation of database durability and high availability.

### B-Tree Indexes — Composite + Iterator

**System**: PostgreSQL, MySQL, SQLite

**Pattern(s)**: Composite, Iterator

**How It Works**: B-Trees consist of internal nodes (keys + child pointers) and leaf nodes (keys + data pointers). Search, insert, and delete are recursive operations through the tree hierarchy—a Composite pattern. Leaf nodes are linked via sibling pointers, enabling efficient range scans. PostgreSQL's `IndexScanDescData` walks this linked leaf chain, implementing the Iterator pattern.

**Why This Pattern**: The Composite pattern allows uniform treatment of nodes regardless of depth. The Iterator pattern decouples range scanning from the tree structure, enabling bidirectional scans, parallel index-only scans, and skip scans without exposing tree internals.

## Distributed Systems

### Kubernetes — Controller Loop + Sidecar + Ambassador

**Controller Loop (Observer + Reconciliation)**: Controllers watch the API server via informers (Observer pattern), comparing current state to desired state. When they diverge, the controller takes corrective action—creating Pods, updating Services, scaling Deployments. The reconciliation loop is idempotent and runs continuously, self-healing the cluster.

**Sidecar**: Istio injects an Envoy proxy into every Pod as a sidecar container. The proxy intercepts all traffic via iptables rules, handling mTLS, load balancing, retries, circuit breaking, and telemetry without any application code changes. The sidecar augments the main container with cross-cutting concerns.

**Ambassador**: A specialized sidecar that proxies between the application and external services. Examples include database connection poolers that manage pooling and read/write splitting, or API gateways that handle authentication and rate limiting.

### Docker — Builder + Decorator

**Builder**: Multi-stage Dockerfiles separate the build process from the final product. Early stages install compilers and build tools; intermediate stages compile code; the final stage copies only the binary into a minimal base image. The build process is complex, but the product is simple.

**Decorator (layered)**: Each Dockerfile instruction (`RUN`, `COPY`, `ADD`) creates a filesystem layer via OverlayFS. Each layer decorates previous layers, adding files or modifying behavior. Layers are cached by content hash and shared between images, minimizing storage and transfer overhead.

### Apache Kafka — Pub-Sub + Event Sourcing

**Pub-Sub**: Producers publish messages to topics; consumer groups subscribe to topics. Each topic is partitioned for parallelism—each partition is a total order. Unlike traditional queues, messages are retained after consumption (retention policy, not acknowledgment-based deletion).

**Event Sourcing**: The commit log is append-only and immutable. Log compaction retains the latest value per key, creating a compacted changelog. Applications rebuild state by replaying the log from the beginning or a checkpoint. Kafka Streams uses this for stateful stream processing, storing changelog topics in Kafka itself.

### etcd / ZooKeeper — Observer + Leader Election

**Observer (Watch)**: etcd allows watching a key or prefix; the server pushes notifications to the client when values change. ZooKeeper provides watches on znodes that fire one-time notifications. Both decouple observers from subjects, enabling reactive systems without polling.

**Leader Election**: ZooKeeper uses ephemeral sequential znodes. Candidates create znodes; the one with the smallest sequence number becomes leader. If the leader crashes, its ephemeral znode disappears, and the next candidate takes over. etcd uses lease-protected keys; the lease TTL acts as a heartbeat. Both patterns ensure exactly one leader at a time.

### gRPC — Proxy + Adapter

**Proxy**: Auto-generated client stubs from `.proto` files act as proxies. The stub serializes method arguments to Protobuf, sends the request over HTTP/2, deserializes the response, and returns it. To the caller, it looks like a local method call. The stub controls access to the remote service, adding retries, deadlines, and load balancing.

**Adapter**: `grpc-gateway` translates REST/JSON requests into gRPC calls and vice versa. It adapts the gRPC interface to a REST interface, allowing HTTP clients to consume gRPC services without code generation. The adapter bridges incompatible interfaces.

### Istio / Service Mesh — Sidecar + Circuit Breaker

**Sidecar**: Envoy proxy runs in every Pod, transparent to the application. It handles mTLS (mutual TLS authentication), retries, rate limiting, load balancing, and observability (metrics, traces, logs). Configuration is pushed from the control plane via xDS APIs.

**Circuit Breaker**: `DestinationRule` resources configure `OutlierDetection`. Envoy tracks error rates and response latencies for each upstream host. When a host exceeds thresholds (e.g., 5 consecutive 5xx errors), Envoy ejects it from the load balancing pool for a cooldown period. This prevents cascading failures by failing fast.

## Message Queues

### RabbitMQ — Message Router + Dead Letter

**System**: RabbitMQ

**Pattern(s)**: Message Router, Dead Letter

**How It Works**: RabbitMQ exchanges implement routing strategies. Direct exchanges route by exact routing key. Topic exchanges use wildcard patterns (`logs.*.error`). Fanout exchanges broadcast to all bound queues. Headers exchanges route by message headers. Producers publish to exchanges, not queues; the exchange determines delivery. Dead Letter Exchanges (DLX) receive rejected, expired, or unroutable messages for inspection or retry.

**Why This Pattern**: Routing logic is centralized in the exchange, not scattered across producers or consumers. Adding new consumers doesn't require producer changes. DLX provides a standard mechanism for handling failures without losing messages—critical for reliable systems.

### Redis — Pub-Sub + Cache-Aside

**System**: Redis

**Pattern(s)**: Pub-Sub, Cache-Aside

**How It Works**: Redis `PUBLISH`/`SUBSCRIBE` provides real-time channel-based messaging. Messages are fire-and-forget (no persistence or guarantees). For caching, applications implement Cache-Aside: check Redis first, on cache miss query the database, write the result to Redis with a TTL. Redis Streams adds persistent, consumer-group-aware messaging with acknowledgments.

**Why This Pattern**: Pub-Sub decouples publishers from subscribers, enabling real-time notifications without polling. Cache-Aside gives applications full control over caching logic—what to cache, when to invalidate, how to handle misses—without black-box behavior.

### Apache Camel — Pipes and Filters

**System**: Apache Camel

**Pattern(s)**: Pipes and Filters

**How It Works**: Camel routes define message flows: `from("source")` → processors/filters → `to("destination")`. Each processor is independent: transform (XML to JSON), validate (schema check), enrich (call external API), filter (discard non-matching messages). Camel explicitly implements the Enterprise Integration Patterns catalog from Hohpe & Woolf. Content-Based Router, Splitter, Aggregator, Wire Tap, and dozens more are first-class DSL constructs.

**Why This Pattern**: Pipes and Filters decouple processing stages. Each filter is testable in isolation. Routes are declarative and self-documenting. New filters can be inserted without modifying existing ones. Camel's DSL turns the pattern into a programming model.

## Programming Runtimes

### JVM Garbage Collectors — Strategy

**System**: Java Virtual Machine

**Pattern(s)**: Strategy

**How It Works**: The JVM provides multiple garbage collectors, selectable via flags: `-XX:+UseG1GC` (region-based, ~100ms pauses), `-XX:+UseZGC` (colored pointers, sub-millisecond pauses), `-XX:+UseShenandoahGC` (concurrent compaction). All implement the same interface (identify garbage, reclaim memory, compact heap) with radically different algorithms. G1 prioritizes throughput with predictable pauses. ZGC minimizes pause times for large heaps. Shenandoah focuses on concurrent compaction.

**Why This Pattern**: No single GC algorithm suits all workloads. Throughput-oriented batch jobs prefer parallel GC. Low-latency services need ZGC. The Strategy pattern allows tuning the collector to the workload without changing application code.

### Node.js — Reactor

**System**: Node.js

**Pattern(s)**: Reactor

**How It Works**: libuv implements an event loop using `epoll` (Linux), `kqueue` (BSD/macOS), or IOCP (Windows). A single thread polls for ready I/O events (socket readable, timer expired, file descriptor ready), invokes the corresponding callback, and repeats. Blocking operations (DNS resolution, filesystem I/O) are offloaded to a thread pool (default 4 threads). JavaScript is single-threaded; concurrency comes from non-blocking I/O.

**Why This Pattern**: The Reactor pattern achieves high concurrency with minimal memory overhead. Each connection doesn't need a thread (unlike thread-per-connection models). Thousands of concurrent connections can be handled by a single thread, making Node.js ideal for I/O-bound services like API gateways and WebSocket servers.

### Go Goroutines — CSP (Communicating Sequential Processes)

**System**: Go runtime

**Pattern(s)**: CSP (Communicating Sequential Processes)

**How It Works**: Goroutines are lightweight threads with small stack sizes (starting at ~2KB). The Go scheduler multiplexes goroutines onto OS threads using M:N scheduling. Channels are typed, synchronized pipes between goroutines. Sends block until a receiver is ready (unbuffered channels). The `select` statement waits on multiple channels simultaneously. Unlike the Actor model, channels are first-class and not tied to specific goroutines.

**Why This Pattern**: CSP encourages "don't communicate by sharing memory; share memory by communicating." Channels provide synchronization guarantees without explicit locks. Goroutines are cheap enough to spawn thousands without concern. The pattern simplifies concurrent programming by making data flow explicit.

### Python GIL — Monitor

**System**: CPython

**Pattern(s)**: Monitor

**How It Works**: The Global Interpreter Lock (GIL) is a mutex protecting the Python interpreter. Only one thread can execute Python bytecode at a time. The GIL is released every 5ms (Python 3.2+) via the `gil_drop_request` flag, giving other threads a chance. It's also released during I/O operations. The lock and condition variable together form a Monitor pattern.

**Why This Pattern**: The GIL simplifies reference counting and protects internal data structures. It eliminates data races in the interpreter itself. However, it limits CPU-bound parallelism—multiple threads on multiple cores still execute Python code serially. The pattern trades multi-core performance for implementation simplicity and safety.

### Rust Ownership — RAII

**System**: Rust

**Pattern(s)**: RAII (Resource Acquisition Is Initialization)

**How It Works**: Every value in Rust has exactly one owner. When the owner goes out of scope, the `Drop` trait is called automatically, releasing resources. Files close on drop; `MutexGuard` releases locks on drop; memory is freed on drop. The borrow checker enforces at compile time that references are valid: either one mutable reference OR many immutable references, never both.

**Why This Pattern**: RAII provides deterministic resource cleanup without garbage collection. Memory leaks and resource leaks are prevented by the type system. The borrow checker eliminates data races at compile time—no runtime overhead. Rust achieves memory safety and thread safety through compile-time enforcement of RAII and borrowing rules.

## Quick Reference

| Category | System | Pattern(s) | Key Mechanism |
|----------|--------|-----------|---------------|
| **Databases** | Connection Pools | Object Pool | Pre-created reusable connections |
| | Query Optimizer | Strategy | Cost-based algorithm selection |
| | MVCC | Memento-like | Multiple row versions per transaction |
| | WAL | Command, Event Sourcing | Append-only operation log |
| | B-Tree | Composite, Iterator | Tree nodes + linked leaf chain |
| **Distributed** | Kubernetes | Controller Loop, Sidecar | Reconciliation + injected proxies |
| | Docker | Builder, Decorator | Multi-stage builds + layer stacking |
| | Kafka | Pub-Sub, Event Sourcing | Partitioned append-only commit log |
| | etcd/ZooKeeper | Observer, Leader Election | Watches + ephemeral nodes |
| | gRPC | Proxy, Adapter | Auto-generated stubs + REST gateway |
| | Istio | Sidecar, Circuit Breaker | Envoy proxy + outlier detection |
| **Messaging** | RabbitMQ | Router, Dead Letter | Exchange types + DLX |
| | Redis | Pub-Sub, Cache-Aside | Channels + app-managed cache |
| | Apache Camel | Pipes and Filters | DSL processing pipelines |
| **Runtimes** | JVM GC | Strategy | Pluggable collector algorithms |
| | Node.js | Reactor | libuv event loop |
| | Go | CSP | Goroutines + typed channels |
| | Python GIL | Monitor | Mutex + condition variable |
| | Rust | RAII | Compile-time enforced Drop |
