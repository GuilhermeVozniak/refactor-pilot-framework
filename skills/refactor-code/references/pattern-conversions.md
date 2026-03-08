# Pattern Conversion Reference

## React: Class → Functional Component

```
Class Component                    Functional Component
─────────────────                  ─────────────────────
class Foo extends Component   →    function Foo(props) { ... }
this.state = { x: 1 }        →    const [x, setX] = useState(1)
this.setState({ x: 2 })      →    setX(2)
componentDidMount             →    useEffect(() => { ... }, [])
componentDidUpdate(prevProps) →    useEffect(() => { ... }, [dep])
componentWillUnmount          →    useEffect(() => { return cleanup }, [])
this.props.foo                →    props.foo (or destructure)
this.handleClick = ...bind    →    const handleClick = useCallback(...)
render() { return ... }       →    return (...)
```

## JavaScript: Callbacks → async/await

```
// Before
function getData(callback) {
  fetch(url)
    .then(res => res.json())
    .then(data => callback(null, data))
    .catch(err => callback(err));
}

// After
async function getData() {
  const res = await fetch(url);
  return res.json();
}
```

Preserve error handling: `.catch()` blocks become try/catch.

## JavaScript: var → const/let

- `var` with no reassignment → `const`
- `var` with reassignment → `let`
- `var` in for loops → `let`
- Watch for hoisting differences (var is function-scoped, let/const are block-scoped)

## JavaScript: CommonJS → ESM

```
// Before
const foo = require('./foo');
module.exports = { bar };

// After
import foo from './foo';
export { bar };
```

Watch for: dynamic requires, conditional requires, `__dirname`/`__filename` usage.

## CSS: !important Removal

1. Identify what the !important is overriding
2. Increase specificity of the target selector instead
3. Or move the style closer to the element (CSS Modules, scoped styles)
4. Or use CSS custom properties for values that need to be overridable

## General: Mutable → Immutable

```
// Before
const arr = [1, 2, 3];
arr.push(4);
arr[0] = 0;

// After
const arr = [1, 2, 3];
const newArr = [...arr, 4];
const updated = [0, ...arr.slice(1)];
```

Use spread operators, Array.map/filter/reduce, Object.assign or spread for objects.

---

# Design Pattern Conversions (GoF / Refactoring Guru)

The conversions above cover language-level modernization. The patterns below cover
architectural refactoring using Gang of Four design patterns. For detailed reference
material on all 22 patterns, see `skills/design-patterns/references/`.

## Conditionals → Strategy Pattern

When a function branches on a type/mode to choose an algorithm:

```
// Before
function calculatePrice(type, amount) {
  if (type === 'regular') return amount;
  if (type === 'premium') return amount * 0.9;
  if (type === 'vip') return amount * 0.8;
}

// After
const pricingStrategies = {
  regular: (amount) => amount,
  premium: (amount) => amount * 0.9,
  vip:     (amount) => amount * 0.8,
};
function calculatePrice(type, amount) {
  return pricingStrategies[type](amount);
}
```

Adding a new type: add one entry. No conditionals to change.

## State Conditionals → State Pattern

When every method checks the object's state to decide behavior:

```
// Before: every method has if/else on this.state
class Player {
  play() {
    if (this.state === 'locked') { /* ... */ }
    else if (this.state === 'playing') { /* ... */ }
    else if (this.state === 'ready') { /* ... */ }
  }
  stop() {
    if (this.state === 'locked') { /* ... */ }
    else if (this.state === 'playing') { /* ... */ }
    // ...
  }
}

// After: delegate to state objects
class Player {
  constructor() { this.state = new ReadyState(this); }
  play() { this.state.play(); }
  stop() { this.state.stop(); }
  changeState(state) { this.state = state; }
}
// Each state class handles its own behavior and transitions
```

## Scattered new → Factory Method

When object creation is duplicated and conditionally chosen:

