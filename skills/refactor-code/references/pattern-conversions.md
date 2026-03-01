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
