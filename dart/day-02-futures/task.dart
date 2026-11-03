import 'dart:async';

/*
========================================================
       DART — DAY 02: FUTURES
========================================================

Topics:
- Future states and what a Future represents
- then chaining, flattening and error propagation
- catchError vs then(onError) vs whenComplete
- Futures start eagerly
- Future.wait (default vs eagerError)
- Completer

IMPORTANT:
Run ONE question at a time (uncomment it in main).
Write your prediction BEFORE running the code.

========================================================
Q1. UMBRELLA THEORY QUESTION
========================================================

Explain Dart Futures as if you were answering an
interview question.

Cover these points:

- What is a Future and what states can it be in?
- What does then() return? What happens if the callback
  returns a value? A Future? Throws?
- How do errors propagate through a chain?
- What do catchError and whenComplete do?
- Why are Futures called "eager"?
- What does Future.wait do on success and on failure?
- What is a Completer and why does it exist?
- Name one similarity and one difference compared with
  JavaScript Promises.

Keep your answer concise and interview-ready.

Your answer:
- **Future:** A `Future<T>` represents a value that may not be available immediately but will become available sometime in the future. It can be in three states: uncompleted, 
completed with a value, or completed with an error. A Future completes at most once. Futures are called eager because the asynchronous operation generally starts when the 
Future is created, not when we await it.

- **then():** Registers a callback that executes when the Future completes successfully. It always returns a new Future. If the callback returns a value, the new Future 
completes with that value. If it returns another Future, Dart adopts that Future and waits for its result (it doesn't create a nested Future). If the callback throws an error, 
the new Future completes with that error.

- **Error Propagation:** If an error occurs in a Future chain, it propagates to the next error handler. If no handler catches it, the error continues propagating through the 
chain.

- **catchError():** Handles errors in a Future chain, similar to a try-catch block. If the error is handled successfully, the returned Future can complete with the handler's 
return value. If the handler throws or returns a failed Future, the error continues propagating.

- **whenComplete():** Executes when the Future completes, regardless of whether it succeeds or fails. It is mainly used for cleanup operations, such as hiding a loading 
indicator. It doesn't automatically consume or handle an existing error.

- **Future.wait():** Waits for multiple Futures to complete and returns a Future containing a list of their results in the same order as the input Futures, not completion 
order. If all succeed, it returns the list of results. If any Future fails, the returned Future completes with an error. By default, it waits for all Futures to settle before reporting the first error. It is useful when multiple independent API requests must succeed together, such as fetching user details, packages, and bookings.

- **Completer:** A `Completer<T>` allows us to manually control the completion of a Future. We can complete it with a value using `complete()` or with an error using 
`completeError()`. It is useful when converting callback-based APIs or external events into a Future-based API.

- **Dart Future vs JavaScript Promise:** Both represent the eventual result of an asynchronous operation and support chaining using `then()` and error handling. One difference 
is that Dart provides `Completer` to manually complete a Future, whereas JavaScript uses the Promise constructor with its `resolve` and `reject` functions.

*/

/*
========================================================
Q2. CHAINS AND QUEUES
========================================================

Predict the exact output.
*/
void q2() {
  print('1');
  Future(() => print('2')).then((_) => print('3'));
  Future.microtask(() => print('4'));
  Future.value().then((_) => print('5'));
  print('6');
}
/*
Questions:

- What is the exact output order?
- Which queue does each callback run from?
- Why does '3' run immediately after '2'?
- Why is '5' a microtask?

Your answer:
output: 1 6 4 5 2 3 
- 1. print('1') -> Synchronous
  2. Future(() => print('2')) -> event queue
  3. .then((_) => print('3')) -> microtask queue
  4. Future.microtask(() => print('4')); -> microtask queue
  5. Future.value().then((_) => print('5')); -> microtask queue
  6. print('6') -> Synchronous

- When the future print 2 and completes successfully its .then is added to the microtask queue. microtask are processed before the next event queue, 3 executes before the next 
event.

- Future.value creates an already completed Future. however .then callbacks are always scheduled asynchronously in the micro task queue even when the future is already completed

*/

