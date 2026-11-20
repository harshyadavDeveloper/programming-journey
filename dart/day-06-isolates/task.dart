import 'dart:async';
import 'dart:isolate';

/*
========================================================
   DART — DAY 06: ISOLATES (INTERVIEW ROUND)
========================================================

Run ONE question at a time (Q2, Q3, Q4 are runnable).
Write your prediction BEFORE running the code.

========================================================
Q1. EXPLAIN ISOLATES
========================================================

"What is an isolate in Dart? How is it different from a
thread, and how do isolates communicate?"

Your answer:
An isolate in Dart is an independent unit of execution that has its own memory heap and event loop.
Unlike traditional shared-memory threading models, Dart isolates don't directly share memory or access each other's variables. They communicate through 
message passing using SendPort and ReceivePort.
We use isolates in Flutter to perform CPU-intensive operations such as parsing large JSON responses, image processing, encryption or sorting large 
datasets without blocking the main UI isolate.
Dart provides APIs such as Isolate.spawn() and Isolate.run(), and Flutter provides compute() as a convenient way to execute background computations.
We generally don't need isolates for network calls or normal file I/O because asynchronous operations can handle those without blocking the event loop.

Extra Note: Async/await helps us handle asynchronous operations without blocking the current isolate. It supports concurrency, 
but it doesn't automatically execute CPU-intensive code in parallel.
Isolates provide separate execution environments and allow CPU-intensive tasks to run in parallel, potentially using 
different CPU cores.

*/

/*
========================================================
Q2. PREDICT THE OUTPUT
========================================================
*/
int counter = 0;

Future<void> q2() async {
  await Isolate.run(() {
    counter++;
    print('inside isolate: $counter');
  });
  print('main: $counter');

  final list = [1, 2, 3];
  final len = await Isolate.run(() {
    list.add(4);
    return list.length;
  });
  print('isolate saw length $len, main list: $list');
}
/*
Questions:
- What is the exact output?
- Why does 'main' still print 0?
- Why is the list in main unchanged?

Your answer:
output: 
inside isolate: 1
main: 0
isolate saw length 4, main list: [1, 2, 3]

- Main prints 0 because the worker isolate increments its own copy of counter.
- Main list remains [1, 2, 3] because the worker modifies its isolated copy.
- The worker explicitly returns 4, which is received by the main isolate.
*/

/*
========================================================
Q3. LIVE CODING — Isolate.run
========================================================

Write sumOfSquares(int n) (sum of i*i for i = 1..n) and call it
with Isolate.run for n = 1000. Then call Isolate.run with code
that throws a StateError and handle it with try/catch.

Then answer:
- Why does the error show up at your await?

Write your code below:
*/
int sumOfSquares(int n) {
  if (n == 1) return 1;
  return (n * n) + sumOfSquares(n - 1);
}

Future<void> q3() async {
  final intnum = await Isolate.run(() {
    int n = sumOfSquares(1000);
    print('inside isolate: $n');
    return n;
  });
  print(intnum);
  try {
    await Isolate.run(() {
      throw StateError('Something went wrong');
    });
  } on StateError catch (e) {
    print('Caught in main: $e');
  }
}
/*
Your answer:
Isolate.run returns a Future containing the result of the computation. If an exception occurs inside the worker isolate, that Future completes with the error. 
When we await that Future, the error is rethrown in the calling isolate, which allows us to handle it using a normal try/catch block.

*/

/*
========================================================
Q4. LIVE CODING — Isolate.spawn WITH PORTS
========================================================

Write a worker function that receives [SendPort, int], computes
the square of the int, and sends it back. In q4(), spawn it with
Isolate.spawn, wait for the result on a ReceivePort, and print it.

Then answer:
- What are ReceivePort and SendPort?
- When would you choose Isolate.spawn over Isolate.run?

Write your code below:
*/
void worker(List<Object> msg) {
  final SendPort sendPort = msg[0] as SendPort;
  final int number = msg[1] as int;

  final result = number * number;

  sendPort.send(result);
}

