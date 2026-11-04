# Day 03: async / await and Error Handling

## What async guarantees

- Return type is `Future<T>`. `return x` completes it with `x`. Returning a Future adopts it (no `Future<Future<int>>`). `throw` completes it with an error.
- The body runs **synchronously until the first `await`**.
- Errors never escape the call synchronously. An async function that throws hands you a Future completed with that error.

## How await works

- An async function is compiled into a **state machine**. Its locals and position are saved on the heap, so it pauses without any thread. `await` does not block.
- `await e`: evaluate `e`. If it is a Future, register the rest of the function as a **listener** on it. If it is a plain value, treat it as already complete. Then suspend and return the function's own pending Future to the caller.
- When the awaited Future completes: a value becomes the result of the `await`, and an error is **thrown at the await**, so `try`/`catch` works.
- **Resume rule:**
  - awaiting a **pending** Future: the continuation runs **synchronously at the moment that Future completes** (inside the event or microtask that completed it).
  - awaiting an **already-completed** Future or a **plain value** (`await null`): it resumes through a **microtask**.

## try / catch / finally

- `finally` is the right place for cleanup (e.g. hiding a loader). It runs on success and on error.
- `rethrow` keeps the original stack trace. `throw e` resets it.
- Catch specific types with `on SomeError catch (e)`.

## Four traps

- **A. Missing `await`:** `try { boom(); } catch ...` does not catch it. The call returns a Future immediately and the error ends up **unhandled** (crashes a plain Dart program, goes to the zone handler).
- **B. `return fut` vs `return await fut` inside `try`:** without `await`, the try block finishes as soon as it hands back the Future, so the local `catch` is skipped. The error is **not lost**: it reaches the caller through the returned Future. Use `return await fut` when the local `catch` must cover it.
- **C. Async throw vs sync throw:** a non-async function that returns a Future but throws before returning throws **at the call**, so `.catchError(...)` never gets attached. An `async` function never throws at the call.
- **D. `forEach` with async callback:** `forEach` ignores the returned Futures, so the code after it runs before any callback finishes. Use `for (final x in list) { await save(x); }` for sequential work, or `await Future.wait(list.map(save))` for concurrent work.

## Unhandled errors and Zones

- A **Zone** is the execution context every callback and Future belongs to. It controls scheduling and where uncaught errors go.
- An error from a Future that nobody handles goes to the current zone. In plain Dart, the root zone terminates the program ("Unhandled exception").
- `runZonedGuarded(body, onError)` catches uncaught async errors from its body.
- Flutter hooks:
  - `FlutterError.onError`: errors inside the framework (build, layout, paint, gestures).
  - `PlatformDispatcher.instance.onError`: uncaught async errors. Send them to Crashlytics or Sentry here.
- `unawaited(future)` (`dart:async`) marks a fire-and-forget Future on purpose. Turn on the `unawaited_futures` lint.

## Where it shows up in my work

- `use_build_context_synchronously`: at an `await`, other events run, so the widget may be disposed when the function resumes. Check `mounted` before using the context.
- `isLoading = false` in `finally`, so the loader turns off even after an error.

## Open questions

-

## 60-second recap

- `async` returns a Future, runs synchronously until the first `await`, and turns `throw` into an error inside the Future.
- `await` registers the rest of the function as a listener. Pending Future: resumes when it completes. Already-completed or plain value: resumes via a microtask.
- No thread is used, because the paused function lives on the heap as a state machine.
- Traps: missing `await`, `return fut` inside `try`, sync vs async throw, `forEach` with async.
- Unhandled async errors go to the zone. Flutter: `PlatformDispatcher.instance.onError`.
