# Behavioral Design Patterns Reference

These patterns are concerned with algorithms and the assignment of responsibilities between
objects. During refactoring, look for complex conditionals, tight event coupling, duplicated
algorithm structures, and objects that know too much about each other.

---

## Chain of Responsibility

**Intent:** Pass a request along a chain of handlers. Each handler decides either to process
the request or to pass it to the next handler in the chain.

**Code smells it solves:**
- Nested `if/else if/else if` chains for request processing
- Single function doing validation, auth, logging, and business logic
- Adding a new processing step requires modifying existing code

**When to apply during refactoring:**
- HTTP middleware stacks (auth → rate limit → validate → handle)
- Input validation chains
- Event processing pipelines
- Log level filtering

**Structure:**
```
Handler (interface)
├── setNext(handler): Handler
└── handle(request): Result

ConcreteHandlerA → ConcreteHandlerB → ConcreteHandlerC
Each either handles the request or passes it to next
```

**Refactoring steps:**
1. Identify the chain of checks/processing steps in the monolithic function
2. Extract each step into a handler class implementing a common interface
3. Each handler has a `next` reference and delegates if it can't handle
4. Compose the chain at configuration time
5. Client code sends the request to the first handler only

**Example — Before:**
```typescript
function processRequest(req: Request): Response {
  // Auth check
  if (!req.headers.auth) return unauthorized();
  if (!isValidToken(req.headers.auth)) return forbidden();

  // Rate limiting
  if (rateLimiter.isExceeded(req.ip)) return tooManyRequests();

  // Validation
  if (!req.body.name) return badRequest('name required');
  if (!req.body.email) return badRequest('email required');

  // Business logic
  return createUser(req.body);
}
```

**Example — After:**
```typescript
const pipeline = new AuthHandler()
  .setNext(new RateLimitHandler())
  .setNext(new ValidationHandler(['name', 'email']))
  .setNext(new CreateUserHandler());

function processRequest(req: Request): Response {
  return pipeline.handle(req);
}
// Adding a new step: just insert a handler into the chain
```

---

## Command

**Intent:** Encapsulate a request as an object, thereby letting you parameterize clients
with different requests, queue or log requests, and support undoable operations.

**Code smells it solves:**
- UI callbacks with complex inline logic
- No undo/redo capability in an editor or form
- Operations that need to be queued, scheduled, or replayed
- Transaction logging that duplicates business logic

**When to apply during refactoring:**
- Adding undo/redo to an application
- Implementing a task queue or job scheduler
- Decoupling UI actions from business logic
- Creating macro/batch operations from individual actions

**Structure:**
```
Command (interface)
├── execute()
└── undo()  (optional)

ConcreteCommand
├── receiver: Receiver
├── execute()  → calls receiver methods
└── undo()     → reverses the action

Invoker
└── executeCommand(command)  ← stores history for undo

Receiver
└── (the actual business logic)
```

**Refactoring steps:**
1. Identify the action that needs to be encapsulated
2. Create a command interface with `execute()` (and optionally `undo()`)
3. Implement concrete commands that hold the receiver and parameters
4. Replace direct method calls with command creation and execution
5. Add an invoker that manages command history for undo

---

## Iterator

**Intent:** Provide a way to access elements of an aggregate object sequentially without
exposing its underlying representation.

**Code smells it solves:**
- Client code depends on the internal structure of a collection
- Same traversal logic duplicated for different collection types
- Complex data structures (trees, graphs) with manual traversal code

**When to apply during refactoring:**
- Unifying traversal across different data structures
- Hiding internal collection representation from consumers
- Supporting multiple traversal strategies (depth-first, breadth-first, filtered)

**Language-idiomatic alternatives (prefer these):**
- **JavaScript/TypeScript:** `Symbol.iterator` protocol, generators (`function*`)
- **Python:** `__iter__` / `__next__` protocol, generators (`yield`)
- **Go:** Range over channels, or iterator functions (Go 1.23+)
- **Rust:** `Iterator` trait (`.iter()`, `.map()`, `.filter()`)
- **Java:** `Iterable<T>` / `Iterator<T>`, Streams API

