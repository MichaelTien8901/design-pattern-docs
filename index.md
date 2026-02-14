---
layout: default
title: Home
nav_order: 1
---

# Design Patterns Guide

Welcome to the **Design Patterns Guide** — a comprehensive visual reference for the 23 Gang of Four (GoF) design patterns. Each pattern includes UML class diagrams and code examples in C#, Delphi, and C++.

## Quick Reference

| Category | Pattern | Intent |
|----------|---------|--------|
| **Creational** | [Factory Method]({% link creational/factory-method.md %}) | Define an interface for creating objects, letting subclasses decide which class to instantiate |
| | [Abstract Factory]({% link creational/abstract-factory.md %}) | Create families of related objects without specifying concrete classes |
| | [Builder]({% link creational/builder.md %}) | Separate construction of a complex object from its representation |
| | [Prototype]({% link creational/prototype.md %}) | Create new objects by cloning an existing instance |
| | [Singleton]({% link creational/singleton.md %}) | Ensure a class has only one instance with a global access point |
| **Structural** | [Adapter]({% link structural/adapter.md %}) | Convert the interface of a class into another interface clients expect |
| | [Bridge]({% link structural/bridge.md %}) | Decouple an abstraction from its implementation |
| | [Composite]({% link structural/composite.md %}) | Compose objects into tree structures for part-whole hierarchies |
| | [Decorator]({% link structural/decorator.md %}) | Attach additional responsibilities to an object dynamically |
| | [Facade]({% link structural/facade.md %}) | Provide a unified interface to a set of interfaces in a subsystem |
| | [Flyweight]({% link structural/flyweight.md %}) | Use sharing to support large numbers of fine-grained objects |
| | [Proxy]({% link structural/proxy.md %}) | Provide a surrogate or placeholder for another object |
| **Behavioral** | [Chain of Responsibility]({% link behavioral/chain-of-responsibility.md %}) | Pass a request along a chain of handlers |
| | [Command]({% link behavioral/command.md %}) | Encapsulate a request as an object |
| | [Iterator]({% link behavioral/iterator.md %}) | Access elements of a collection sequentially without exposing its structure |
| | [Mediator]({% link behavioral/mediator.md %}) | Define an object that encapsulates how a set of objects interact |
| | [Memento]({% link behavioral/memento.md %}) | Capture and restore an object's internal state |
| | [Observer]({% link behavioral/observer.md %}) | Define a one-to-many dependency between objects |
| | [State]({% link behavioral/state.md %}) | Allow an object to alter its behavior when its internal state changes |
| | [Strategy]({% link behavioral/strategy.md %}) | Define a family of algorithms, encapsulate each one, and make them interchangeable |
| | [Template Method]({% link behavioral/template-method.md %}) | Define the skeleton of an algorithm, deferring some steps to subclasses |
| | [Visitor]({% link behavioral/visitor.md %}) | Represent an operation to be performed on elements of an object structure |
| | [Interpreter]({% link behavioral/interpreter.md %}) | Define a grammar representation and an interpreter to evaluate sentences |

## How This Guide Is Organized

The patterns are grouped into three categories following the original GoF classification:

- **[Creational Patterns]({% link creational/index.md %})** — Deal with object creation mechanisms
- **[Structural Patterns]({% link structural/index.md %})** — Deal with object composition and relationships
- **[Behavioral Patterns]({% link behavioral/index.md %})** — Deal with object interaction and responsibility

Each pattern page includes:
1. **Intent** — what the pattern does
2. **Problem** — when to use it
3. **UML Class Diagram** — visual structure using Mermaid
4. **Participants** — classes and their roles
5. **How It Works** — step-by-step explanation
6. **Applicability** — when to use and when not to
7. **Example Code** — implementations in C#, Delphi, and C++
8. **Related Patterns** — connections to other patterns
