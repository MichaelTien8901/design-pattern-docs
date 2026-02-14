---
layout: default
title: Circuit Breaker
parent: "Advanced Patterns"
nav_order: 1
---

# Circuit Breaker

## Intent
Prevent cascading failures in distributed systems by automatically stopping calls to a failing service and allowing it time to recover.

## Problem
In distributed systems, when a service becomes unresponsive or slow, clients continuing to make requests can exhaust resources and cause cascading failures throughout the system. Without a mechanism to detect and halt these failing calls, the entire system can become unstable as threads pile up waiting for timeouts.

## Real-World Analogy

{: .note }
> Think of an electrical circuit breaker in your home. When too much current flows through a circuit (perhaps from a short circuit or overload), the breaker automatically trips and cuts off power to protect your wiring from overheating and causing a fire. The breaker stays open until someone manually resets it, ensuring the problem has been addressed. Similarly, a Circuit Breaker pattern monitors service calls and "trips" when failures exceed a threshold, preventing further damage to your system.

## When You Need It
- Your application depends on remote services that may fail or become temporarily unavailable
- You want to fail fast rather than waiting for timeouts when a service is known to be down
- You need to prevent resource exhaustion from repeated calls to failing services

## UML Class Diagram

```mermaid
classDiagram
    class Client {
        +makeRequest()
    }

    class CircuitBreaker {
        -state: State
        -failureCount: int
        -failureThreshold: int
        -timeout: duration
        +call(operation)
        -recordSuccess()
        -recordFailure()
        -trip()
        -reset()
        -attemptReset()
    }

    class State {
        <<enumeration>>
        CLOSED
        OPEN
        HALF_OPEN
    }

    class Service {
        +execute()
    }

    Client --> CircuitBreaker
    CircuitBreaker --> State
    CircuitBreaker --> Service
```

## Participants
- **Client** — makes requests through the circuit breaker
- **CircuitBreaker** — monitors calls to the service and manages state transitions
- **State** — represents the current state (Closed, Open, or Half-Open)
- **Service** — the protected remote service being called

## How It Works
1. In the **Closed** state, the circuit breaker allows all calls through to the service while monitoring for failures
2. When failures exceed the configured threshold, the circuit breaker transitions to the **Open** state
3. In the **Open** state, all calls fail immediately without attempting to contact the service, allowing it time to recover
4. After a timeout period, the circuit breaker moves to **Half-Open** state and allows a limited number of test requests through
5. If test requests succeed, the circuit breaker resets to **Closed**; if they fail, it returns to **Open**

## Applicability
**Use when:**
- You make calls to external services that may be unreliable or have variable latency
- You want to prevent cascading failures in a microservices architecture
- You need to provide fallback behavior when services are unavailable

**Don't use when:**
- Calling local in-process operations that don't involve network or resource contention
- The service being called has its own sophisticated retry and failure handling
- You need every request to be attempted regardless of previous failures

## Trade-offs
**Pros:**
- Prevents cascading failures by failing fast when a service is known to be down
- Allows failing services time to recover without being overwhelmed by requests
- Provides visibility into service health through state monitoring

**Cons:**
- Adds complexity and latency overhead to every service call
- Requires careful tuning of thresholds and timeouts to avoid false positives
- May reject valid requests if the circuit trips due to temporary network issues

## Related Patterns
- **Retry with Backoff** — often used together; circuit breaker prevents retries when service is known to be down
- **Bulkhead** — provides isolation to contain failures; complements circuit breaker's failure detection
- **Timeout** — circuit breaker relies on timeouts to detect slow or hanging calls
- **Fallback** — provides alternative behavior when circuit is open