In modern languages, you rarely need to implement Iterator as a class — use the language's
iteration protocol instead.

**Refactoring steps:**
1. Identify manual index-based loops over custom data structures
2. Implement the language's iterator protocol on the data structure
3. Replace manual loops with `for...of`, `for...in`, or equivalent
4. If multiple traversal orders are needed, create named iterator methods

---

## Mediator

**Intent:** Define an object that encapsulates how a set of objects interact. Promotes loose
coupling by keeping objects from referring to each other explicitly.

**Code smells it solves:**
- Classes that hold references to many other classes
- Changing one class requires changes in many others
- Complex web of direct communications between objects
- God class that coordinates everything

**When to apply during refactoring:**
- UI components that directly update each other (form field A disables button B, shows panel C)
- Chat rooms, event buses, or notification systems
- Workflow orchestration where steps depend on each other

**Structure:**
```
Mediator (interface)
└── notify(sender, event)

ConcreteMediator
├── componentA, componentB, componentC
└── notify(sender, event)  → coordinates the reaction

Component
├── mediator: Mediator
└── (notifies mediator instead of talking to other components)
```

**Refactoring steps:**
1. Identify the tightly coupled classes and their interactions
2. Create a mediator interface with a `notify()` method
3. Move coordination logic from the coupled classes into the mediator
4. Each class only knows about the mediator, not about other classes
5. Classes notify the mediator of events; mediator decides what happens

**Language-idiomatic alternatives:**
- **JavaScript:** Event emitter / EventTarget
- **React:** Lift state up + context
- **Redux/Zustand/Pinia:** Centralized state management is a mediator

---

## Memento

**Intent:** Capture and externalize an object's internal state so that the object can be
restored to this state later, without violating encapsulation.

**Code smells it solves:**
- Manual state snapshots with exposed internals
- Undo implementations that store full object copies
- State history that breaks encapsulation

**When to apply during refactoring:**
- Adding undo/redo (pairs with Command pattern)
- Implementing save/load for application state
- Checkpoint/rollback for long-running operations
- Form state management (save draft, restore previous values)

**Structure:**
```
Originator (the object whose state you want to save)
├── save(): Memento      ← creates a snapshot
└── restore(memento)     ← restores from snapshot

Memento (opaque state container)
└── (stores internal state — not accessible to others)

Caretaker (manages history)
└── mementos: Memento[]  ← stores snapshots without peeking inside
```

**Refactoring steps:**
1. Identify the state that needs to be saved/restored
2. Create a memento class that stores a snapshot of that state
3. Add `save()` and `restore()` methods to the originator
4. Create a caretaker that manages the memento stack
5. Wire undo/redo to push/pop from the caretaker

---

## Observer

**Intent:** Define a one-to-many dependency between objects so that when one object changes
state, all its dependents are notified automatically.

**Code smells it solves:**
- Polling for changes (`setInterval(() => checkForUpdates(), 1000)`)
- Manual notification calls scattered after every state change
- Tight coupling between data producers and consumers
- UI not updating when underlying data changes

**When to apply during refactoring:**
- Event systems, pub/sub messaging
- Reactive UI updates (model changes → view updates)
- Plugin/extension systems that react to core events
- Log aggregation, metrics collection

**Structure:**
```
Subject (Observable)
├── observers: Observer[]
├── subscribe(observer)
├── unsubscribe(observer)
└── notify()  ← iterates observers and calls update()

Observer (interface)
└── update(data)
```

**Example — Before:**
```typescript
class ShoppingCart {
  addItem(item: Item) {
    this.items.push(item);
    // Tightly coupled to every consumer
    uiWidget.updateCount(this.items.length);
    analyticsService.trackAdd(item);
    inventoryService.reserveItem(item);
    localStorage.setItem('cart', JSON.stringify(this.items));
  }
}
```

