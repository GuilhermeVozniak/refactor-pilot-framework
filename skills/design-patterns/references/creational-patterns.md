# Creational Design Patterns Reference

These patterns provide flexible object creation mechanisms. During refactoring, look for
scattered `new` keywords, complex constructors, and duplicated initialization logic.

---

## Factory Method

**Intent:** Define an interface for creating an object, but let subclasses decide which class
to instantiate.

**Code smells it solves:**
- `if/else` or `switch` statements that decide which class to instantiate
- Scattered `new ClassName()` calls that change when a new type is added
- Constructor logic duplicated across multiple call sites

**When to apply during refactoring:**
- You're adding a new type and realize you have to update conditionals in 5 places
- Tests need to substitute different implementations
- The creation logic is more complex than just calling a constructor

**Structure:**
```
Creator (abstract)
├── factoryMethod(): Product    ← subclasses override this
└── someOperation()             ← uses factoryMethod() internally

ConcreteCreatorA
└── factoryMethod(): ConcreteProductA

ConcreteCreatorB
└── factoryMethod(): ConcreteProductB
```

**Refactoring steps:**
1. Identify the constructor calls scattered through the code
2. Extract an interface/abstract class for the products being created
3. Create a factory method that returns the interface type
4. Move the creation logic into concrete creator classes
5. Replace all `new ConcreteProduct()` calls with `creator.factoryMethod()`
6. Run tests after each step

**Language-idiomatic alternatives:**
- **TypeScript/JavaScript:** A simple factory function (no class hierarchy needed)
- **Python:** Class methods as alternative constructors (`@classmethod`)
- **Go:** Constructor functions (`NewXxx()` convention)
- **Rust:** Associated functions and the `From`/`Into` traits

**Example — Before:**
```typescript
function createNotification(type: string, message: string) {
  if (type === 'email') {
    return new EmailNotification(message, smtpConfig);
  } else if (type === 'sms') {
    return new SmsNotification(message, twilioConfig);
  } else if (type === 'push') {
    return new PushNotification(message, firebaseConfig);
  }
  throw new Error(`Unknown type: ${type}`);
}
```

**Example — After:**
```typescript
interface Notification {
  send(): Promise<void>;
}

// Factory function (idiomatic TS — no class hierarchy needed)
const notificationFactories: Record<string, (msg: string) => Notification> = {
  email: (msg) => new EmailNotification(msg, smtpConfig),
  sms:   (msg) => new SmsNotification(msg, twilioConfig),
  push:  (msg) => new PushNotification(msg, firebaseConfig),
};

function createNotification(type: string, message: string): Notification {
  const factory = notificationFactories[type];
  if (!factory) throw new Error(`Unknown type: ${type}`);
  return factory(message);
}
```

**Extensibility:** To add a new notification type, add one entry to the map. No conditionals to update.

---

## Abstract Factory

**Intent:** Provide an interface for creating families of related objects without specifying
their concrete classes.

**Code smells it solves:**
- Multiple factory methods that always create objects from the same "family"
- Platform-specific code mixed with business logic (`if (platform === 'ios') ...`)
- Inconsistent object families (mixing light theme buttons with dark theme dialogs)

**When to apply during refactoring:**
- You have related objects that must be used together (UI themes, database drivers, OS services)
- Platform or environment-specific creation logic is scattered
- You're introducing multi-tenant or multi-brand support

**Structure:**
```
AbstractFactory
├── createProductA(): AbstractProductA
└── createProductB(): AbstractProductB

ConcreteFactory1 (e.g., LightThemeFactory)
├── createProductA(): LightButton
└── createProductB(): LightDialog

ConcreteFactory2 (e.g., DarkThemeFactory)
├── createProductA(): DarkButton
└── createProductB(): DarkDialog
```

**Refactoring steps:**
1. Identify groups of related objects that are created together
2. Extract abstract interfaces for each product type
3. Create a factory interface with a method for each product
4. Implement concrete factories for each family
5. Pass the factory to client code via dependency injection
6. Remove all direct `new` calls for family members from client code

**Language-idiomatic alternatives:**
- **TypeScript:** Object literal implementing a factory interface
- **Python:** Module-level factory functions or a factory dict
- **Go:** Interface + struct implementing it
- **Rust:** Trait with associated types

---

## Builder

**Intent:** Construct complex objects step by step, allowing different representations from
the same construction process.

**Code smells it solves:**
- Constructor with 5+ parameters (many optional)
- Object creation requires a specific sequence of steps
- Same construction logic duplicated to create slightly different variants
- Complex configuration objects assembled inline

