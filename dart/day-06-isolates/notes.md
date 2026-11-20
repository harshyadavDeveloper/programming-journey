# Day 06: Isolates

## What an isolate is

- An isolate has its **own memory (heap)** and its **own event loop**, and normally one thread. Dart's unit of concurrency.
- **Nothing is shared.** Isolates can't read each other's variables. They communicate only by **messages through ports**, and messages are **copied**.
- No shared memory means no locks and no shared-memory data races. Close to the **actor model**.
- Every Dart program starts in a **main isolate**. Flutter's UI runs there. Each isolate has its **own copy of globals**.

## When to use one

- Only when a **big computation causes jank**: a frame can't finish within about 16 ms (60 Hz) because the UI thread is busy.
- `await` does **not** move CPU work off the UI thread. Code between awaits still runs there, so a heavy loop blocks frames.
- Good uses (CPU-bound): parsing a large JSON, image processing, encryption/hashing, compression, sorting a huge list.
- Don't use for: network calls and file reads (async is enough), or tiny tasks (spawn and copy cost).

## Three ways

- **`Isolate.run(() => work())`**: short-lived. Spawns an isolate, runs the function, returns the result as a Future, shuts the isolate down. Errors surface at the `await`, so `try`/`catch` works.
- **`compute(fn, message)`** (Flutter): one argument, top-level or static function. On mobile/desktop it equals `Isolate.run(() => fn(message))`. On **web** isolates aren't supported, so `compute` runs on the **main thread**. It works, but doesn't remove the jank.
- **`Isolate.spawn(entry, message)` + ports**: long-lived, two-way. `ReceivePort` = my inbox, `SendPort` = the address I give the other isolate so it can reply. Use it for a worker that stays alive.

## Messages and limits

- Copied (deep copy). Changing the copy doesn't change the original (a list changed in an isolate stays unchanged in main).
- Sendable: numbers, bools, strings, null, lists/maps/sets of sendable things, ports, most objects including my own classes.
- Not sendable: objects with native resources (e.g. a `ReceivePort`): `ArgumentError: object is unsendable`.
- Whatever the closure captures gets **copied**. Capturing `this` can copy a whole object or fail. Prefer a top-level/static function and pass only the data it needs.
- Big byte buffers: `TransferableTypedData` can move them without copying.

## Can't do in a spawned isolate

- No UI work: no widgets, no `dart:ui`, no `rootBundle`.
- Plugins are limited: platform channels can send to the host and get responses, but **can't receive unsolicited messages** (no long-lived Firestore listener in a background isolate).
- Web: no isolates.

## async vs isolate

|          | async/await                      | Isolate                                 |
| -------- | -------------------------------- | --------------------------------------- |
| Good for | Waiting (network, files, timers) | Heavy computation (CPU-bound)           |
| Is       | Concurrency, same thread         | Parallelism, separate memory and thread |
| Cost     | Almost none                      | Spawn + copying                         |

## Traps

- Expecting `async` to fix a frozen UI.
- Expecting globals or objects to be shared with an isolate.
- Capturing `this`, a widget or a non-sendable object in the closure.
- Using an isolate for I/O or tiny tasks.
- Forgetting `compute` runs on the main thread on web.

## 60-second recap

- An isolate = own heap + own event loop. No shared memory. Messages are copied through ports (actor model).
- Use one only when heavy CPU work janks the UI (a frame can't finish in 16 ms). `await` doesn't help with CPU work.
- `Isolate.run` for one-off work, `compute` in Flutter (main thread on web), `Isolate.spawn` + ports for long-lived workers.
- No UI, no `rootBundle`, limited plugins inside an isolate.
- Don't use for I/O or tiny tasks.

## Interview Q&A (Day 6)

**What is an isolate? How is it different from a thread?**

- Own heap + own event loop, no shared memory. Threads share memory, isolates don't, so no locks and no data races. Communicate by copied messages via ports (actor model).

**ReceivePort / SendPort**

- `ReceivePort` = my inbox. Its `SendPort` = the address I give another isolate. A `ReceivePort` is a Stream (`first`, `listen`).
- Choose `Isolate.spawn` over `Isolate.run` for long-lived workers, two-way messages or progress updates, or to avoid respawn cost. `Isolate.run` for one-off jobs.

**Janky JSON parse**

- `jsonDecode` is synchronous CPU work, so `await` doesn't help. Move parsing to `compute(parseJson, body)` / `Isolate.run`.
- Parsing function: top-level or static, taking only data (no `this`, widgets, or context).
- Not worth it for small payloads (spawn + copy cost). On web `compute` runs on the main thread, so no jank relief (reduce or chunk the work instead).

**async or isolate?**

- async/await: API calls, file reads, timers (waiting). Isolate: big JSON, image processing, encryption, sorting huge lists (CPU work). Decide: I/O-bound vs CPU-bound, profile first.

**Limits**

- Sendable: primitives, lists/maps/sets of sendable things, ports, most objects. Not sendable: native resources (e.g. `ReceivePort`).
- Closures copy what they capture. `this`/widgets/context are tied to the UI isolate and may reference unsendable objects, so pass only the data needed to a top-level function.
- Can't in a spawned isolate: UI work (widgets, `dart:ui`), `rootBundle`. Plugins limited: platform channels send/response only, no unsolicited host messages.

**Code tip**

- Prefer a loop over recursion for things like `sumOfSquares` (recursion with a weak base case overflows the stack).