**Example — After:**
```typescript
class ShoppingCart extends EventEmitter {
  addItem(item: Item) {
    this.items.push(item);
    this.emit('itemAdded', { item, cart: this });
  }
}

// Subscribers register independently
cart.on('itemAdded', ({ cart }) => uiWidget.updateCount(cart.items.length));
cart.on('itemAdded', ({ item }) => analyticsService.trackAdd(item));
cart.on('itemAdded', ({ item }) => inventoryService.reserveItem(item));
cart.on('itemAdded', ({ cart }) => persist(cart));
```

**Language-idiomatic alternatives:**
- **JavaScript:** `EventTarget`/`EventEmitter`, RxJS Observables
- **Python:** Signals (Django), `blinker`, or `asyncio` events
- **Go:** Channels
- **Rust:** Channels (`mpsc`), or callback registration
- **React:** `useEffect` with dependencies, Context, state management libraries

---

## State

**Intent:** Allow an object to alter its behavior when its internal state changes.
The object will appear to change its class.

**Code smells it solves:**
- Giant `switch` or `if/else` on a status field in every method
- Boolean flags that control behavior: `if (isEditing && !isLocked && hasPermission)`
- State transitions scattered and error-prone

**When to apply during refactoring:**
- Document workflow (draft → review → approved → published)
- UI component modes (viewing, editing, loading, error)
- Connection states (disconnected, connecting, connected, error)
- Game entity behavior (idle, moving, attacking, dead)

**Structure:**
```
Context
├── state: State
├── setState(state)
└── request()  → delegates to state.handle(this)

State (interface)
└── handle(context)

ConcreteStateA / ConcreteStateB
└── handle(context)  ← behavior specific to this state
```

**Example — Before:**
```typescript
class Document {
  publish() {
    if (this.state === 'draft') {
      if (this.currentUser.role === 'admin') {
        this.state = 'published';
      } else {
        this.state = 'moderation';
      }
    } else if (this.state === 'moderation') {
      if (this.currentUser.role === 'admin') {
        this.state = 'published';
      }
    } else if (this.state === 'published') {
      // already published, no-op
    }
  }
}
```

**Example — After:**
```typescript
interface DocumentState {
  publish(doc: Document, user: User): void;
}

class DraftState implements DocumentState {
  publish(doc: Document, user: User) {
    doc.setState(user.role === 'admin' ? new PublishedState() : new ModerationState());
  }
}

class ModerationState implements DocumentState {
  publish(doc: Document, user: User) {
    if (user.role === 'admin') doc.setState(new PublishedState());
  }
}

class PublishedState implements DocumentState {
  publish() { /* already published */ }
}
```

**Refactoring steps:**
1. Identify all states and the transitions between them
2. Draw a state diagram to visualize the machine
3. Create a state interface with methods for each action
4. Implement concrete state classes
5. Replace conditionals with delegation to the current state object
6. State objects handle transitions by calling `context.setState()`

---

## Strategy

**Intent:** Define a family of algorithms, encapsulate each one, and make them
interchangeable. Strategy lets the algorithm vary independently from clients that use it.

**Code smells it solves:**
- `if/else` or `switch` choosing an algorithm at the start of a function
- Duplicated methods that differ only in the core algorithm step
- Hard to add new algorithms without modifying existing code

**When to apply during refactoring:**
- Sorting with different comparators
- Payment processing with multiple providers
- Validation with different rule sets
- Routing with different strategies (fastest, shortest, cheapest)
- Compression, encryption, or serialization with multiple algorithms

**Structure:**
```
Context
├── strategy: Strategy
└── doWork()  → delegates to strategy.execute()

Strategy (interface)
└── execute(data): Result

ConcreteStrategyA / ConcreteStrategyB
└── execute(data): Result
```

**Example — Before:**
```typescript
function calculateShipping(order: Order, method: string): number {
  if (method === 'standard') {
    return order.weight * 1.5;
  } else if (method === 'express') {
    return order.weight * 3.0 + 5.0;
  } else if (method === 'overnight') {
    return order.weight * 5.0 + 15.0;
  }
  throw new Error(`Unknown shipping method: ${method}`);
}
```

