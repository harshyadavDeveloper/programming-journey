# Day 08: Null Safety, late, final vs const

## Null safety

- Types are **non-nullable by default**. `String` can't be null, `String?` can. The compiler tracks it, so **most** null crashes become compile-time errors (`!`, `late` and `dynamic` can still fail at runtime).
- **Sound**: if the type is non-nullable, the value won't be null at runtime. It also lets the compiler generate faster code. Mandatory since Dart 3.

## Operators

| Syntax     | Meaning                                                                                                                     |
| ---------- | --------------------------------------------------------------------------------------------------------------------------- |
| `String?`  | type that may be null                                                                                                       |
| `?.`       | safe call: null if the target is null                                                                                       |
| `??`       | `a ?? b`: use `b` if `a` is null                                                                                            |
| `??=`      | assign only if null                                                                                                         |
| `!`        | asserts not null (a promise to the compiler). Throws `_TypeError: Null check operator used on a null value` if wrong. Risky |
| `...?`     | null-aware spread (silently skips a null collection)                                                                        |
| `late`     | "I'll initialize it before use"                                                                                             |
| `required` | named parameter must be passed                                                                                              |

## Type promotion

- After a null check (or `??=`), a **local** variable is promoted to non-nullable.
- A **public or mutable field is not promoted**: another piece of code could change it between the check and the use. Compile error: "refers to a public property so it couldn't be promoted".
- Fixes: copy to a local (`final n = field; if (n != null) ...`), `?.`, or `!`.
- **Private final fields are promoted** (Dart 3.2+).

## late

- `late` = non-nullable variable I'll assign before anyone reads it. `late final` can be assigned **once**.
- **Lazy initialization:** `late String x = compute();` runs `compute()` **on first access, once**.
- **Danger:** reading before it's set throws a runtime error (`LateError`). Don't use `late` just to silence the compiler.

## var / final / const

|                 | var     | final                                | const                     |
| --------------- | ------- | ------------------------------------ | ------------------------- |
| Reassignable    | yes     | no                                   | no                        |
| Value known at  | runtime | runtime                              | **compile time**          |
| Object mutable? | yes     | **yes** (only the variable is fixed) | **no** (deeply immutable) |

- `final a = [1, 2]; a.add(3)` works. `const b = [1, 2]; b.add(3)` throws `UnsupportedError`.
- **Canonicalization:** `identical(const Point(1), const Point(1))` is true. Without `const` it is false.
- A `const` constructor requires **all fields `final`**. No runtime values in a `const` (e.g. `DateTime.now()`).
- Flutter: a `const` widget is a single reused instance, so when a parent rebuilds, Flutter can skip rebuilding it.

## Nullable data from an API

- Optional fields: `String?`. Parse with a parser function. At the UI use `??` defaults, don't use `!` on API data.
- **Type drift:** `json['x'] as String?` throws if the backend sends a different type (e.g. int vs string between staging and live). A central parser util tolerates it. Log mismatches, decide on lossy conversions (`3.7` -> `3`), test with real payloads, and fix the contract with the backend.
- Don't use `dynamic` for model fields (it skips type checks).
- Required field missing: **fail early and clearly** in `fromJson`.
- `...?` silently skips a null collection, which can hide missing data.

## Traps

- Overusing `!`.
- `late` read before init.
- Thinking `final` = immutable.
- Expecting a public field to promote after `if (x != null)`.
- `const` with a runtime value.
- `dynamic` losing the null checks.

## 60-second recap

- Non-nullable by default, `?` for nullable. Sound means reliable. Use `?.`, `??`, `??=`. Avoid `!` (a runtime promise).
- Locals promote after a null check. Public fields don't (copy to a local).
- `late` = initialize before use (or lazily on first access). Reading too early throws.
- `final` = set once at runtime, object can still change. `const` = compile-time and immutable, canonicalized. `const` widgets skip rebuilds.
- API data: nullable optional fields, parser util for type drift, `??` at the UI, fail early for required fields.

## Interview Q&A (Day 8)

**What is null safety? Sound? When is `!` risky?**

- Types non-nullable by default, `?` for nullable. Compiler flow analysis turns most null crashes into compile errors. Sound = the guarantee holds at runtime. Escape hatches that can still fail at runtime: `!`, `late`, `dynamic`.
- `!` asserts not-null. If wrong it throws `_TypeError: Null check operator used on a null value`. Risky on API data. Prefer null checks, `?.`, `??`.

**Outputs (verified)**

- `name?.length` -> `null`; `name ?? 'guest'` -> `guest`; after `name ??= 'Ali'`, `name.length` -> `3` (promoted, no `!` needed).
- `final a = [1,2]; a.add(3)` -> `[1, 2, 3]`. `const b = [1,2]; b.add(3)` -> `UnsupportedError`. `identical(const Point(1), const Point(1))` -> `true`; without `const` -> `false`.
- `late String config = loadConfig();` -> `loadConfig` runs **once**, on first read. Reading an unset `late` variable throws a late-initialization error (`LateError` on current Dart).

**Field that won't promote**

- A public/mutable field can change between the check and the use, so no promotion.
- Fixes: copy to a local `final n = nickname;` (best), `nickname?.length` alone, `nickname!` (least safe), or make the field **private final** (promotes in Dart 3.2+).

**final / const / const widgets**

- `final` = set once (runtime), object may still be mutable. `const` = compile-time, deeply immutable, canonicalized. `const` constructor needs all-`final` fields.
- `const` widget = one reused instance. When a parent rebuilds, Flutter sees an identical instance and **skips rebuilding that subtree**.

**Missing email from the API**

- `final String? email`, parse with the parser helper (keeps null), UI: `email ?? 'Not provided'` or hide it. Don't use `!`. Required fields: stay non-nullable, validate in `fromJson`, throw `FormatException` if missing/invalid.
