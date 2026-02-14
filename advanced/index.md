---
layout: default
title: "Advanced Patterns"
nav_order: 5
has_children: true
---

# Advanced Patterns

Modern design patterns that have emerged since the original Gang of Four book (1994). These patterns address challenges in cloud-native systems, concurrency, distributed data management, domain modeling, and more.

## Cloud Resilience

| Pattern | Intent |
|---------|--------|
| [Circuit Breaker]({% link advanced/circuit-breaker.md %}) | Prevent cascading failures by stopping calls to a failing service |
| [Bulkhead]({% link advanced/bulkhead.md %}) | Isolate components so one failure doesn't sink others |
| [Retry with Backoff]({% link advanced/retry-backoff.md %}) | Handle transient failures by retrying with increasing delays |
| [Sidecar]({% link advanced/sidecar.md %}) | Deploy auxiliary functionality in a companion process |

## Concurrency

| Pattern | Intent |
|---------|--------|
| [Actor Model]({% link advanced/actor-model.md %}) | Encapsulate state in actors that communicate via async messages |
| [Future / Promise]({% link advanced/future-promise.md %}) | Represent a value that will be available asynchronously |
| [Reactor]({% link advanced/reactor.md %}) | Demultiplex and dispatch requests via a single-threaded event loop |
| [Object Pool]({% link advanced/object-pool.md %}) | Reuse pre-allocated objects to avoid expensive creation |

## Data & Messaging

| Pattern | Intent |
|---------|--------|
| [CQRS]({% link advanced/cqrs.md %}) | Separate read and write models for independent optimization |
| [Event Sourcing]({% link advanced/event-sourcing.md %}) | Persist state as a sequence of immutable events |
| [Saga]({% link advanced/saga.md %}) | Coordinate distributed transactions with compensating actions |
| [Publish-Subscribe]({% link advanced/pub-sub.md %}) | Broadcast messages through a broker without sender knowing receivers |

## Domain-Driven Design

| Pattern | Intent |
|---------|--------|
| [Bounded Context]({% link advanced/bounded-context.md %}) | Define explicit boundaries for a domain model |
| [Aggregate]({% link advanced/aggregate.md %}) | Cluster objects into a consistency boundary with a root entity |
| [Anti-Corruption Layer]({% link advanced/anti-corruption-layer.md %}) | Translate between your model and an external system's model |
| [Repository]({% link advanced/repository.md %}) | Mediate between domain and data layers with a collection-like interface |

## Structural & Creational Extras

| Pattern | Intent |
|---------|--------|
| [Dependency Injection]({% link advanced/dependency-injection.md %}) | Supply dependencies from the outside for loose coupling |
| [Null Object]({% link advanced/null-object.md %}) | Provide a do-nothing object to eliminate null checks |
| [MVVM]({% link advanced/mvvm.md %}) | Separate UI from logic via a ViewModel with data binding |
| [Specification]({% link advanced/specification.md %}) | Encapsulate business rules as composable predicate objects |

## Patterns in Practice

See how design patterns manifest in real-world systems:

| Page | Covers |
|------|--------|
| [OS & Networking]({% link advanced/patterns-in-os-and-networking.md %}) | D-Bus, systemd, udev, VFS, TCP/IP, nginx, DNS, TLS |
| [Data & Distributed Systems]({% link advanced/patterns-in-data-and-distributed.md %}) | Databases, Kubernetes, Docker, Kafka, gRPC, Istio, Go, Rust |
| [Hardware Design]({% link advanced/patterns-in-hardware.md %}) | PCIe, AXI, CPU pipelines, cache coherence, DMA, FPGA, secure boot |

## Further Reading

Looking for even more patterns? See the [Further Reading]({% link advanced/further-reading.md %}) page for ~50 additional patterns from enterprise integration, functional programming, game development, and more.