**Example — After:**
```typescript
type ShippingStrategy = (order: Order) => number;

const shippingStrategies: Record<string, ShippingStrategy> = {
  standard:  (order) => order.weight * 1.5,
  express:   (order) => order.weight * 3.0 + 5.0,
  overnight: (order) => order.weight * 5.0 + 15.0,
};

function calculateShipping(order: Order, method: string): number {
  const strategy = shippingStrategies[method];
  if (!strategy) throw new Error(`Unknown shipping method: ${method}`);
  return strategy(order);
}
```

**Language-idiomatic alternatives:**
- **JavaScript/TypeScript/Python:** First-class functions — just pass a function, no class needed
- **Go:** Function types (`type Strategy func(data) result`)
- **Rust:** Closures or trait objects (`Box<dyn Strategy>`)

---

## Template Method

**Intent:** Define the skeleton of an algorithm in a method, deferring some steps to
subclasses. Lets subclasses redefine certain steps without changing the algorithm's structure.

**Code smells it solves:**
- Multiple functions with the same overall structure but different details
- Copy-pasted "framework" code with small variations
- Hooks or callbacks embedded in a rigid sequence

**When to apply during refactoring:**
- Data import pipelines (read → validate → transform → save) with different formats
- Test setup/teardown sequences with varying test bodies
- Document generation (header → content → footer) with different content types
- Build processes with language-specific compilation steps

**Structure:**
```
AbstractClass
├── templateMethod()     ← final: defines the algorithm skeleton
├── step1()              ← concrete: shared across all subclasses
├── step2()              ← abstract: subclasses must implement
├── step3()              ← abstract: subclasses must implement
└── hook()               ← optional: subclasses can override

ConcreteClassA / ConcreteClassB
├── step2()  ← different implementation per subclass
└── step3()  ← different implementation per subclass
```

**Refactoring steps:**
1. Identify duplicated algorithm structures across functions/classes
2. Extract the common skeleton into a template method
3. Identify the varying steps
4. Make varying steps abstract or overridable
5. Create concrete implementations for each variant
6. Delete the duplicated original functions

**Language-idiomatic alternatives:**
- **JavaScript/TypeScript:** Higher-order functions that accept step functions as callbacks
- **Python:** Abstract base classes (`abc.ABC`), or just pass functions
- **Go:** Function parameters or interfaces for the varying steps

---

## Visitor

**Intent:** Represent an operation to be performed on the elements of an object structure.
Visitor lets you define a new operation without changing the classes of the elements.

**Code smells it solves:**
- Adding a new operation requires modifying every element class
- `instanceof` / type switch chains for performing different operations on different types
- Operations on a hierarchy are scattered across the element classes

**When to apply during refactoring:**
- AST processing (type checker, optimizer, code generator as separate visitors)
- Document export (export to PDF, HTML, Markdown without changing document classes)
- Tax/pricing calculations across different product types
- Serialization of heterogeneous object graphs

**Structure:**
```
Visitor (interface)
├── visitElementA(element: ElementA)
├── visitElementB(element: ElementB)
└── visitElementC(element: ElementC)

Element (interface)
└── accept(visitor: Visitor)  ← calls visitor.visitElementX(this)

ConcreteVisitor (implements Visitor)
└── visitElementA, visitElementB, ...  ← operation logic per element type
```

**Refactoring steps:**
1. Define a visitor interface with a `visit` method per element type
2. Add an `accept(visitor)` method to each element class (this is the only change to elements)
3. Implement concrete visitors for each operation
4. Replace type-switch operations with visitor dispatch
5. New operations = new visitor class, no element changes needed

**Trade-off:** Adding new element types requires updating all visitors. Use Visitor when
operations change frequently but the element types are stable.

**Language-idiomatic alternatives:**
- **TypeScript:** Discriminated unions + exhaustive switch (often simpler)
- **Python:** `functools.singledispatch` or `match` statement (3.10+)
- **Rust:** `enum` + `match` (exhaustive pattern matching)
- **Kotlin:** `sealed class` + `when` expression