```
// Before: creation logic scattered
function handleEvent(event) {
  let handler;
  if (event.type === 'click') handler = new ClickHandler(event);
  else if (event.type === 'key') handler = new KeyHandler(event);
  // ... repeated elsewhere in codebase
}

// After: factory centralizes creation
const handlerFactory = {
  click: (event) => new ClickHandler(event),
  key:   (event) => new KeyHandler(event),
};
function handleEvent(event) {
  const handler = handlerFactory[event.type]?.(event);
  if (!handler) throw new Error(`No handler for ${event.type}`);
  handler.process();
}
```

## God Class → Facade + Extracted Services

When one class does everything:

```
// Before: OrderManager handles payment, inventory, shipping, notifications
class OrderManager {
  processOrder(order) {
    // 200 lines touching 4 different concerns
  }
}

// After: Facade delegates to focused services
class OrderFacade {
  constructor(payment, inventory, shipping, notifications) { /* ... */ }
  processOrder(order) {
    this.payment.charge(order);
    this.inventory.reserve(order.items);
    this.shipping.schedule(order);
    this.notifications.sendConfirmation(order);
  }
}
```

## Boolean Flags → Decorator Pattern

When behavior is toggled with boolean parameters:

```
// Before
function fetchData(url, { cache = false, log = false, retry = false }) {
  if (log) console.log(`Fetching ${url}`);
  // ... branching on every flag
}

// After: compose decorators
const fetcher = withRetry(withLogging(withCache(baseFetcher)));
// Each decorator wraps the previous one, adding one concern
```

## Tight Coupling → Observer Pattern

When a class directly calls multiple dependents after state changes:

```
// Before: Cart directly calls UI, analytics, inventory
class Cart {
  addItem(item) {
    this.items.push(item);
    ui.updateCount(this.items.length);       // tight coupling
    analytics.trackAdd(item);                // tight coupling
    inventory.reserve(item);                 // tight coupling
  }
}

// After: Cart emits events, dependents subscribe independently
class Cart extends EventEmitter {
  addItem(item) {
    this.items.push(item);
    this.emit('itemAdded', { item, cart: this });
  }
}
cart.on('itemAdded', ({ cart }) => ui.updateCount(cart.items.length));
cart.on('itemAdded', ({ item }) => analytics.trackAdd(item));
```

## Complex Constructor → Builder Pattern

When constructing an object requires many parameters or steps:

```
// Before
const config = new AppConfig(8080, 'localhost', true, '/certs', null, 30000, true, 'info');

// After
const config = AppConfig.builder()
  .port(8080)
  .host('localhost')
  .ssl({ certPath: '/certs' })
  .timeout(30000)
  .logging({ enabled: true, level: 'info' })
  .build();
```

## Nested if/else Pipeline → Chain of Responsibility

When a request passes through sequential validation/processing steps:

```
// Before: one long function with sequential checks
function processRequest(req) {
  if (!authenticate(req)) return error(401);
  if (!authorize(req)) return error(403);
  if (!validate(req)) return error(400);
  if (!rateLimit(req)) return error(429);
  return handle(req);
}

// After: composable handler chain
const pipeline = chain(
  authHandler,
  authorizationHandler,
  validationHandler,
  rateLimitHandler,
  businessHandler,
);
function processRequest(req) { return pipeline.handle(req); }
// Adding/removing/reordering steps = changing the chain composition
```

## Type Switches → Visitor Pattern

When you repeatedly switch on object type to perform different operations:

```
// Before: every new operation = new switch statement
function serialize(node) {
  if (node instanceof TextNode) return node.text;
  if (node instanceof ImageNode) return `<img src="${node.url}">`;
  if (node instanceof LinkNode) return `<a href="${node.href}">...</a>`;
}
function wordCount(node) {
  if (node instanceof TextNode) return node.text.split(' ').length;
  if (node instanceof ImageNode) return 0;
  // ...
}

// After: Visitor — new operations don't touch element classes
class HtmlVisitor {
  visitText(node) { return node.text; }
  visitImage(node) { return `<img src="${node.url}">`; }
  visitLink(node) { return `<a href="${node.href}">...</a>`; }
}
// New operation = new visitor class, zero changes to node classes
```
