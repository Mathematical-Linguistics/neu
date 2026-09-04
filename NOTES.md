# Neu Lang

## Open Questions

- What's the difference between OCaml and R?
- If you could create a polylang system, what would it look like?
- If you had to create a programming language that took the best of JavaScript, R, Haskell, Rust, and OCaml, what would it look like? What could we do with it?

---

## The Best of Each Language

**JavaScript** — ubiquity, event-driven async, first-class functions, object literals, prototype flexibility, ecosystem reach (browser + server). Leave behind: type coercion, `this` semantics, `null` vs `undefined`.

**R** — first-class data frames, vectorized operations, formula syntax, statistical computing as a primitive, pipe operators, REPL-first exploratory workflow.

**Haskell** — powerful type system (typeclasses, higher-kinded types, algebraic data types), purity by default, lazy evaluation, pattern matching, monadic composition for effects.

**Rust** — ownership and borrowing for memory safety without GC, zero-cost abstractions, traits, enums with data, `Result`/`Option` instead of exceptions/nulls, fearless concurrency.

**OCaml** — pragmatic ML. Algebraic data types + pattern matching like Haskell but with eager evaluation and mutability when needed. Module system (functors) arguably the most powerful in any language. Fast compilation. The "get things done" functional language.

---

## The Language: Neu

### Core Philosophy

- **Expression-oriented** — everything returns a value (from Haskell/OCaml/Rust)
- **Data-first** — tabular data and vectors are primitives, not libraries (from R)
- **Safe by default** — no nulls, no exceptions, algebraic error handling (from Rust/Haskell)
- **Pragmatically functional** — pure by default, explicit effects, but mutability is available and not shameful (from OCaml)
- **Runs everywhere** — compiles to native, WASM, and can be interpreted in a REPL (from JS's reach + R's exploratory style)

### Type System

From Haskell and OCaml: algebraic data types, parametric polymorphism, type inference. From Rust: traits (practical typeclasses). From TypeScript: structural typing for record types (JS object flexibility with safety).

```neu
// Algebraic data types with Rust/OCaml flavor
type Option<T> = Some(T) | None

type Result<T, E> = Ok(T) | Err(E)

// Structural record types (JS/TS influence)
type User = { name: String, age: Int }

// Traits (Rust/Haskell influence)
trait Summarize {
  fn summary(self) -> String
}

impl Summarize for User {
  fn summary(self) -> String = "{self.name}, age {self.age}"
}
```

### Data as a Primitive

From R: vectors and data frames are first-class. Vectorized operations just work. Pipes are built in.

```neu
// Vectors are primitive, operations are vectorized
let temps = [72.1, 68.4, 75.0, 69.2, 71.8]
let celsius = (temps - 32) * 5/9  // vectorized arithmetic

// Data frames are primitive
let df = dataframe {
  name:  ["Alice", "Bob", "Carol"],
  score: [92, 87, 95],
  grade: ["A", "B+", "A"],
}

// R-style piping with type safety
let result = df
  |> filter(.score > 90)
  |> select(.name, .score)
  |> mutate(curved = .score + 5)
```

### Effects and Async

From Haskell: side effects tracked in the type system. From JavaScript: async/await ergonomics. From Rust: zero-cost.

```neu
// Effects are tracked but ergonomic
fn read_config(path: String) -> IO<Result<Config, FileError>> {
  let contents = await fs.read(path)?
  parse_config(contents)
}

// JS-style async with Haskell-style effect tracking
fn fetch_users() -> Async<IO<Vec<User>>> {
  let response = await http.get("https://api.example.com/users")?
  response.json::<Vec<User>>()?
}
```

### Pattern Matching

Deep, exhaustive, and central — shared by Haskell, OCaml, and Rust.

```neu
fn describe(value: Result<Int, String>) -> String = match value {
  Ok(n) if n > 100 => "big success: {n}",
  Ok(n)            => "success: {n}",
  Err(msg)         => "failed: {msg}",
}

// Destructuring everywhere (JS + ML)
let { name, score } = user
let [first, ...rest] = items
```

### Module System

From OCaml: functors (modules parameterized by other modules). From JS/Rust: simple import/export syntax.

```neu
// Simple imports (JS/Rust style)
use std.collections.HashMap
use mylib.{ parse, validate }

// OCaml-style module functors for abstraction
module MakeCache(Store: KeyValueStore) {
  fn get(key: String) -> Option<Store.Value> { ... }
  fn set(key: String, value: Store.Value) -> Result<(), Store.Error> { ... }
}

// Instantiate with a concrete store
module RedisCache = MakeCache(RedisStore)
```

### Memory Model

From Rust: ownership for performance-critical code. But opt-in — default to lightweight reference-counted GC (like Swift) for everyday code.

```neu
// Default: managed memory, no thinking required
fn process(data: Vec<User>) -> Vec<String> {
  data |> map(.name) |> filter(.len() > 3)
}

// Opt-in ownership for hot paths
fn process_fast(data: own Vec<User>) -> own Vec<String> {
  // Rust-style ownership rules apply here
  data |> map(.name) |> filter(.len() > 3)
}
```

### REPL and Exploratory Computing

From R and JS: a first-class REPL for loading data, exploring, plotting, and iterating.

```neu
neu> let df = read_csv("data.csv")
neu> df |> summary()
// ┌────────┬───────┬────────┬─────┐
// │ column │ type  │ mean   │ n   │
// ├────────┼───────┼────────┼─────┤
// │ age    │ Int   │ 34.2   │ 100 │
// │ score  │ Float │ 87.6   │ 100 │
// └────────┴───────┴────────┴─────┘

neu> df |> plot(x = .age, y = .score, geom = scatter)
// [renders inline plot]
```

---

## What Could You Do With Neu?

1. **Data science + production code in one language.** No more prototyping in R/Python then rewriting in Rust/Go/Java. Neu's data primitives + strong types + native compilation means the exploratory code _is_ the production code.

2. **Full-stack with safety.** Compile to WASM for the browser, native for the server. One language, JS's reach, Rust's safety.

3. **Systems programming without the ceremony.** Opt-in ownership means Rust-level performance when needed without fighting the borrow checker for a simple script.

4. **Correct-by-construction APIs.** Effect system + algebraic error handling means you can't forget to handle an error, and the type system documents what side effects a function performs.

5. **Statistical computing that scales.** R's vectorized semantics with Rust's performance. Data frames that handle millions of rows without switching to Spark.

---

## Closest Existing Languages

- **F#** — OCaml lineage + .NET reach
- **Scala** — FP + JVM pragmatism
- **Julia** — data science + performance

None of them nail all five pillars.

---

## Next Steps

- [ ] Formal language spec
- [ ] Flesh out the type system in detail
- [ ] Define the data model (vectors, data frames, tensors?)
- [ ] Pin down syntax decisions
- [ ] Prototype a parser / interpreter