/*
========================================================
Q3. ERROR PROPAGATION
========================================================

Predict the exact output.
*/
void q3() {
  Future.value(1)
      .then<int>((v) {
        print('A: $v');
        throw Exception('boom');
      })
      .then<int>((v) {
        print('B: $v');
        return v + 1;
      })
      .catchError((Object e) {
        print('C: caught ${e.runtimeType}');
        return -1;
      })
      .then<int>((v) {
        print('D: $v');
        return v;
      })
      .whenComplete(() => print('E: done'));
}
/*
Questions:

- What is the exact output?
- Which callbacks were skipped, and why?
- What does the return value of catchError become?
- What would happen if the catchError handler returned a
  String instead of an int?

Your answer:
output: 
A: 1
C: caught _Exception
D: -1
E: done

- Callbacks skipped: B is skipped because the previous Future completed with an error, so its success callback doesn't execute.
- catchError return value: Returning -1 recovers the error, and -1 becomes the value passed to the next then().
- Returning a String instead of an int: The chain's declared type is Future<int>, so returning a String violates the expected return type and causes a type error.

*/

/*
========================================================
Q4. then(onError) VS catchError
========================================================

Predict what happens when this runs.
*/
void q4() {
  Future.value(1).then<void>((v) {
    throw Exception('from then');
  }, onError: (e) => print('onError: $e'));
}

/*
Questions:

- Is 'onError' printed? Why or why not?
- What happens to the exception?
- Fix it in two different ways (hint: catchError, and
  async/await with try/catch).
- When is then(onError) actually the right choice?

Your answer:
- No. The onError callback handles errors from the Future on which then() is called, not exceptions thrown inside the success callback of that same then().
- The exception completes the new Future returned by then() with an error. Since there is no error handler attached to that returned Future, the error remains unhandled.
- When you want to handle errors coming from the original Future itself, rather than errors thrown inside the success callback of the same then().

*/
// approach 1 using catchError
void q4A() {
  Future.value(1)
      .then<void>((v) {
        throw Exception('from then');
      })
      .catchError((e) {
        print('Caught: $e');
      });
}

// approach 2 using async/await
Future<void> q4B() async {
  try {
    await Future.value(1).then<void>((v) {
      throw Exception('from then');
    });
  } catch (e) {
    print('Caught: $e');
  }
}

/*
========================================================
Q5. SEQUENTIAL vs EAGER vs Future.wait
========================================================

Predict the three timings.
*/
Future<String> job(String name, int ms, {bool fail = false}) async {
  await Future.delayed(Duration(milliseconds: ms));
  if (fail) throw Exception('$name failed');
  return name;
}

Future<void> q5() async {
  final sw = Stopwatch()..start();

  await job('a', 300);
  await job('b', 300);
  print('1: ${sw.elapsedMilliseconds} ms');

  sw.reset();
  final fa = job('a', 300);
  final fb = job('b', 300);
  await fa;
  await fb;
  print('2: ${sw.elapsedMilliseconds} ms');

  sw.reset();
  await Future.wait([job('a', 300), job('b', 300)]);
  print('3: ${sw.elapsedMilliseconds} ms');
}
/*
Questions:

- What are the three timings (approximately)?
- Why is version 2 as fast as version 3?
- When does a Future actually start running?
- Is any of this multi-threaded? Explain.

Your answer:
Version 1: ~600 ms (sequential execution).
Version 2: ~300 ms (concurrent execution).
Version 3: ~300 ms (concurrent execution using Future.wait()).

- Because both Futures are created before awaiting either one. Both asynchronous operations start immediately and run concurrently. Awaiting fa first doesn't prevent fb 
from running.

- A Future generally starts its asynchronous operation when it is created, not when it is awaited. Dart Futures are eager.

- No, not necessarily. Futures provide asynchronous execution, not automatic multithreading. Both operations can overlap without blocking the main isolate, especially 
for I/O operations. Actual parallel execution requires multiple isolates or other mechanisms.

*/

