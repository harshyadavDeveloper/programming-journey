# Day 01: Dart Event Loop and Execution Model

## Execution model

- Dart code always runs inside an isolate. Each isolate has its own heap and a single thread of execution. Nothing is shared between isolates.
- Each isolate runs an event loop with 2 queues: the microtask queue and the event queue.
- Async **I/O** (file, network) does not run on the Dart thread. The request is handed to native code. When it finishes, native code posts a message to the isolate, which becomes an event in the event queue.
- Not everything async goes to native code. `Future(fn)`, microtasks and timer callbacks all run on the Dart thread through the queues.

## The algorithm

1. Run `main()` synchronously to completion.
2. Loop:
   - a. Drain the microtask queue completely (including microtasks added while draining).
   - b. If the event queue is empty, wait for the next event (exit if nothing is pending).
   - c. Take ONE event from the event queue and run its handler to completion.
   - d. Go back to (a).

Microtasks have strict priority over events, so a never-ending microtask chain starves the event queue. In Flutter this blocks the UI.

## Which API goes to which queue

- **Microtask queue:** `scheduleMicrotask(fn)`, `Future.microtask(fn)`, and `.then()` / `await` continuation on an already completed Future (e.g. `Future.value(x).then(...)`).
- **Event queue:** `Future(fn)`, `Future.delayed`, `Timer`, completion of I/O, input, frame callbacks.
- **Runs immediately (sync):** `Future.sync(fn)`.
- A listener added to an already-completed Future always runs as a microtask, never inline at the .then call.

## async / await

- An `async` function runs synchronously until its first `await`. `async` does not create a thread.
- At `await`, the function pauses and an incomplete Future is returned to the caller. When the awaited value is ready, the rest of the function resumes through the microtask queue, even if the Future was already complete.

## Timers

- `Timer(Duration(milliseconds: 100), fn)` means "no earlier than 100 ms". If the isolate is busy, it fires late.

## Failure modes

1. **Blocking the loop:** an `async` function with no `await` runs entirely synchronously, and code between awaits does too. While a heavy handler runs, no frames, taps or timers are processed, so the UI freezes. Fix: move the work to another isolate.
2. **Microtask starvation:** a microtask that keeps scheduling another microtask means the microtask queue never empties, so step (c) never runs. Timers never fire and frames never get processed.

## Experiment: when does .then run on a pending Future?

- Code: `Future(() { scheduleMicrotask(() => print('microtask')); }).then((_) => print('then'));`
- I predicted: ...
- Actual output: ... (fill in after running)

## Open questions

- When exactly does a `.then` listener on a _pending_ Future run: inline, or via a microtask?
- When a .then() listener is registered on a pending Future, it waits until the Future completes. Once completed, the listener is scheduled as a microtask rather than executing inline. Therefore, the current synchronous execution finishes before the listener runs

## 60-second recap

- One thread per isolate, two queues: microtasks first, then one event at a time.
- Microtasks drain fully between events. A never-ending microtask chain starves everything.
- Async I/O is done by native code and comes back as an event. `async` is not a thread.
- An async function runs synchronously until its first `await`, then resumes via a microtask.
- Timers are "no earlier than". Heavy sync work freezes the UI, and the fix is an isolate.
