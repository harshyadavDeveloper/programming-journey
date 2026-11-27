# Day 09: OOP in Dart

## Constructors

- Kinds: generative (`Point(this.x, this.y)`), named (`Point.origin()`), redirecting (`: this(0, 0)`), private named (`Point._internal()`), `const`, factory.
- `this.x` shorthand is sugar for assigning the field in the initializer list.
- **Initializer list** (after `:`): sets final fields and runs checks **before** the body.
- A `final` field can be set: at its declaration, via `this.x`, in the initializer list, or as `late final` assigned later.
- **Order for a subclass:** field initializers / initializer list -> superclass constructor -> constructor body.
- **Redirecting** (`: this(...)`) calls another constructor of the same class.
- **Private constructor** stops outsiders from creating instances: basis of singletons and factories.
- **Super parameters:** `Student(super.name, super.age, this.school)`.
- `assert(...)` in an initializer list runs only when assertions are enabled (Flutter debug, `--enable-asserts`). **Removed in release.** For developer mistakes, not user input.

## Privacy, getters/setters, static

- `_` makes a member private to the **library (the file)**, not the class. Another class in the same file can still access it.
- Getter reads like a field (can be computed). Validation goes in the setter.
- `static` = belongs to the class, one copy shared by all instances, accessed as `ClassName.member`, no `this`.

## Inheritance and polymorphism

- `is` checks a type and **promotes** the variable. `as` casts and **throws** if wrong.
- Polymorphism: a `List<Shape>` calls each object's own `area()` at runtime. `super.method()` calls the parent's.

## extends / implements / with

|                 | extends   | implements                                              | with        |
| --------------- | --------- | ------------------------------------------------------- | ----------- |
| How many        | one class | many                                                    | many mixins |
| Code inherited? | yes       | **no** (contract only, must implement **every** member) | yes         |

- `abstract class`: can't instantiate; can mix abstract and concrete members. Every class has an implicit interface.

## Dart 3 modifiers (apply outside the declaring library)

- `interface class`: can `implements`, not `extends`.
- `base class`: can `extends` (subclass must be base/final/sealed), not `implements`.
- `final class`: no extends, no implements.
- `sealed class`: no extend/implement/instantiate; fixed set of subtypes (exhaustive `switch`).
- `mixin class`: usable as a class **and** a mixin.

## Mixins

- Reusable code **without inheritance**; many allowed. **Last mixin wins** (`C with A, B` -> `B`). `mixin M on Base` lets it call `super`. No constructors.
- Stack picture: `X extends Base with M1, M2` -> `M2>M1>Base`.
- Flutter: `SingleTickerProviderStateMixin`, `AutomaticKeepAliveClientMixin`, `WidgetsBindingObserver`.

## Factory constructors

- Don't have to create a new object. Patterns: **cache/singleton**, **return a subtype**, **`fromJson`**. No `this`, no initializer list.

## Extensions

- Add methods/getters to an existing type without subclassing. Resolved **statically** (on `dynamic` -> `NoSuchMethodError`). Can't add fields, can't override existing members. Can be generic or on a nullable type.

## Composition over inheritance

- A `Car` _has an_ `Engine`. Dart has single inheritance. Flutter widgets and Blocs (Bloc _has a_ repository) use composition.
- Abstract repository: real implementation in prod, a fake that `implements` it in tests.

## Traps

- Expecting `implements` to inherit code.
- Thinking `_` is class-private.
- Instantiating an abstract class.
- Extension on `dynamic`, or expecting it to override.
- Mixin conflicts: last wins.
- Believing `assert` protects release builds.

## 60-second recap

- Constructor order: field initializers / initializer list, then super constructor, then body. `this.x` is sugar.
- `extends` = one parent, inherits code. `implements` = contract only, implement everything. `with` = mixins, last wins.
- Factory can return a cached instance or a subtype. Extensions add methods but are static and can't override.
- `_` is file-level privacy. `static` belongs to the class.
- Favor composition. Dart 3 modifiers control how others use your class.

## Interview Q&A (Day 9)

**extends vs implements vs with; abstract; underscore**
- `extends`: single inheritance, inherits code, override what's needed. `implements`: contract only, **must implement every member**, many allowed. `with`: mixins, many allowed, **last mixin wins** on conflicts.
- Abstract class can't be instantiated; can mix abstract and concrete members. `_` = private to the **library (file)**, not the class.

**Outputs (verified)**
- Constructor order: `field init`, `Base ctor`, `Child ctor` (field initializers -> super constructor -> body).
- Mixins: `C with A, B` -> `B`; `D with B, A` -> `A`; both `is A` and `is B` true. Mixins can't have constructors; `on` restricts which classes can use it and lets it call `super`.

**Factory constructor**
- Doesn't have to create a new instance: cache/singleton (`putIfAbsent`), return a subtype, or `fromJson`. Normal constructor always creates a new instance.

**Extension getter edge case**
- `this[0]` throws `RangeError` on an empty string. Use `isEmpty ? this : this[0].toUpperCase() + substring(1)`.
- On `dynamic` -> `NoSuchMethodError` (extensions resolved statically). Fix: cast `(x as String).capitalized`. Extensions can't add fields or override existing members.

**Testable repository**
- Abstract `PostRepository`; real and fake both `implements` it. Bloc gets it through the constructor (dependency injection). Fake `implements` (not `extends`) so no real network code is inherited.
- With mocking libs: `class MockPostRepository extends Mock implements PostRepository {}` (mocktail/mockito).

**Mixins in Flutter**
- `SingleTickerProviderStateMixin`: provides a Ticker for `vsync`, so animations sync with the screen and pause when the widget isn't visible. Declared `on State`.
- **Single vs plural:** `SingleTickerProviderStateMixin` supports **one** `AnimationController`; `TickerProviderStateMixin` supports **several**.