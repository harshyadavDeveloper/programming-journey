import 'dart:async';
// q1. What are the two queues in a Dart isolate, and what is the exact priority rule between them? Give one similarity and one
// difference compared with the JavaScript event loop.
// answer: Dart has two main queues: the Microtask Queue and the Event Queue. The Microtask Queue has higher priority, so Dart processes all pending microtasks before
// picking an event from the Event Queue. After executing one event, it checks the Microtask Queue again and drains it before processing the next event.
// Similarity with JavaScript: Both use an event loop with a high-priority microtask queue and a lower-priority event/task queue.
// Difference: Dart's event loop is integrated with its isolate-based concurrency model, whereas JavaScript's event loop is defined by its host environment,
// such as browsers or Node.js

// q2. Why is Future.value(1).then(f) a microtask but Future(() => 1).then(f) is not?
// answer: Future.value() creates an already-completed Future, so its .then() callback is scheduled directly in the Microtask Queue. On the other hand, Future()
// schedules the supplied computation in the Event Queue. Once that computation executes and completes the Future, its .then() callback is scheduled in the Microtask
// Queue.

// q3. True or false: “An async function runs on a background thread.” Explain precisely what happens at the first await.
// False. An async function does not automatically execute on a background thread. It runs on the current isolate and executes synchronously until it encounters an
// await expression. At that point, the function suspends, and its caller gets control back while the async function's Future remains pending. Once the awaited Future
// completes, the suspended function resumes asynchronously through the event loop, with its continuation scheduled as a microtask. This also applies when awaiting an
// already-completed Future.

// q4. How does a File.readAsString() completion end up as running Dart code? Mention native code, ports or events, and the event queue.
// answer: When we call File.readAsString(), Dart returns a Future immediately. The dart:io implementation coordinates the file operation with native I/O infrastructure
// and the operating system. Once the operation completes, the result is communicated back to the requesting Dart isolate through its event-handling mechanism,
// involving ports and events. The completion event is processed through the Event Queue, which completes the Future. The continuation after await is then scheduled as
// a microtask, allowing the suspended Dart function to resume and process the file contents

// q5: Why can a timer set for 100 ms fire after 3 seconds? Why is that a property of the model rather than a bug?
// answer: A timer in Dart guarantees a minimum delay, not an exact execution time. For example, a 100 ms timer becomes eligible to execute after 100 ms, but if the
// isolate is busy executing synchronous code, the event loop cannot process the timer callback. It will execute only when the isolate becomes available. This is an
// inherent property of Dart's event-driven, single-threaded isolate model, not a bug.

// q6: Predict the output (write first, then run)

// void main() { note: uncomment only for executing
//   print('1');
//   Future(() {
//     print('2');
//     scheduleMicrotask(() => print('3'));
//   });
//   Future(() => print('4'));
//   scheduleMicrotask(() => print('5'));
//   print('6');
// }
// output: 1 6 5 2 3 4
// Dart processes synchronous code first, then drains the Microtask Queue.
// It executes one event from the Event Queue at a time, checking and
// draining the Microtask Queue again before processing the next event.

// q7. Predict the output (write first, then run)

Future<void> task() async {
  print('a');
  await Future.value();
  print('b');
}

// void main() {
//   print('c');
//   task();
//   Future(() => print('d'));
//   scheduleMicrotask(() => print('e'));
//   print('f');
// }

// output: c a f b e d
// The code before await (print('a')) executes synchronously.
// Even though Future.value() is already completed, print('b')
// is scheduled as a microtask. It is added to the Microtask Queue
// before the manually scheduled microtask (print('e')).
// Therefore, 'b' executes before 'e' because microtasks follow FIFO order.

// q8. In the starvation example, will 'timer' ever print? Explain with the algorithm in section 2.
// answer: No, the timer will never print. This is an example of microtask starvation. The loop continuously schedules another microtask before the current microtask
// finishes. According to Dart's Event Loop algorithm, all pending microtasks must be processed before the next event is picked from the Event Queue. Since the
// Microtask Queue never becomes empty, the timer callback is indefinitely starved.

// q9. Write code that sets a Timer for 100 ms and then immediately runs a synchronous loop of about 2 seconds. Use Stopwatch to measure when the timer callback
// actually runs, and explain the result.

void main() {
  print('Program started');

  Timer(const Duration(milliseconds: 100), () {
    print('Timer executed');
  });

  final stopwatch = Stopwatch()..start();

  while (stopwatch.elapsed < const Duration(seconds: 2)) {}

  print('Synchronous loop finished');
}

// Timer duration is a minimum delay, not an exact execution time.
// If the isolate is busy executing synchronous code, the timer
// callback cannot execute until the isolate becomes available.

// q10. Write a 60-second spoken answer to “How does Dart’s event loop work?” that includes one example from your profile screen’s loading flow.
// answer: Dart uses an Event Loop to manage synchronous and asynchronous operations within an isolate.
// First, synchronous code executes on the call stack. Dart has two main queues: the Microtask Queue and the Event Queue. The Microtask Queue has higher priority,
// so Dart drains all pending microtasks before processing one event from the Event Queue. After processing an event, it checks the Microtask Queue again.
// For example, in a Flutter profile screen, when the screen loads, I might call an API using an asynchronous function and await the response. While waiting for the
// network operation to complete, the isolate can process other events. Once the response arrives, the Future completes and the code after await resumes asynchronously.
// One important thing to remember is that timers don't guarantee exact execution times. If the isolate is busy with synchronous code or continuously executing
//microtasks, other events can be delayed.
// This is how Dart manages asynchronous execution without blocking the isolate while waiting for I/O.