/*
========================================================
Q6. Future.wait FAILURE BEHAVIOUR
========================================================

Predict when each "caught" line prints.
*/
Future<void> q6() async {
  final sw = Stopwatch()..start();
  try {
    await Future.wait([
      job('x', 100, fail: true),
      job('y', 500),
      job('z', 900),
    ]);
  } catch (e) {
    print('default: caught "$e" at ${sw.elapsedMilliseconds} ms');
  }

  sw.reset();
  try {
    await Future.wait([
      job('x', 100, fail: true),
      job('y', 500),
      job('z', 900),
    ], eagerError: true);
  } catch (e) {
    print('eager: caught "$e" at ${sw.elapsedMilliseconds} ms');
  }
}
/*
Questions:

- At what time does each version report the error?
- Do y and z still run in the eagerError version?
- How is this different from JS Promise.all?
- Read the Future.wait docs: what happens to the errors
  of the OTHER futures after the first one?

Your answer:
- Default (eagerError: false): At approximately 900 ms, when all three Futures have completed.
Eager (eagerError: true): At approximately 100 ms, when x fails

- Yes. Both continue running and finish at approximately 500 ms and 900 ms, respectively. eagerError: true does not cancel the remaining Futures.

- Dart's default Future.wait() waits for all Futures to finish before reporting an error, whereas JavaScript's Promise.all() rejects as soon as an input Promise rejects. 
Dart's Future.wait(eagerError: true) behaves similarly regarding when the error is reported. Neither automatically cancels the remaining operations.

- Dart reports the first error and silently discards any subsequent errors from the other Futures

*/

/*
========================================================
Q7. WRAP A CALLBACK API — ACTUAL CODING
========================================================

You are given an old-style callback API:
*/
void legacyFetch(
  String id,
  void Function(String data) onSuccess,
  void Function(Object error) onError,
) {
  Timer(const Duration(milliseconds: 200), () {
    if (id.isEmpty) {
      onError(ArgumentError('empty id'));
    } else {
      onSuccess('data for $id');
    }
  });
}

/*
Write `Future<String> fetchAsFuture(String id)` that wraps
it using a Completer.

Test it with:
1. A valid id
2. An empty id (catch the error)

Then answer:
- What happens if the callback fires twice and you call
  complete() twice? How do you guard against it?
- Why can't you just use the Future(() {...}) constructor
  here?

Write your code below:
*/
Future<String> fetchAsFuture(String id) {
  final completer = Completer<String>();

  legacyFetch(
    id,
    (data) {
      if (!completer.isCompleted) {
        completer.complete(data);
      }
    },
    (error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    },
  );

  return completer.future;
}

Future<void> q7() async {
  try {
    final result = await fetchAsFuture('123');
    print('Success: $result');
  } catch (e) {
    print('Error: $e');
  }

  try {
    final result = await fetchAsFuture('');
    print('Success: $result');
  } catch (e) {
    print('Error: $e');
  }
}
/*
Your answer:\
- Calling complete() or completeError() more than once on the same Completer throws a StateError. We can prevent this using completer.isCompleted before completing it.
- Future(() {}) is designed for scheduling a computation, whereas Completer allows us to manually complete a Future when an external callback eventually provides a 
result or error.

Completer is useful when converting callback-based APIs into Future-based APIs.

*/

/*
========================================================
Q8. IMPLEMENT Future.wait — ACTUAL CODING
========================================================

Write `Future<List<T>> myWait<T>(List<Future<T>> futures)`
using a Completer. Do NOT use Future.wait.

Requirements:
- Results are returned in the same order as the input.
- It completes only after ALL futures have completed.
- If any future fails, it completes with the FIRST error
  (after all have completed, like the default behaviour).
- An empty input list completes with an empty list.

Test it with futures that finish in a different order
than they were listed, and with one failing future.

Then explain:
- Why do you need a counter?
- Why store results by index instead of adding to a list?

Write your code below:
*/
Future<List<T>> myWait<T>(List<Future<T>> futures) {
  final completer = Completer<List<T>>();

  if (futures.isEmpty) {
    completer.complete([]);
    return completer.future;
  }

  final results = List<T?>.filled(futures.length, null);
  Object? firstError;
  StackTrace? firstStackTrace;
  int completedCount = 0;

  for (int i = 0; i < futures.length; i++) {
    futures[i]
        .then((value) {
          results[i] = value;
          completedCount++;

          if (completedCount == futures.length) {
            if (firstError != null) {
              completer.completeError(firstError!, firstStackTrace!);
            } else {
              completer.complete(results.cast<T>());
            }
          }
        })
        .catchError((Object error, StackTrace stackTrace) {
          firstError ??= error;
          firstStackTrace ??= stackTrace;
          completedCount++;

          if (completedCount == futures.length) {
            completer.completeError(firstError!, firstStackTrace!);
          }
        });
  }

  return completer.future;
}

