---
layout: default
title: "Specification"
parent: "Advanced Patterns"
nav_order: 20
---

# Specification

## Intent
Encapsulate business rules as composable predicate objects that can be combined using boolean logic. Separate the logic for selecting or validating objects from the objects themselves.

## Problem
Business rules for selecting or validating objects often become scattered across queries, conditional statements, and validation logic throughout the codebase. Hardcoding these rules directly into queries or conditionals makes them difficult to reuse, test, or modify. When rules need to be combined or reused in different contexts, code duplication proliferates.

## Real-World Analogy

{: .note }
> Think of a job posting with requirements like "Bachelor's degree OR 5 years experience" AND "Java certification" AND NOT "currently employed by competitor". Each requirement is a separate specification that returns true or false for a candidate. You can compose these specifications using AND, OR, and NOT operators to build complex eligibility rules. Different job postings can reuse the same atomic specifications (degree check, experience check) and combine them differently. Recruiters can test each specification independently before combining them into the final filter.

## When You Need It
- You have complex business rules that need to be reused across queries, validation, and filtering
- You want to compose rules dynamically based on runtime conditions or user input
- You need to test business rules independently of the data access or domain objects they operate on

## UML Class Diagram

```mermaid
classDiagram
    class ISpecification~T~ {
        <<interface>>
        +isSatisfiedBy(candidate: T) bool
        +and(other: ISpecification) ISpecification
        +or(other: ISpecification) ISpecification
        +not() ISpecification
    }

    class ConcreteSpecification~T~ {
        +isSatisfiedBy(candidate: T) bool
    }

    class AndSpecification~T~ {
        -left: ISpecification
        -right: ISpecification
        +isSatisfiedBy(candidate: T) bool
    }

    class OrSpecification~T~ {
        -left: ISpecification
        -right: ISpecification
        +isSatisfiedBy(candidate: T) bool
    }

    class NotSpecification~T~ {
        -spec: ISpecification
        +isSatisfiedBy(candidate: T) bool
    }

    class Client {
        +filterBy(spec: ISpecification)
    }

    ISpecification <|.. ConcreteSpecification
    ISpecification <|.. AndSpecification
    ISpecification <|.. OrSpecification
    ISpecification <|.. NotSpecification
    AndSpecification --> ISpecification : left
    AndSpecification --> ISpecification : right
    OrSpecification --> ISpecification : left
    OrSpecification --> ISpecification : right
    NotSpecification --> ISpecification
    Client --> ISpecification
```

## Sequence Diagram

```mermaid
sequenceDiagram
    participant Client
    participant AgeSpec as AgeSpecification
    participant CountrySpec as CountrySpecification
    participant AndSpec as AndSpecification
    participant Repository
    participant Entity

    Client->>AgeSpec: new AgeSpecification(18)
    Client->>CountrySpec: new CountrySpecification("US")
    Client->>AndSpec: AgeSpec.and(CountrySpec)
    Client->>Repository: findAll(AndSpec)
    Repository->>Entity: for each entity
    Repository->>AndSpec: isSatisfiedBy(entity)
    AndSpec->>AgeSpec: isSatisfiedBy(entity)
    AndSpec->>CountrySpec: isSatisfiedBy(entity)
    AndSpec-->>Repository: return true/false
    Repository-->>Client: return matching entities
```

## Participants
- **ISpecification** — interface defining isSatisfiedBy method and composition operations (and, or, not)
- **ConcreteSpecification** — implements specific business rule by evaluating a candidate object
- **AndSpecification** — composite specification that combines two specs with logical AND
- **OrSpecification** — composite specification that combines two specs with logical OR
- **NotSpecification** — composite specification that negates another spec
- **Client** — uses specifications to filter, validate, or query objects

## How It Works
1. Define atomic specifications that each encapsulate a single business rule
2. Implement isSatisfiedBy to evaluate whether a candidate object meets the rule
3. Compose specifications using and, or, and not methods to build complex criteria
4. Client applies composed specification to filter collections or validate objects
5. Specifications can be reused across different contexts (queries, validation, UI filters)

## Applicability
**Use when:**
- You have complex business rules that are reused across multiple contexts (queries, validation, UI)
- You need to compose rules dynamically at runtime based on user input or configuration
- You want to unit test business rules independently from data access or domain logic

**Don't use when:**
- Your rules are simple and rarely change (specification adds unnecessary abstraction)
- Performance is critical and evaluating composed specifications introduces unacceptable overhead
- Your language has powerful built-in predicate composition (lambdas, LINQ) that suffices

## Trade-offs
**Pros:**
- Encapsulates business rules in testable, reusable objects that can be composed flexibly
- Separates selection logic from domain objects, following Single Responsibility Principle
- Enables dynamic rule composition based on runtime conditions without code changes