**When to apply during refactoring:**
- You see `new Config(true, false, null, 'abc', undefined, 3, true)` — positional args nightmare
- Object construction spans 20+ lines with conditional steps
- Test setup is painful because of complex object creation

**Structure:**
```
Builder
├── setPartA(value)
├── setPartB(value)
├── setPartC(value)
└── build(): Product

Director (optional)
└── construct(builder): coordinates the build sequence
```

**Refactoring steps:**
1. Identify the complex constructor or creation sequence
2. Create a builder class with methods for each configurable part
3. Each method returns `this` (for fluent chaining)
4. Add a `build()` method that validates and returns the final object
5. Replace constructor calls with builder chains
6. Optionally create a Director for common configurations

**Example — Before:**
```typescript
const config = new ServerConfig(
  8080,          // port
  'localhost',   // host
  true,          // enableSSL
  '/certs',      // certPath
  null,          // keyPath — wait, is this right?
  30000,         // timeout
  true,          // enableLogging
  'info',        // logLevel
  5,             // maxRetries
);
```

**Example — After:**
```typescript
const config = new ServerConfigBuilder()
  .port(8080)
  .host('localhost')
  .ssl({ certPath: '/certs' })
  .timeout(30000)
  .logging({ enabled: true, level: 'info' })
  .maxRetries(5)
  .build();
```

**Language-idiomatic alternatives:**
- **TypeScript/JavaScript:** Options object `{ port: 8080, host: 'localhost', ... }` — often sufficient
- **Python:** `@dataclass` with defaults, or keyword arguments
- **Rust:** Builder pattern is standard (e.g., `reqwest::Client::builder()`)
- **Go:** Functional options pattern (`WithPort(8080)`)
- **Kotlin:** Named arguments + default values

---

## Prototype

**Intent:** Create new objects by copying an existing object (prototype) rather than
constructing from scratch.

**Code smells it solves:**
- Complex object initialization that's expensive to repeat
- Objects that differ from a "base" by only a few properties
- Deep cloning logic scattered or duplicated

**When to apply during refactoring:**
- Test fixtures: create a base object, clone and modify for each test case
- Configuration presets: base config cloned and tweaked per environment
- Game/simulation entities: spawn new objects from templates

**Structure:**
```
Prototype (interface)
└── clone(): Prototype

ConcretePrototype
└── clone(): creates a copy of itself
```

**Refactoring steps:**
1. Identify objects that are frequently copied with small variations
2. Implement a `clone()` method (or use language-native cloning)
3. Create prototype instances for common base configurations
4. Replace construction-from-scratch with clone-and-modify

**Language-idiomatic alternatives:**
- **JavaScript:** `structuredClone()`, spread operator `{ ...obj, modified: value }`
- **Python:** `copy.deepcopy()` or `dataclasses.replace()`
- **Rust:** `Clone` trait (`#[derive(Clone)]`)
- **Java/Kotlin:** `Cloneable` interface, `.copy()` for data classes

---

## Singleton

**Intent:** Ensure a class has only one instance and provide a global point of access to it.

**Code smells it solves:**
- Global variables that manage shared state
- Multiple instances of a resource that should be shared (DB connections, loggers)
- Race conditions from multiple initialization of the same resource

**When to apply during refactoring:**
- Database connection pool, logger, or configuration manager needs exactly one instance
- You're replacing scattered global variables with controlled access

**Caution — common anti-pattern:**
Singleton is the most overused and misused pattern. Before applying, consider:
- Can you use dependency injection instead? (Almost always yes)
- Does this create hidden coupling? (Usually yes)
- Does this make testing harder? (Usually yes — hard to mock globals)

**When Singleton is actually appropriate:**
- Hardware resource managers (print spooler, GPU context)
- Application-wide configuration loaded once at startup
- Connection pools where multiple instances would waste resources

**Refactoring steps (toward Singleton):**
1. Make the constructor private
2. Create a static instance field and `getInstance()` method
3. Replace all `new` calls with `getInstance()`

**Refactoring steps (away from Singleton — more common):**
1. Make the singleton accept its dependencies via constructor
2. Create the instance at application startup (composition root)
3. Pass it to consumers via dependency injection
4. Remove the static `getInstance()` method
5. Now it's just a regular class that happens to have one instance

**Language-idiomatic alternatives:**
- **TypeScript/JavaScript:** Module-level instance (ES modules are singletons by default)
- **Python:** Module-level instance, or `__new__` override
- **Go:** `sync.Once` + package-level variable
- **Rust:** `lazy_static!` or `once_cell::sync::Lazy`
