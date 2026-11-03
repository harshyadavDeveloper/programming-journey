# Day 02: Futures

## What a Future is
- A `Future<T>` represents a result that isn't available yet. It is either pending, completed with a value, or completed with an error.
- It completes at most once, and after that it is immutable.
- A Future is not the computation. It is a handle to a result that someone else delivers (I/O, a timer, a `Completer`).
- A Future is **eager**: it starts when it is **created**, not when you `await` it.

## then chaining
- `then` always returns a **new** Future, never the original.
- The new Future completes with whatever the callback returns.
- If the callback returns a Future, the new Future **adopts** it and waits for it (no `Future<Future<int>>`).
- If the callback throws, the new Future completes with that error.
- If the previous Future completed with an error and there is no handler, the error passes down the chain and `then` callbacks are skipped until something handles it.

## Error handling
- `catchError`: recovers from the error. Its return value becomes the value of the next Future and must match the Future's type, otherwise a runtime error.
- `whenComplete`: like `finally`. Runs for a value or an error and doesn't change the result. If it returns a Future, it waits for it. If it throws, that error replaces the result.
- `then(onValue, onError: ...)` is **not** the same as `.then(onValue).catchError(...)`. In the first form, `onError` handles errors from the **original** Future only, not errors thrown by `onValue` in the same `then`.
- A Future that completes with an error and has no listener by the end of that turn reports an **uncaught error** to its zone. In a plain Dart program that terminates it. In Flutter the app keeps running and the error goes to `PlatformDispatcher.instance.onError` if set, otherwise it's just logged.

## Future.wait / Future.any
- `Future.wait` completes when **all** futures have completed. Results are in **input order**, regardless of finish order.
- Failure, default (`eagerError: false`): waits for all futures to complete, then completes with the **first error** that occurred. Other errors are dropped.
- With `eagerError: true`: completes with the first error immediately.
- `Future.any`: completes with the first Future to complete, **as a value or as an error**. Similar to `Promise.race`.

## Completer (gist)
- `Completer<T>` is the producer side of a Future. `completer.future` is what you hand to others, and you complete it later with `complete(value)` or `completeError(e)`.
- Completing twice throws a `StateError`. Check `isCompleted` first.
- Used to wrap callback-based APIs into Futures.

## Quick revision: JS vs Dart
| JavaScript | Dart |
|---|---|
| `Promise` | `Future` |
| `.catch` | `.catchError` / `then(..., onError:)` |
| `.finally` | `.whenComplete` |
| `Promise.all` | `Future.wait` (default waits for all, then reports the first error) |
| `Promise.race` | `Future.any` |
| `new Promise((res, rej) => ...)` | `Completer` |

## Open questions
- When exactly does a `.then` listener on a *pending* Future run: inline or via a microtask? (testing in Q10)

## 60-second recap
- A Future is a one-time result handle: pending, then a value or an error.
- `then` returns a new Future, flattens returned Futures, and passes errors down the chain until handled.
- `catchError` recovers, `whenComplete` is `finally`, and `then(onError:)` doesn't catch errors from its own `onValue`.
- Futures start eagerly, so create them first and await later to run them concurrently.
- `Future.wait` keeps input order and by default waits for all before reporting the first error.