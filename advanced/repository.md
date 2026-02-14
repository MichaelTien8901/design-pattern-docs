---
layout: default
title: Repository
parent: "Advanced Patterns"
nav_order: 16
---

# Repository

## Intent
Provide a collection-like interface for accessing domain objects, mediating between the domain and data mapping layers to keep domain logic independent of data persistence details.

## Problem
Domain logic needs to retrieve and store objects, but directly accessing databases or data stores couples your business logic to infrastructure concerns. SQL queries, ORM code, and data access logic scatter throughout your domain, making it hard to test and maintain. You need a clean abstraction that lets domain code work with objects as if they're in memory while hiding all persistence complexity.

## Real-World Analogy

{: .note }
> Think of a library catalog system. When you want a book, you don't go into the back rooms searching shelves yourself. You use the catalog to request books by title, author, or topic. The librarian retrieves the book from wherever it's stored—maybe the main stacks, archives, or even another branch. You work with a simple interface while the library handles the complexity of storage, retrieval, and organization behind the scenes.

## When You Need It
- You want to keep domain logic independent of persistence technology
- Your application uses complex queries to retrieve domain objects
- You need to centralize data access logic and make it easier to test domain code without a database

## UML Class Diagram

```mermaid
classDiagram
    class IRepository~T~ {
        <<interface>>
        +findById(id) T
        +findAll() List~T~
        +save(entity) void
        +delete(entity) void
    }

    class CustomerRepository {
        +findById(id) Customer
        +findAll() List~Customer~
        +findByEmail(email) Customer
        +findActiveCustomers() List~Customer~
        +save(customer) void
        +delete(customer) void
    }

    class OrderRepository {
        +findById(id) Order
        +findAll() List~Order~
        +findByCustomerId(customerId) List~Order~
        +findPendingOrders() List~Order~
        +save(order) void
        +delete(order) void
    }

    class Customer {
        <<AggregateRoot>>
        -customerId: String
        -name: String
        -email: String
    }

    class Order {
        <<AggregateRoot>>
        -orderId: String
        -customerId: String
        -items: List~OrderItem~
    }

    class DatabaseContext {
        +executeQuery(query) ResultSet
        +executeCommand(command) void
    }

    IRepository~T~ <|.. CustomerRepository : implements
    IRepository~T~ <|.. OrderRepository : implements
    CustomerRepository --> Customer : manages
    OrderRepository --> Order : manages
    CustomerRepository --> DatabaseContext : uses
    OrderRepository --> DatabaseContext : uses

    note for IRepository~T~ "Collection-like interface\nHides persistence details"
    note for CustomerRepository "Domain-specific queries\nTranslates to/from database"
```

## Participants
- **Repository Interface** — Defines collection-like operations for accessing domain objects
- **Concrete Repository** — Implements the interface with specific data access technology
- **Aggregate Root** — The domain objects managed by the repository
- **Data Mapper** — Translates between domain objects and database representations
- **Specification** — Optional pattern for encapsulating complex query criteria

## How It Works
1. Define a repository interface for each aggregate root with collection-like methods.
2. Implement the repository using your chosen persistence technology (database, ORM, file system).
3. Domain code requests objects through repository methods without knowing about persistence.
4. The repository translates domain queries into data store operations and reconstructs domain objects from stored data.
5. Changes to domain objects are saved back through the repository, which handles all persistence logic.

## Applicability
**Use when:**
- You want domain logic to remain independent of data access technology
- You need to centralize and reuse complex query logic
- Testing domain code without a real database is important

**Don't use when:**
- Your application has simple CRUD operations with no complex domain logic
- The overhead of repositories outweighs the benefits for a small application
- You're using an ORM that already provides sufficient abstraction

## Trade-offs
**Pros:**
- Decouples domain logic from persistence infrastructure
- Centralizes data access logic, making it easier to maintain and optimize
- Simplifies testing by allowing mock repositories in unit tests

**Cons:**
- Adds an abstraction layer that may be unnecessary for simple applications
- Can lead to performance issues if not designed with querying efficiency in mind
- May encourage loading entire aggregates when only partial data is needed

## Related Patterns
- **Aggregate** — Repositories typically manage aggregate roots, not individual entities
- **Factory** — Often works with repositories to create complex domain objects
- **Specification** — Encapsulates query criteria to keep repositories clean and flexible