Future<void> q4() async {
  final receivePort = ReceivePort();

  await Isolate.spawn(worker, [receivePort.sendPort, 5]);

  final result = await receivePort.first;

  print('Square: $result');

  receivePort.close();
}
/*
Your answer:
ReceivePort and SendPort are used for communication between isolates through message passing.
A ReceivePort is used to receive messages from another isolate. It exposes a stream that listens for incoming messages.
A SendPort is used to send messages to the ReceivePort associated with it.
We typically create a ReceivePort in the main isolate, pass its SendPort to the worker isolate, and then use that SendPort inside the worker to send results 
back to the main isolate.

*/

/*
========================================================
Q5. FLUTTER SCENARIO — JANKY JSON PARSING
========================================================

"A screen fetches a 5 MB JSON response and parses it with
jsonDecode inside an async function. The list screen janks.
What's going on, and how do you fix it?"

Cover:
- Why doesn't async/await prevent the jank here?
- How would you fix it (compute or Isolate.run)? Where should
  the parsing function live, and why?
- When is this NOT worth it?
- What happens if the app also runs on web?

Your answer:
If a screen fetches a large JSON response and parses it using jsonDecode inside an async function, the UI can still experience jank because jsonDecode is a 
synchronous CPU-intensive operation.
Async and await don't automatically move CPU-intensive work to another thread or isolate. They only help us handle asynchronous operations without blocking 
the current isolate.
To solve this, I would move JSON parsing to a background isolate using compute() or Isolate.run(). I would keep the parsing function as a top-level or static 
function so it can execute independently and doesn't depend on widget-specific state(context).
However, I wouldn't use isolates for small JSON responses because isolate creation and data-transfer overhead might outweigh the benefits.
Also, on Flutter Web, compute() runs on the current event loop rather than creating a separate isolate, so it doesn't provide the same performance benefit.
*/

/*
========================================================
Q6. ASYNC OR ISOLATE?
========================================================

"Give three examples where async/await is enough and three
where you need an isolate. How do you decide?"

Your answer:
I would use async/await for I/O-bound operations, such as API calls, reading files asynchronously and handling timers or delays, because these operations 
involve waiting for external resources rather than continuously using the CPU.

I would use isolates for CPU-intensive operations such as parsing large JSON responses, processing large files, image manipulation and performing complex 
calculations or sorting large datasets.

My decision would depend on whether the operation is I/O-bound or CPU-bound. I generally prefer async/await first because isolates introduce overhead, 
including isolate creation and transferring data between isolates.
I would profile the application and move CPU-intensive operations to an isolate when they noticeably affect UI responsiveness and the performance benefit 
outweighs the overhead.

I would use Isolate.run() when I have a one-time CPU-intensive computation, where I need to execute some work in another isolate and get the result back.
On the other hand, I would use Isolate.spawn() when I need a long-running worker isolate that can handle multiple tasks or continuous communication with the
main isolate.
With Isolate.spawn(), I can establish communication using SendPort and ReceivePort and keep the worker alive until I explicitly manage its lifecycle.

*/

/*
========================================================
Q7. LIMITS AND GOTCHAS
========================================================

Questions:
- What can and can't be sent between isolates?
- Why can capturing `this` or a widget in an Isolate.run
  closure cause problems?
- Name two things you can't do inside a spawned isolate in
  Flutter.

Your answer:

Isolates communicate through message passing, so we can send values such as strings, numbers, lists, maps and many transferable Dart objects.
However, objects such as BuildContext, Flutter widgets and certain objects containing native resources cannot be transferred normally. We need to pass 
only the data required by the worker isolate.

When we access instance variables inside an Isolate.run closure, the closure might capture the entire surrounding object through this.
That object may contain Flutter-specific references, controllers or other objects that cannot be transferred between isolates.
To avoid this, I prefer extracting the required data and passing it to an independent top-level or static function.

A spawned isolate cannot directly update the Flutter UI or access the main isolate's BuildContext.
It also cannot directly access or modify variables belonging to the main isolate. We need to communicate through SendPort and ReceivePort and let the main 
isolate handle UI updates.

*/

Future<void> main() async {
  // Run ONE question at a time.
  // await q2();
  // await q3();
  await q4();
}
