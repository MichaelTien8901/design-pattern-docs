---
layout: default
title: Pattern Selector
nav_order: 5
---

# Which Pattern Should I Use?

Not sure which design pattern fits your problem? Find your situation below and follow the recommendation.

## By Problem

| Problem / Symptom | Recommended Pattern(s) | Why |
|---|---|---|
| I need to create objects without specifying the exact class | [Factory Method]({% link creational/factory-method.md %}), [Abstract Factory]({% link creational/abstract-factory.md %}) | Let subclasses or factories decide which class to instantiate |
| I need to ensure related objects are used together (e.g., matching UI themes) | [Abstract Factory]({% link creational/abstract-factory.md %}) | Produces families of compatible objects |
| I'm constructing complex objects with many optional parts | [Builder]({% link creational/builder.md %}) | Step-by-step construction with a fluent API |
| I need to create objects similar to existing ones, but creation is expensive | [Prototype]({% link creational/prototype.md %}) | Clone and customize instead of building from scratch |
| I need exactly one instance of a class, globally accessible | [Singleton]({% link creational/singleton.md %}) | Guarantees a single instance (but consider dependency injection first) |
| I need to make two incompatible interfaces work together | [Adapter]({% link structural/adapter.md %}) | Wraps one interface to match another |
| I have two independent dimensions that vary (e.g., shape + renderer) | [Bridge]({% link structural/bridge.md %}) | Separates abstraction from implementation |
| I need to treat individual objects and groups uniformly (tree structures) | [Composite]({% link structural/composite.md %}) | Uniform interface for leaves and branches |
| I want to add behavior to objects dynamically without subclassing | [Decorator]({% link structural/decorator.md %}) | Wraps objects with additional responsibilities |
| A subsystem is too complex — I need a simpler interface | [Facade]({% link structural/facade.md %}) | One simple entry point to a complex subsystem |
| I have thousands of similar objects eating too much memory | [Flyweight]({% link structural/flyweight.md %}) | Shares common state across many objects |
| I need lazy loading, access control, or caching for an object | [Proxy]({% link structural/proxy.md %}) | A stand-in that controls access to the real object |
| A request should be handled by one of several handlers, but I don't know which | [Chain of Responsibility]({% link behavioral/chain-of-responsibility.md %}) | Passes requests along a chain until one handles it |
| I need undo/redo, queuing, or logging of operations | [Command]({% link behavioral/command.md %}) | Encapsulates operations as objects |
| I need to traverse a collection without exposing its internal structure | [Iterator]({% link behavioral/iterator.md %}) | Provides a standard way to walk through elements |
| Many objects need to communicate but I don't want them coupled to each other | [Mediator]({% link behavioral/mediator.md %}) | Centralizes communication through one coordinator |
| I need to save and restore an object's state (snapshots, undo) | [Memento]({% link behavioral/memento.md %}) | Captures state without breaking encapsulation |
| When one object changes, others need to be notified automatically | [Observer]({% link behavioral/observer.md %}) | Subscribe/notify mechanism for event-driven updates |
| An object's behavior changes based on its current state | [State]({% link behavioral/state.md %}) | Encapsulates state-specific behavior in separate classes |
| I need to switch between algorithms or strategies at runtime | [Strategy]({% link behavioral/strategy.md %}) | Pluggable algorithms behind a common interface |
| Several classes follow the same algorithm but differ in specific steps | [Template Method]({% link behavioral/template-method.md %}) | Defines the skeleton; subclasses fill in the details |
| I need to add new operations to a class hierarchy without modifying it | [Visitor]({% link behavioral/visitor.md %}) | Separates operations from the objects they act on |
| I need to evaluate or parse expressions in a simple grammar | [Interpreter]({% link behavioral/interpreter.md %}) | Represents grammar rules as classes |

## By Category

### "I need to create objects differently"
Start with **Creational Patterns**: [Factory Method]({% link creational/factory-method.md %}), [Abstract Factory]({% link creational/abstract-factory.md %}), [Builder]({% link creational/builder.md %}), [Prototype]({% link creational/prototype.md %}), [Singleton]({% link creational/singleton.md %})

### "I need to organize or connect classes better"
Start with **Structural Patterns**: [Adapter]({% link structural/adapter.md %}), [Bridge]({% link structural/bridge.md %}), [Composite]({% link structural/composite.md %}), [Decorator]({% link structural/decorator.md %}), [Facade]({% link structural/facade.md %}), [Flyweight]({% link structural/flyweight.md %}), [Proxy]({% link structural/proxy.md %})

### "I need to manage how objects communicate or behave"
Start with **Behavioral Patterns**: [Chain of Responsibility]({% link behavioral/chain-of-responsibility.md %}), [Command]({% link behavioral/command.md %}), [Interpreter]({% link behavioral/interpreter.md %}), [Iterator]({% link behavioral/iterator.md %}), [Mediator]({% link behavioral/mediator.md %}), [Memento]({% link behavioral/memento.md %}), [Observer]({% link behavioral/observer.md %}), [State]({% link behavioral/state.md %}), [Strategy]({% link behavioral/strategy.md %}), [Template Method]({% link behavioral/template-method.md %}), [Visitor]({% link behavioral/visitor.md %})

## Common Confusions

| "Should I use..." | "...or this?" | How to decide |
|---|---|---|
| Strategy | State | **Strategy** swaps algorithms; **State** changes behavior based on internal state. If the object "becomes something different," use State. |
| Factory Method | Abstract Factory | **Factory Method** uses inheritance (one product); **Abstract Factory** uses composition (families of products). |
| Decorator | Proxy | **Decorator** adds behavior; **Proxy** controls access. If you're wrapping to enhance, use Decorator. If you're wrapping to restrict or defer, use Proxy. |
| Adapter | Facade | **Adapter** makes one interface compatible with another; **Facade** simplifies an entire subsystem. |
| Command | Strategy | **Command** encapsulates a request (what to do); **Strategy** encapsulates an algorithm (how to do it). |
| Observer | Mediator | **Observer** is one-to-many broadcast; **Mediator** is many-to-many coordination through a central hub. |
