# Day 07: Mock Interview (Days 1 to 6)

Rules: answer without notes, 4 to 8 sentences, spoken style. Score out of 5.

---

## Q1. Dart is single-threaded, yet Flutter fetches data, runs timers and responds to taps without freezing. How?

**My answer (summary):** Single-threaded per isolate. Event loop, futures, streams, async/await. API call doesn't block the main isolate. The function pauses at `await` while the event loop handles taps, timers and UI updates. The response callback is scheduled and runs when the isolate is ready. Heavy CPU work (large JSON, images) goes to isolates.

**Missing for points**

- Native/OS code does the waiting, not the Dart thread.
- The response returns as an **event in the event queue**. Microtasks drain before the next event.
- Handlers **run to completion**, so heavy synchronous work freezes the UI.
- Typo to avoid when speaking: "without freezing", not "with freezing".

**Tightened answer:**

> Dart runs each isolate on a single thread with an event loop and two queues: microtasks and events. When I `await` a network call, the request is handed to native code and my function pauses, so the thread is free to handle taps, timers and frames. When the response arrives, it comes back as an event, the Future completes, and my function resumes. Every handler runs to completion, so this only works as long as I never block the thread with heavy synchronous work. For CPU-heavy work like parsing a large JSON, I move it to another isolate.

---

## Q2. Predict the output: Future / microtask / await Future.delayed(Duration.zero)

**My answer:** `1 3 2 4 5 7 6` (correct)

**Reasoning to say out loud:**

- Sync first: `1`. `Future(...)` and `Future.delayed(zero)` go to the event queue, `Future.microtask` to the microtask queue. `main` pauses at `await`.
- Microtasks before events: `3`. Then events in creation order: `2`, then the delayed callback `4`.
- When the delayed Future completes, `main` resumes in that same event: prints `5`, schedules microtask `6`, prints `7` synchronously. The microtask `6` runs after the event.

---

## Q3. Profile screen: 3 independent API calls, documents call fails

**My answer (summary):** Three API functions with error handling, `Future.wait` for concurrency (waits for all, reports the first error). Handle errors per call so one failure doesn't fail the page.

**Missing:** the mechanism (catch inside each call and return null/result), per-card UI states with retry, why concurrent (total ≈ slowest, not the sum), `mounted` check after the await.

**Tightened answer:**

I'd start the three calls together with `Future.wait`, so the total time is about the slowest call, not the sum. By default, if one fails, `Future.wait` still waits for the others and then throws the first error, and I'd lose the successful results. So I'd wrap each call to catch its own error and return `null` or a result object. Then `Future.wait` completes normally and I know exactly which parts loaded. Each card keeps its own loading, data and error state, so a failed documents card shows an error with a retry button while stats and personal info render normally. After the `await`, I'd check `mounted` before updating state.

**Code (verified):**

```dart
Future<T?> safe<T>(Future<T> Function() call) async {
  try { return await call(); } catch (_) { return null; }
}
final (stats, info, docs) = await (safe(fetchStats), safe(fetchInfo), safe(fetchDocs)).wait;
```

- Record `.wait` (Dart 3) gives typed results. Use a result type if the error message matters.

## Q4. Future vs Stream; single-subscription vs broadcast; Flutter examples

**My answer (summary):** Future = one value, Stream = sequence over time. Single-subscription (default): one listener, second throws, buffered until listener attaches. Broadcast: many listeners, late listener loses earlier data. Future for API fetch / image upload; Stream for chat / order tracking.

**Missing:** Flutter example for each stream kind, the three event types (data/error/done), the late-listener-misses-current-value consequence and its fix, how to create (`StreamController`, `.broadcast()`, `async*`).

**Tightened answer:**

> A Future gives me one result later, either a value or an error. A Stream gives me a sequence of events over time: data, errors and a done signal. A single-subscription stream, which is the default, allows exactly one listener and buffers events until it attaches. A second listener throws. I'd use it for something consumed once, like reading a file or an HTTP response. A broadcast stream, made with `StreamController.broadcast()`, allows many listeners but doesn't buffer, so a late listener misses earlier events, including the current value. I'd use it for things several widgets watch, like connectivity or a Bloc's state. For a one-off like fetching a profile or uploading an image I'd use a Future, and for a chat or live order tracking I'd use a Stream.

## Q5. try/catch around an API call, but errors are unhandled and the spinner never stops

**My answer (summary):** Check that the call is awaited (otherwise the error comes after the try ends). Check that the loading state resets on error. Fix with try/catch/finally: catch handles the error, finally resets loading.

**Missing:** `return future` without await inside try, `void async` / un-awaited callbacks (`forEach`), errors inside `.then()` callbacks, errors in Timer/stream callbacks outside the try, global safety net, `mounted` check.

**Tightened answer:**

> I'd check two things. First, is the call actually awaited? If it isn't, or if I do `return future` without `await` inside the `try`, the error arrives after the `try` has finished and becomes an unhandled async error. I'd also check for a `void async` function or an async callback nobody awaits. Second, is the loading flag reset on every path? If it's only set to false after success, an exception leaves the spinner running. The fix is `try`/`catch`/`finally`: `await` the call inside the `try`, handle the error in `catch`, and set loading to false in `finally`, checking `mounted` before updating state. For anything that still slips through, I'd report it from `PlatformDispatcher.instance.onError`.

## Q6. List screen janks after the API response, even with async/await

**My answer (summary):** Suspect CPU-bound sync work (`jsonDecode`) on the main isolate. Profile with DevTools (profile mode) and `Stopwatch`. Fix with `compute`/`Isolate.run`. Doesn't help for UI-side bottlenecks or small work. Web: consider Web Workers.

**Missing:** network latency isn't jank (it's waiting), `ListView.builder` / expensive `build` / image decoding as UI-side causes, top-level function with only data, result is copied back, reduce payload (pagination), `compute` runs on main thread on web.

**Tightened answer:**

> Even with `async`/`await`, `jsonDecode` is synchronous CPU work, so once the response arrives it runs on the UI thread and can blow the 16 ms frame budget. I'd confirm it with DevTools in profile mode, looking at the Performance timeline for long frames, plus a `Stopwatch` around the parse. If it's parsing, I'd move it to `compute` or `Isolate.run` with a top-level function that takes only the response string. It won't help if the jank comes from the UI side, like building a huge list without `ListView.builder`, an expensive `build`, or image decoding. It's also not worth it for small payloads, because spawning and copying cost time, and reducing the payload with pagination can be better. On web, `compute` runs on the main thread, so I'd need a different approach.

## Q7. Search box shows results for an older query; debounce vs throttle

**My answer (summary):** Race condition: slow response for an older query overwrites the newer one. Fix with latest-query guard, `switchMap`, Bloc `restartable()`. Debounce for search boxes, throttle for scroll or spam buttons.

**Score: 4/5**

**Fixes:** throttle = at most once per interval (not "after x ms"); debounce = after x ms of silence; debounce reduces requests but doesn't cancel in-flight ones or fix out-of-order responses; throttle is wrong for search (final query might be dropped).

**Tightened answer:**

> It's a race condition. Responses can come back out of order, so a slow request for `a` can arrive after the one for `aab` and overwrite it. Debounce waits for a pause in typing before firing, which reduces requests but doesn't fix this, because requests already in flight can still finish out of order. To fix it I'd compare the response's query with the latest one and ignore it if they differ, or use `switchMap` or Bloc's `restartable()`, which drop the older work. The old HTTP request still runs unless the client supports cancellation. Throttle limits a function to at most once per interval, so it suits scroll events and spam-prone buttons, but not a search box, since the final query might get dropped.
