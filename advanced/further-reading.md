---
layout: default
title: "Further Reading"
parent: "Advanced Patterns"
nav_order: 21
---

# Further Reading

Additional design patterns organized by category. Each entry includes a brief description and a link to learn more.

## Architectural Patterns
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Microservices | Decompose app into independently deployable services | [microservices.io](https://microservices.io) |
| Service Mesh | Infrastructure layer for service-to-service communication (Istio, Linkerd) | [Istio Docs](https://istio.io/latest/docs/concepts/what-is-istio/) |
| Event-Driven Architecture | Components communicate via async events | [Microsoft Architecture Guide](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) |
| Hexagonal / Ports & Adapters | Isolate core logic from external concerns | [Alistair Cockburn](https://alistair.cockburn.us/hexagonal-architecture/) |
| Strangler Fig | Incrementally replace legacy systems | [Martin Fowler](https://martinfowler.com/bliki/StranglerFigApplication.html) |
| Backends for Frontends (BFF) | Separate backend per frontend type | [Sam Newman](https://samnewman.io/patterns/architectural/bff/) |

## Cloud-Native Extras
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Ambassador | Proxy alongside service for cross-cutting concerns | [Microsoft Architecture Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/ambassador) |
| API Gateway | Single entry point routing to backend services | [microservices.io](https://microservices.io/patterns/apigateway.html) |

## Enterprise Application (Fowler/PoEAA)
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Unit of Work | Track changes and write atomically | [Martin Fowler](https://martinfowler.com/eaaCatalog/unitOfWork.html) |
| Data Mapper | Transfer data between objects and DB independently | [Martin Fowler](https://martinfowler.com/eaaCatalog/dataMapper.html) |
| Active Record | Object wraps DB row with domain logic | [Martin Fowler](https://martinfowler.com/eaaCatalog/activeRecord.html) |
| Identity Map | Ensure each object loaded only once | [Martin Fowler](https://martinfowler.com/eaaCatalog/identityMap.html) |
| Service Layer | Application boundary with available operations | [Martin Fowler](https://martinfowler.com/eaaCatalog/serviceLayer.html) |
| Domain Model | Object model incorporating behavior and data | [Martin Fowler](https://martinfowler.com/eaaCatalog/domainModel.html) |

## Enterprise Integration (Hohpe & Woolf)
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Message Channel | Connect apps via messaging channel | [Enterprise Integration Patterns](https://enterpriseintegrationpatterns.com/patterns/messaging/MessageChannel.html) |
| Message Router | Route messages based on rules | [Enterprise Integration Patterns](https://enterpriseintegrationpatterns.com/patterns/messaging/MessageRouter.html) |
| Message Filter | Filter uninteresting messages | [Enterprise Integration Patterns](https://enterpriseintegrationpatterns.com/patterns/messaging/Filter.html) |
| Dead Letter Channel | Route unprocessable messages | [Enterprise Integration Patterns](https://enterpriseintegrationpatterns.com/patterns/messaging/DeadLetterChannel.html) |
| Idempotent Receiver | Handle duplicate messages safely | [Enterprise Integration Patterns](https://enterpriseintegrationpatterns.com/patterns/messaging/IdempotentReceiver.html) |
| Content-Based Router | Route by message content | [Enterprise Integration Patterns](https://enterpriseintegrationpatterns.com/patterns/messaging/ContentBasedRouter.html) |
| Pipes and Filters | Chain independent processing stages | [Enterprise Integration Patterns](https://enterpriseintegrationpatterns.com/patterns/messaging/PipesAndFilters.html) |

## DDD Extras
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Domain Event | Capture domain happenings as first-class objects | [Martin Fowler](https://martinfowler.com/eaaDev/DomainEvent.html) |
| Value Object | Immutable concept defined by attributes | [Martin Fowler](https://martinfowler.com/bliki/ValueObject.html) |

## Concurrency Extras
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Active Object | Decouple invocation from execution via queue | [Wikipedia](https://en.wikipedia.org/wiki/Active_object) |
| Thread Pool | Pool of pre-created worker threads | [Wikipedia](https://en.wikipedia.org/wiki/Thread_pool) |
| Producer-Consumer | Decouple producers/consumers with shared buffer | [Wikipedia](https://en.wikipedia.org/wiki/Producer%E2%80%93consumer_problem) |
| Read-Write Lock | Concurrent reads, exclusive writes | [Wikipedia](https://en.wikipedia.org/wiki/Readers%E2%80%93writer_lock) |
| Proactor | Async I/O completion dispatching | [Wikipedia](https://en.wikipedia.org/wiki/Proactor_pattern) |
| Half-Sync/Half-Async | Separate sync and async processing layers | [Wikipedia](https://en.wikipedia.org/wiki/Half-sync/half-async) |
| Leader/Followers | Thread pool taking turns as event leader | [Wikipedia](https://en.wikipedia.org/wiki/Leader/followers_pattern) |

## Functional Programming Patterns
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Monad | Encapsulate computations with context, compose via bind | [Wikipedia](https://en.wikipedia.org/wiki/Monad_(functional_programming)) |
| Option/Maybe | Typed presence/absence without null | [Wikipedia](https://en.wikipedia.org/wiki/Option_type) |
| Either/Result | Typed success/failure without exceptions | [Wikipedia](https://en.wikipedia.org/wiki/Result_type) |
| Functor | Apply function over wrapped value | [Wikipedia](https://en.wikipedia.org/wiki/Functor_(functional_programming)) |
| Lens | Composable immutable getters/setters for nested data | [Wikipedia](https://en.wikipedia.org/wiki/Optics_(computer_science)) |
| Higher-Order Function | Functions taking/returning functions | [Wikipedia](https://en.wikipedia.org/wiki/Higher-order_function) |
| Algebraic Data Types | Sum types + product types with pattern matching | [Wikipedia](https://en.wikipedia.org/wiki/Algebraic_data_type) |

## Game Programming Patterns (Nystrom)
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Game Loop | Continuous loop decoupling input, update, render | [Game Programming Patterns](https://gameprogrammingpatterns.com/game-loop.html) |
| Entity-Component-System | Compose entities from reusable components | [Game Programming Patterns](https://gameprogrammingpatterns.com/component.html) |
| Update Method | Per-object update called each frame | [Game Programming Patterns](https://gameprogrammingpatterns.com/update-method.html) |
| Double Buffer | Swap two buffers to avoid tearing | [Game Programming Patterns](https://gameprogrammingpatterns.com/double-buffer.html) |
| Spatial Partition | Organize objects by location for efficient queries | [Game Programming Patterns](https://gameprogrammingpatterns.com/spatial-partition.html) |
| Type Object | Define types as data, not code | [Game Programming Patterns](https://gameprogrammingpatterns.com/type-object.html) |
| Bytecode | Encode behavior in portable instruction set | [Game Programming Patterns](https://gameprogrammingpatterns.com/bytecode.html) |

## UI/Frontend Patterns
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Flux/Redux | Unidirectional data flow with single store | [Redux Docs](https://redux.js.org/understanding/thinking-in-redux/motivation) |
| Model-View-Presenter (MVP) | Presenter handles presentation logic | [Wikipedia](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter) |

## Post-GoF Extras
| Pattern | Description | Reference |
|---------|-------------|-----------|
| Multiton | Map of named singleton instances | [Wikipedia](https://en.wikipedia.org/wiki/Multiton_pattern) |
| Lazy Initialization | Defer creation until first use | [Wikipedia](https://en.wikipedia.org/wiki/Lazy_initialization) |
