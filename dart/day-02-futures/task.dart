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

predicted:
actual:
Your answer:

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

predicted:
actual:
Your answer:

*/

/*
========================================================
Q4. then(onError) VS catchError
========================================================

Predict what happens when this runs.
*/
void q4() {
  Future.value(1).then<void>(
    (v) {
      throw Exception('from then');
    },
    onError: (e) => print('onError: $e'),
  );
}
/*
Questions:

- Is 'onError' printed? Why or why not?
- What happens to the exception?
- Fix it in two different ways (hint: catchError, and
  async/await with try/catch).
- When is then(onError) actually the right choice?

predicted:
actual:
Your answer:

*/

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

predicted:
actual:
Your answer:

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

predicted:
actual:
Your answer:

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
  // write code here
  throw UnimplementedError();
}

Future<void> q7() async {
  // test here
}
/*
Your answer:

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
  // write code here
  throw UnimplementedError();
}

Future<void> q8() async {
  // test here
}
/*
Your answer:

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

predicted:
actual:
Your answer:

*/

/*
========================================================
END OF DAY 02 — REFLECTION
========================================================

1. What became clearer about Futures today?

2. What is still confusing?

3. Can you explain the difference between:
   then(onError) vs catchError
   Future vs Completer
   Sequential await vs Future.wait

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