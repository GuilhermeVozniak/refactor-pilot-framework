# Structural Design Patterns Reference

These patterns explain how to assemble objects and classes into larger structures while
keeping them flexible and efficient. During refactoring, look for tight coupling, God classes,
complex subsystems, and memory-heavy object graphs.

---

## Adapter

**Intent:** Convert the interface of a class into another interface that clients expect.
Lets classes work together that couldn't otherwise because of incompatible interfaces.

**Code smells it solves:**
- Wrapper functions that translate between two APIs
- Data transformation logic duplicated at every integration point
- Third-party library calls wrapped in try/catch with format conversion

**When to apply during refactoring:**
- Integrating a new library that replaces an old one (adapt new API to old interface)
- Unifying multiple data sources with different formats
- Bridging legacy code with modern modules

**Structure:**
```
Target (interface the client expects)
└── request()

Adapter (implements Target, wraps Adaptee)
├── adaptee: Adaptee
└── request() → translates and calls adaptee.specificRequest()

Adaptee (existing class with incompatible interface)
└── specificRequest()
```

**Refactoring steps:**
1. Identify the interface your code expects (Target)
2. Identify the incompatible class or API (Adaptee)
3. Create an adapter class that implements Target and wraps Adaptee
4. Replace direct Adaptee usage with the Adapter
5. Client code now uses only the Target interface

**Example — Before:**
```typescript
// Old analytics API used everywhere
analytics.track('page_view', { page: '/home', userId: user.id });

// New analytics library has different API
newAnalytics.logEvent({
  eventName: 'page_view',
  properties: { page: '/home' },
  user: { identifier: user.id },
});
```

**Example — After:**
```typescript
class AnalyticsAdapter implements Analytics {
  constructor(private newAnalytics: NewAnalyticsLib) {}

  track(event: string, data: Record<string, any>): void {
    const { userId, ...properties } = data;
    this.newAnalytics.logEvent({
      eventName: event,
      properties,
      user: { identifier: userId },
    });
  }
}
// All existing code continues using analytics.track() unchanged
```

---

## Bridge

**Intent:** Separate an abstraction from its implementation so that the two can vary
independently.

**Code smells it solves:**
- Class explosion from combining two dimensions (e.g., Shape × Renderer, Message × Channel)
- Inheritance hierarchies that grow in two directions
- Platform-specific code embedded in business logic

**When to apply during refactoring:**
- You have `EmailNotificationHTML`, `EmailNotificationText`, `SmsNotificationHTML`, etc.
- You need to support multiple backends/platforms for the same abstraction
- You want to swap implementations at runtime

**Structure:**
```
Abstraction
├── implementation: Implementation   ← composition, not inheritance
└── operation()  → delegates to implementation.operationImpl()

Implementation (interface)
└── operationImpl()

ConcreteImplementationA / ConcreteImplementationB
```

**Refactoring steps:**
1. Identify the two independent dimensions of variation
2. Extract an interface for one dimension (the implementation)
3. Make the other dimension (the abstraction) hold a reference to the implementation
4. Replace inheritance with composition

---

## Composite

**Intent:** Compose objects into tree structures to represent part-whole hierarchies.
Let clients treat individual objects and compositions uniformly.

**Code smells it solves:**
- Recursive data structures with `if (isLeaf) ... else (iterate children)` checks everywhere
- Separate handling logic for single items vs. collections
- Tree traversal code duplicated across multiple operations

**When to apply during refactoring:**
- File system operations (files and directories share an interface)
- UI component trees (a container is a component that holds components)
- Organization hierarchies, menu structures, expression trees

**Structure:**
```
Component (interface)
├── operation()
├── add(child)?
└── remove(child)?

Leaf (implements Component)
└── operation()    ← does the actual work

Composite (implements Component)
├── children: Component[]
└── operation()    ← delegates to each child
```

**Refactoring steps:**
1. Identify the leaf and composite objects
2. Extract a common interface (Component) with the shared operation
3. Implement the interface on both leaf and composite classes
4. Composite's operation iterates children and delegates
5. Replace all `instanceof` / type checks in client code with polymorphic calls

---

## Decorator

**Intent:** Attach additional responsibilities to an object dynamically. A flexible
alternative to subclassing for extending functionality.

**Code smells it solves:**
- Subclass explosion: `LoggingService`, `CachingLoggingService`, `AuthLoggingService`...
- Boolean flags that enable/disable features: `doThing(data, { cache: true, log: true, retry: true })`
- Copy-pasted wrapper logic (logging, caching, timing, auth) around core functions

**When to apply during refactoring:**
- Adding cross-cutting concerns (logging, caching, retry, auth, metrics) to existing code
- Needing different combinations of behaviors without a class per combination
- Wrapping third-party objects with additional behavior

**Structure:**
```
Component (interface)
└── operation()

ConcreteComponent
└── operation()    ← core behavior

BaseDecorator (implements Component, wraps Component)
├── wrapped: Component
└── operation() → wrapped.operation()

ConcreteDecoratorA extends BaseDecorator
└── operation() → extra behavior + super.operation()
```

