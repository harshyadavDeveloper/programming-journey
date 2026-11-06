## Interview Q&A (Day 3)

**Does async make code parallel? Why can the UI freeze?**
- No. `async` lets a function pause at `await` so the single thread can do other work while waiting for I/O. It doesn't add threads.
- Code between awaits runs on the UI thread. Heavy parsing or loops block the event loop and drop frames (about 16 ms budget per frame at 60 Hz).
- Fix: move heavy work to another isolate (`Isolate.run`, `compute`).
- `Future.wait` overlaps waiting (I/O concurrency), not CPU work.

**then() vs async/await**
- Both work with Futures. `async/await` reads sequentially, and errors are thrown at the `await`, so `try`/`catch`/`finally` work normally.

**Timeout + error handling**
- `await fetch().timeout(Duration(seconds: 2))` throws `TimeoutException`. Put `on TimeoutException` before the generic `catch`. Put cleanup in `finally`.
- A timeout does **not** cancel the underlying request. It keeps running.

**FutureBuilder bug**
- Calling the API in `future:` inside `build()` creates a new Future on every rebuild, so the request repeats.
- Fix: store the Future in a field set in `initState` (or load in the controller and read it with state management).

**API call in initState**
- Leaving the screen before the response arrives, then calling `setState`, causes a "setState after dispose" error. Check `mounted` after every `await`.
- Use `isLoading` and `error` fields, `try`/`catch` for failures, and `finally` to reset the loading state.

**Unhandled async errors**
- Plain Dart: terminates the program. Flutter: logged and the app keeps running.
- Global hooks: `FlutterError.onError` (framework errors) and `PlatformDispatcher.instance.onError` (uncaught async errors). Report to Crashlytics or Sentry.

**Future<void> vs void async**
- `Future<void>`: the caller can `await` it and catch its errors.
- `void foo() async`: fire-and-forget. The caller can't wait for it, and errors become unhandled. The `avoid_void_async` lint flags it.
- The exception: event handlers like `onPressed: () async {...}` are fine, since the callback type is `void`.