# Day 04: Streams

## What a stream is
- A Stream delivers a **sequence** of events over time: data, error, or done. A Future delivers one result and completes once.
- Used in Flutter for Firebase `snapshots()`, WebSockets, location and connectivity updates, Bloc/Cubit states, streamed (AI) responses.

## Single-subscription vs broadcast
- It is a property of the stream **object**, chosen at creation. Check with `stream.isBroadcast`.
- Default is single-subscription: `StreamController()`, `async*`, `Stream.periodic`, `fromIterable`, `fromFuture`.
- Broadcast: `StreamController.broadcast()` or `stream.asBroadcastStream()`.

| Single-subscription | Broadcast |
|---|---|
| One listener, ever. A second `listen` throws `Bad state: Stream has already been listened to` (even after the first cancels). | Many listeners. A listener can cancel and others can join later. |
| Queue of events + one listener slot. Events are **buffered** until someone listens. | List of listeners, no queue. Events with no listener are **lost**. |
| Late listener gets everything from the start. | Late listener only gets events from when it subscribes. |
| Data that is consumed once (file, HTTP). | Things that happen regardless of listeners (UI events, state changes). |

Analogy: single = a pipe that holds water until a glass is placed. Broadcast = radio, and you miss what played before you tuned in.

## Laziness
- Single-subscription streams and `async*` are **lazy**: nothing runs until someone listens.
- A broadcast controller emits regardless of listeners, which is why events get lost.

## Creating streams
- `StreamController<T>()`: `add(x)`, `addError(e)`, `close()` (sends the done event).
- `async*` generator: `yield` emits an event, `yield*` delegates to another stream. `finally` runs when the stream finishes **or** the listener cancels.
- `Stream.periodic`, `Stream.fromIterable`, `Stream.fromFuture`.
- `add` doesn't call the listener inline. Delivery is asynchronous.

## Consuming
- `listen(onData, onError:, onDone:, cancelOnError:)` returns a `StreamSubscription` with `pause`, `resume`, `cancel`.
- Errors do **not** stop a stream by default. With `cancelOnError: true` the subscription cancels at the first error and `onDone` is **not** called.
- `await for`: sequential. An error event is thrown inside the loop and ends it, so use `try`/`catch`. It never finishes on an infinite stream.

## Flutter
- `StreamBuilder`: rebuilds per event. States: `none`, `waiting`, `active`, `done`. Check `hasError` and `hasData`.
- **Don't create the stream inside `build()`**, or you get a new stream on every rebuild.
- `StreamBuilder` cancels its own subscription. If you `listen` manually, store the subscription, **cancel it in `dispose()`**, and check `mounted` before `setState`.
- Close any `StreamController` you own, usually in `dispose()`.

## Traps
- Listening twice to a single-subscription stream.
- A late listener on a broadcast stream misses earlier events.
- Creating the stream inside `build()`.
- Forgetting `cancel()` or `close()`.
- Assuming an error ends the stream.

## Open questions
-

## 60-second recap
- A Stream is a sequence of data, error and done events over time. A Future is one result.
- Single-subscription (the default): one listener, buffers events until it attaches. Broadcast: many listeners, no buffer, events with no listener are lost. The creator chooses.
- Create with `StreamController`, `async*`/`yield`, or `Stream.periodic`/`fromIterable`/`fromFuture`. Consume with `listen` or `await for`.
- Errors don't end the stream by default. Cancel subscriptions and close controllers in `dispose()`.
- Never create a stream inside `build()`.