**Example — Before:**
```typescript
async function fetchData(url: string, useCache: boolean, enableLogging: boolean) {
  if (enableLogging) console.log(`Fetching ${url}`);
  if (useCache) {
    const cached = cache.get(url);
    if (cached) return cached;
  }
  const result = await http.get(url);
  if (useCache) cache.set(url, result);
  if (enableLogging) console.log(`Fetched ${url}: ${result.status}`);
  return result;
}
```

**Example — After:**
```typescript
// Core
const baseFetcher: Fetcher = { fetch: (url) => http.get(url) };

// Decorators (compose as needed)
const withLogging = (fetcher: Fetcher): Fetcher => ({
  fetch: async (url) => {
    console.log(`Fetching ${url}`);
    const result = await fetcher.fetch(url);
    console.log(`Fetched ${url}: ${result.status}`);
    return result;
  },
});

const withCache = (fetcher: Fetcher, cache: Cache): Fetcher => ({
  fetch: async (url) => {
    const cached = cache.get(url);
    if (cached) return cached;
    const result = await fetcher.fetch(url);
    cache.set(url, result);
    return result;
  },
});

// Compose
const fetcher = withLogging(withCache(baseFetcher, cache));
```

**Language-idiomatic alternatives:**
- **Python:** `@decorator` syntax is native
- **TypeScript:** Higher-order functions, or TC39 decorators
- **Go:** Middleware pattern (HTTP handler wrapping)
- **Rust:** The newtype pattern + `Deref` trait

---

## Facade

**Intent:** Provide a simplified interface to a complex subsystem.

**Code smells it solves:**
- Client code interacts with 5+ classes/modules to accomplish one task
- Initialization sequences repeated in multiple places
- Business logic tangled with subsystem orchestration

**When to apply during refactoring:**
- Simplifying a legacy API for new consumers
- Hiding complex library initialization behind a simple interface
- Creating a clean boundary between subsystems

**Structure:**
```
Facade
└── simpleOperation()  ← coordinates subsystem classes internally

SubsystemA, SubsystemB, SubsystemC
└── (complex internal APIs hidden behind the Facade)
```

**Refactoring steps:**
1. Identify the repeated sequence of subsystem calls in client code
2. Create a facade class with a single method that performs the sequence
3. Move subsystem initialization into the facade
4. Replace scattered subsystem calls with facade method calls
5. Client code now depends only on the facade, not the subsystem internals

---

## Flyweight

**Intent:** Share common state among many objects to reduce memory usage.

**Code smells it solves:**
- Thousands of similar objects each carrying duplicate data
- Memory profiler shows high allocation for near-identical objects
- Object pools with heavy per-instance overhead

**When to apply during refactoring:**
- Text editors (character objects sharing font/style metadata)
- Game engines (thousands of particles sharing texture/mesh data)
- Document rendering (shared formatting objects)

**Structure:**
```
Flyweight (shared, immutable state — "intrinsic state")
└── operation(extrinsicState)    ← unique state passed in, not stored

FlyweightFactory
└── getFlyweight(sharedState): Flyweight   ← returns cached instance
```

**Refactoring steps:**
1. Identify which fields are shared across many instances (intrinsic) vs. unique (extrinsic)
2. Move intrinsic state into a flyweight class (immutable)
3. Create a factory that caches and reuses flyweight instances
4. Pass extrinsic state as method parameters instead of storing it

**Language-idiomatic alternatives:**
- **JavaScript:** String interning is automatic; object references + `Map` for custom flyweights
- **Python:** `__slots__`, `sys.intern()` for strings
- **Java:** `Integer.valueOf()` caches -128 to 127 (built-in flyweight)

---

## Proxy

**Intent:** Provide a substitute or placeholder for another object to control access to it.

**Code smells it solves:**
- Expensive objects loaded eagerly when they might not be needed
- Access control checks duplicated at every call site
- Logging/monitoring code wrapped around service calls

**When to apply during refactoring:**
- **Lazy loading:** Don't create the real object until first access
- **Access control:** Check permissions before delegating
- **Caching proxy:** Return cached results for repeated calls
- **Logging proxy:** Record all calls for debugging/auditing
- **Remote proxy:** Hide network communication behind a local interface

**Structure:**
```
Subject (interface)
└── request()

RealSubject (implements Subject)
└── request()    ← the actual work

Proxy (implements Subject, holds reference to RealSubject)
└── request()    ← controls access, then delegates to realSubject.request()
```

**Refactoring steps:**
1. Extract an interface from the class you want to proxy
2. Create the proxy class implementing the same interface
3. Add the control logic (lazy init, access check, caching, logging)
4. Delegate to the real subject after the control logic
5. Replace direct references to the real subject with the proxy

**Language-idiomatic alternatives:**
- **JavaScript:** `Proxy` object (ES6 built-in)
- **Python:** `__getattr__` / descriptors / `functools.lru_cache`
- **Go:** Embed the real struct in the proxy struct
- **Rust:** `Deref` trait for transparent proxying