**Cons:**
- Adds abstraction overhead for simple rules that could be expressed as inline predicates
- Can lead to proliferation of small specification classes if not managed carefully
- May introduce performance overhead compared to optimized database queries or inline conditionals

## Example Code

### C#

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

// Specification interface
public interface ISpecification<T>
{
    bool IsSatisfiedBy(T candidate);
    ISpecification<T> And(ISpecification<T> other);
    ISpecification<T> Or(ISpecification<T> other);
    ISpecification<T> Not();
}

// Base specification with composition methods
public abstract class Specification<T> : ISpecification<T>
{
    public abstract bool IsSatisfiedBy(T candidate);

    public ISpecification<T> And(ISpecification<T> other) => new AndSpecification<T>(this, other);
    public ISpecification<T> Or(ISpecification<T> other) => new OrSpecification<T>(this, other);
    public ISpecification<T> Not() => new NotSpecification<T>(this);
}

// Composite specifications
public class AndSpecification<T> : Specification<T>
{
    private readonly ISpecification<T> _left, _right;
    public AndSpecification(ISpecification<T> left, ISpecification<T> right)
    { _left = left; _right = right; }
    public override bool IsSatisfiedBy(T candidate) =>
        _left.IsSatisfiedBy(candidate) && _right.IsSatisfiedBy(candidate);
}

public class OrSpecification<T> : Specification<T>
{
    private readonly ISpecification<T> _left, _right;
    public OrSpecification(ISpecification<T> left, ISpecification<T> right)
    { _left = left; _right = right; }
    public override bool IsSatisfiedBy(T candidate) =>
        _left.IsSatisfiedBy(candidate) || _right.IsSatisfiedBy(candidate);
}

public class NotSpecification<T> : Specification<T>
{
    private readonly ISpecification<T> _spec;
    public NotSpecification(ISpecification<T> spec) { _spec = spec; }
    public override bool IsSatisfiedBy(T candidate) => !_spec.IsSatisfiedBy(candidate);
}

// Domain entity
public class Customer
{
    public string Name { get; set; }
    public int Age { get; set; }
    public string Country { get; set; }
    public override string ToString() => $"{Name}, {Age}, {Country}";
}

// Concrete specifications
public class AgeSpecification : Specification<Customer>
{
    private readonly int _minAge;
    public AgeSpecification(int minAge) { _minAge = minAge; }
    public override bool IsSatisfiedBy(Customer customer) => customer.Age >= _minAge;
}

public class CountrySpecification : Specification<Customer>
{
    private readonly string _country;
    public CountrySpecification(string country) { _country = country; }
    public override bool IsSatisfiedBy(Customer customer) => customer.Country == _country;
}

class Program
{
    static void Main()
    {
        var customers = new List<Customer>
        {
            new Customer { Name = "Alice", Age = 25, Country = "USA" },
            new Customer { Name = "Bob", Age = 17, Country = "USA" },
            new Customer { Name = "Charlie", Age = 30, Country = "UK" },
            new Customer { Name = "Diana", Age = 22, Country = "Canada" }
        };

        // Combine specs: (Age >= 18) AND (Country == "USA")
        var adultUSA = new AgeSpecification(18).And(new CountrySpecification("USA"));
        Console.WriteLine("Adult USA customers:");
        foreach (var c in customers.Where(c => adultUSA.IsSatisfiedBy(c)))
            Console.WriteLine($"  {c}");

        // (Age >= 25) OR (Country == "UK")
        var seniorOrUK = new AgeSpecification(25).Or(new CountrySpecification("UK"));
        Console.WriteLine("\nSenior or UK customers:");
        foreach (var c in customers.Where(c => seniorOrUK.IsSatisfiedBy(c)))
            Console.WriteLine($"  {c}");

        // NOT (Country == "USA")
        var notUSA = new CountrySpecification("USA").Not();
        Console.WriteLine("\nNon-USA customers:");
        foreach (var c in customers.Where(c => notUSA.IsSatisfiedBy(c)))
            Console.WriteLine($"  {c}");
    }
}
```

## Runnable Examples

| Language | File |
|----------|------|
| C# | [specification.cs]({% raw %}{{ site.github.repository_url }}{% endraw %}/blob/main/docs/examples/csharp/advanced/specification.cs) |

## Related Patterns
- **Strategy** — Specification can be viewed as a special-case strategy for encapsulating predicates
- **Composite** — AndSpecification, OrSpecification, NotSpecification use Composite to build rule trees
- **Repository** — Specifications are often passed to repositories to encapsulate query criteria