Future<void> q8() async {
  try {
    final results = await myWait([
      Future.delayed(const Duration(milliseconds: 300), () => 'A'),
      Future.delayed(const Duration(milliseconds: 100), () => 'B'),
      Future.delayed(const Duration(milliseconds: 200), () => 'C'),
    ]);

    print(results); // [A, B, C]
  } catch (e) {
    print('Error: $e');
  }

  try {
    final results = await myWait([
      Future.delayed(const Duration(milliseconds: 300), () => 'A'),
      Future.delayed(
        const Duration(milliseconds: 100),
        () => throw Exception('Failed B'),
      ),
      Future.delayed(const Duration(milliseconds: 200), () => 'C'),
    ]);

    print(results);
  } catch (e) {
    print('Caught: $e'); // Caught: Exception: Failed B
  }
}
/*
Your answer:
- The counter tracks how many Futures have completed, whether successfully or with an error. We need it to know when ALL Futures have finished before completing our 
main Future.

- Because Futures can complete in a different order than they were provided. Storing results at their original indices ensures the final result maintains the same order 
as the input list, regardless of completion order.

*/

/*
========================================================
Q9. INTERVIEW — YOUR PROFILE SCREEN
========================================================

An interviewer asks:

"Your profile page loads stats, personal info and
documents with Future.wait. If the documents call fails,
what happens to the page? How would you show the data
that did load?"

Questions:

- What happens by default? Which results do you lose?
- Describe two ways to keep the successful results
  (hint: handle errors per future before waiting).
- Where would the page show the error for the failed card?
- What trade-off does eagerError: true create for the UI?

Your answer:
- By default, Future.wait() completes with an error if any Future fails. Even if stats and personal information load successfully, the combined Future throws an error, 
so we don't receive the successful results through its returned value.

- Approach 1 – Individual try-catch: Wrap each API call in its own async function with try-catch. Return the successful data or handle the error separately, allowing 
Future.wait() to complete successfully.
Approach 2 – Convert errors into result objects: Attach catchError() to each Future and return a structured result containing either the data or the error. 
This allows us to identify which requests succeeded and which failed.

- Each card should manage its own loading, success and error states. For example, if documents fail to load, show an error message and retry button inside the documents 
card while keeping stats and personal information visible.

- With eagerError: true, the combined Future reports the first error immediately instead of waiting for all requests to finish. This can make error handling faster, 
but the UI loses access to the successful results through the combined Future, and the remaining requests continue running in the background.

*/

/*
========================================================
Q10. EXPERIMENTS — VERIFY THE COMPLETION RULES
========================================================

These check what I said in section 2. Run each one on its
own and tell me if the output differs from my expectation.

Experiment A (pending Future, listener runs when?):
*/
void q10a() {
  Future(() {
    scheduleMicrotask(() => print('microtask'));
  }).then((_) => print('then'));
}

/*
Experiment B (chain of sync callbacks vs another microtask):
I expect Dart to print A1 A2 M, unlike JS, which would
give A1 M A2.
*/
void q10b() {
  Future.value().then((_) => print('A1')).then((_) => print('A2'));
  scheduleMicrotask(() => print('M'));
}
/*
Questions:

- What did you predict for each?
- What was the actual output?
- Does it match what I said? If not, write down the rule
  that explains your output.

Your answer:
output A: microtask
        then
- Future() schedules its computation in the event queue. Inside that computation, scheduleMicrotask() schedules a microtask. Once the computation finishes, the Future 
completes and its then() callback is also scheduled as a microtask. The microtask queue processes microtask before then.

output B: A1
          A2
          M
- Future.value() is already completed, so its first then() callback is scheduled as a microtask. When A1 executes, it completes the next Future in the chain, scheduling A2
 as another microtask. However, Dart processes the microtask queue in FIFO order, so M was already queued before A2.

Correct output: 
A1
M
A2

- No. Your expectation was incorrect.

Dart processes microtasks in FIFO order. When a microtask schedules another microtask, the new microtask is added to the end of the queue, not executed immediately.

*/

/*
========================================================
END OF DAY 02 — REFLECTION
========================================================

========================================================
*/

Future<void> main() async {
  // Run ONE question at a time.
  // q2();
  // q3();
  // q4();
  // await q5();
  // await q6();
  // await q7();
  // await q8();
  // q10a();
  // q10b();
}
