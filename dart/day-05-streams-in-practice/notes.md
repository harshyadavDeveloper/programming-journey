# Day 05: Streams in Practice

## Transforming a stream

- `map`: synchronous transform of each event.
- `where`: keeps matching events (filter).
- `distinct()`: drops **consecutive** duplicates only (compares with the previous event).
- `take(n)`, `skip(n)`, `takeWhile`, `skipWhile`: pick events by position or condition.
- Methods that return a **Future**: `first`, `last`, `firstWhere`, `toList()`, `fold`, `reduce`, `any`, `length`.
- `handleError(...)` handles error events. `timeout(...)` throws `TimeoutException` if no event arrives in time.
- **`map` vs `asyncMap`:** `asyncMap` awaits a Future per event and emits the result, handling events **one at a time, in input order** (delays 300/200/100 ms still give results in order).
- **Trap:** `stream.map((x) async => ...)` gives `Stream<Future<T>>`. Use `asyncMap`.

## Debounce vs throttle

- **Debounce:** wait until the user stops for X ms, then act. Each new event resets the timer. Use for search boxes.
- **Throttle:** act at most once per X ms however often the event fires. Use for scroll handlers and spam-prone buttons (submit, login, add).
- `Debouncer`: cancel the previous `Timer`, start a new one. Cancel it in `dispose()`.

## The search race condition

- Slow response for `a` arriving **after** the response for `ab` overwrites it, so the user sees stale results.
- Debounce reduces requests but does **not** prevent this. The cause is out-of-order async responses.
- Fixes: latest-query guard (`if (q != latest) return;`), rxdart `switchMap` (cancels the previous inner stream), Bloc `restartable()` from `bloc_concurrency` (cancels the previous handler).

## Combining streams

- Dart core has no `merge` or `combineLatest`.
- `package:async`: `StreamGroup.merge`, `StreamZip`.
- `rxdart`: `Rx.combineLatest2`, `debounceTime`, `switchMap`, `BehaviorSubject`.
- `BehaviorSubject` = broadcast controller that **replays the latest value** to new listeners (fixes "late listener misses the current value").

## Backpressure

- If events are produced faster than they're consumed, they pile up in the buffer and memory grows. `pause()`/`resume()` exist for this. `await for` processes one event at a time and pauses the subscription while its body awaits.

## How Bloc uses streams

- Flow: `add(event)` -> event stream -> `on<Event>` subscription -> my handler -> `emit(state)` -> state stream -> `BlocBuilder` -> rebuild.
- Two `StreamController.broadcast()` inside every Bloc (events in, states out). The package handles them. I write events, states, handlers, `add` and `emit`.
- `on<Event>` makes Bloc **listen** to the event stream (filtered to that type) and call my handler for each event.
- `BlocBuilder` is built on `BlocListener`, which does `bloc.stream.listen(...)` and cancels it on dispose.
- Both streams are broadcast, so many widgets can listen, but no replay. That's why there's a separate `state` getter.
- `emit` **does nothing if the new state == current state** (so states need `==`/`hashCode`, usually `Equatable`).
- Default processing is **concurrent** (handlers for different events can overlap). Transformers `restartable`, `droppable`, `sequential` change this.
- `BlocProvider(create:)` closes the bloc. `BlocProvider.value` does not.
- After close: `emit` inside a Bloc handler is silently ignored. `emit` on a Cubit throws `StateError`, so check `isClosed` after an `await`.

## Stream vs ChangeNotifier / ValueNotifier

- Stream: sequence of events over time, with errors/done, operators (debounce, combine), backpressure. Good for live data and event pipelines.
- ChangeNotifier/ValueNotifier: simple "state changed, rebuild". Less boilerplate, good for most screen state.

## Traps

- `stream.map(asyncFn)` gives `Stream<Future<T>>`.
- `distinct()` only removes consecutive duplicates.
- Debounce without a stale-response guard still shows old results.
- Forgetting to cancel the debounce `Timer` in `dispose()`.
- Emitting from a closed Cubit after an `await`.


## 60-second recap

- Stream methods: `map`, `where`, `distinct` (consecutive only), `take`, `skip`. `asyncMap` awaits in order. `map(asyncFn)` is a trap.
- Debounce for search boxes, throttle for spam-prone buttons. Debounce doesn't fix out-of-order responses, so use a latest-query guard, `switchMap` or `restartable`.
- Combining streams needs `package:async` or `rxdart`. `BehaviorSubject` replays the latest value.
- Bloc = event stream in, state stream out (both broadcast, handled by the package). `emit` ignores equal states.

## Interview Q&A (Day 5)

**map vs asyncMap; what operations exist**
- `map`/`where`/`take`/`skip`/`distinct` (consecutive only). `first`, `last`, `firstWhere`, `toList` return Futures.
- `asyncMap` awaits a Future per event, **one at a time, in input order** (delays 300/200/100 = 600 ms total).
- `map((n) async => ...)` gives `Stream<Future<T>>`. Use `asyncMap`.
- Events from a plain stream are delivered via microtasks, so they run while an `asyncMap` element is still waiting on its Future.

**Debounce vs throttle**
- Debounce: act after X ms of silence (search box). Throttle: act at most once per X ms (scroll, spam-prone buttons).
- Debouncer = cancel the previous `Timer`, start a new one. `dispose()` cancels the pending timer so no callback fires after the widget is gone.

**Search race**
- Out-of-order responses make a slow `a` overwrite `ab`. Debounce reduces calls but doesn't fix it.
- Fixes: latest-query guard, rxdart `switchMap`, Bloc `restartable()` (cancels the previous handler's ability to emit). The old HTTP request still runs unless the client can cancel it.

**Search-as-you-type (spoken frame): when / which / what / cleanup**
- When: debounce ~300 ms, ignore short queries, reset on empty.
- Which: don't trust old responses (switchMap/restartable/latest guard), cancel the request if possible.
- What: initial, loading, success, empty, failure + retry. UI renders the state.
- Cleanup: Bloc closes streams. In a State, cancel the timer in `dispose()`, check `mounted` after awaits.

**Bloc / Cubit**
- Streams under the hood: events in, states out, both broadcast, no replay (hence the `state` getter).
- `emit` of an equal state is suppressed, so states need `==`/`hashCode` (Equatable).
- After an `await`, the Cubit may be closed: check `isClosed` before `emit` (Cubit throws `StateError`; a Bloc handler's emit is ignored). `mounted` is for a widget's `State`.
- Provider + ChangeNotifier for simple screen state. Bloc for complex flows, many events, testability. Streams for live feeds.

**Combining streams**
- No `combineLatest` in core. rxdart `combineLatest2` waits for both to emit once, then emits whenever either changes. `package:async` has `StreamGroup.merge`, `StreamZip`.
- `BehaviorSubject` replays only the **latest** value to new listeners (not all past events).
