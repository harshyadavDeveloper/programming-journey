import 'dart:async';

/*
========================================================
   DART — DAY 03: ASYNC / AWAIT AND ERROR HANDLING
========================================================

Topics:
- What async guarantees (return type, sync start, errors
  become Future errors)
- How await works (state machine, listener, resume rules)
- try / catch / finally with await
- Missing await, return vs return await, sync vs async throw
- forEach with an async callback
- Unhandled async errors and Zones (runZonedGuarded)

IMPORTANT:
Run ONE question at a time (uncomment it in main).
Write your prediction BEFORE running the code.
Q4b ends with an unhandled exception, so read the error
output before fixing anything.

========================================================
Q1. UMBRELLA THEORY QUESTION
========================================================

Explain async/await in Dart as if you were answering an
interview question.

Cover these points:

- What does the async keyword guarantee about a function?
- What is the return type and what happens to return/throw?
- What exactly happens when execution reaches an await?
- When does the function resume, for a pending Future and
  for an already-completed Future?
- Does await block the thread? Where is the paused
  function's state kept?
- How does try/catch work with await?
- Name three common async/await bugs.
- Where does an unhandled async error go?
- Name one similarity and one difference compared with
  JavaScript async/await.

Keep your answer concise and interview-ready.

Your answer:

*/

/*
========================================================
Q2. ASYNC FUNCTIONS AND QUEUES
========================================================

Predict the exact output.
*/
Future<void> a() async {
  print('a1');
  await null;
  print('a2');
}

Future<void> b() async {
  print('b1');
}

void q2() {
  print('1');
  a();
  b().then((_) => print('b done'));
  scheduleMicrotask(() => print('m'));
  print('2');
}
/*
Questions:

- What is the exact output order?
- Which lines run synchronously?
- Why does b1 print before 2 even though b() is async?
- Which queue does each of a2, b done and m run from?
- Why does a2 come before b done?

predicted:
actual:
Your answer:

*/

/*
========================================================
Q3. WHEN DOES await RESUME?
========================================================

Predict the exact output of each half.
*/
Future<void> q3() async {
  Future<void> pending() async {
    await Future(() {
      scheduleMicrotask(() => print('microtask P'));
    });
    print('after await pending');
  }

  Future<void> done() async {
    await Future.value();
    print('after await done');
  }

  pending();
  await Future.delayed(const Duration(milliseconds: 50));
  print('---');
  done();
  scheduleMicrotask(() => print('microtask D'));
}
/*
Questions:

- What is the output of each half?
- In the first half, which code completes the awaited
  Future, and when does the continuation run relative to
  the microtask?
- In the second half, why does 'after await done' print
  before 'microtask D'? (Hint: when is the Future from
  Future.value() actually completed?)
- Write the resume rule in two lines.

predicted:
actual:
Your answer:

*/

/*
========================================================
Q4. WHERE DOES THE ERROR GO?
========================================================

Part A: predict the exact output.
*/
Future<int> boom() async {
  throw Exception('async boom');
}

Future<int> boomSync() {
  throw Exception('sync boom');
}

void q4a() {
  print('1');
  try {
    final f = boom();
    print('2: no exception yet');
    f.catchError((e) {
      print('3: $e');
      return 0;
    });
  } catch (e) {
    print('caught sync: $e');
  }
  try {
    boomSync().catchError((e) {
      print('x: $e');
      return 0;
    });
  } catch (e) {
    print('caught sync: $e');
  }
}

/*
Part B: predict what happens.
*/
Future<void> q4b() async {
  try {
    boom();
  } catch (e) {
    print('caught: $e');
  }
  print('after try');
}
/*
Questions:

- What is the exact output of Part A? Which exception is
  thrown synchronously and which becomes a Future error?
- Why is boomSync() dangerous to use with catchError?
- What happens in Part B? Is 'caught:' printed?
- Give two ways to fix Part B (hint: await, and unawaited
  with an explicit handler).

predicted:
actual:
Your answer:

*/

/*
========================================================
Q5. return vs return await INSIDE try
========================================================

Predict the exact output.
*/
Future<String> failing() async {
  await Future.delayed(const Duration(milliseconds: 10));
  throw Exception('network');
}

Future<String> noAwait() async {
  try {
    return failing();
  } catch (e) {
    return 'recovered';
  }
}

Future<String> withAwait() async {
  try {
    return await failing();
  } catch (e) {
    return 'recovered';
  }
}

Future<void> q5() async {
  try {
    print('1: ${await withAwait()}');
  } catch (e) {
    print('1 threw $e');
  }
  try {
    print('2: ${await noAwait()}');
  } catch (e) {
    print('2 threw $e');
  }
}
/*
Questions:

- What is the exact output?
- Why is the catch block skipped in noAwait()?
- At what moment does the try block of noAwait() finish?
- When is it safe to write "return fut" without await?

predicted:
actual:
Your answer:

*/

/*
========================================================
Q6. forEach WITH AN ASYNC CALLBACK
========================================================

Predict the exact output.
*/
Future<void> save(int i) async {
  await Future.delayed(Duration(milliseconds: 100 * (4 - i)));
  print('saved $i');
}

Future<void> q6() async {
  print('start');
  [1, 2, 3].forEach((i) async {
    await save(i);
  });
  print('end');
  await Future.delayed(const Duration(milliseconds: 500));
}
/*
Questions:

- What is the exact output order?
- Why doesn't forEach wait for the callbacks?
- Rewrite it two ways: one sequential (saved 1, 2, 3) and
  one concurrent. How long does each take?
- If save() threw an error, where would that error go in
  the forEach version?

predicted:
actual:
Your answer:

*/

/*
========================================================
Q7. RETRY HELPER — ACTUAL CODING
========================================================

Write:

Future<T> retry<T>(
  Future<T> Function() action, {
  int maxAttempts = 3,
  Duration delay = const Duration(milliseconds: 100),
})

Requirements:
- Call action(). If it succeeds, return the result.
- If it fails, wait for `delay` and try again.
- After maxAttempts failures, throw the LAST error with its
  original stack trace.
- Use async/await and try/catch (no .then chains).

Test it with:
1. flaky(), which fails twice and then succeeds
2. alwaysFails(), which should end with the last error
   after 3 attempts (print how many attempts were made)

Then answer:
- Why does action() need to be called INSIDE the try?
  (Think: what if action throws synchronously?)
- Why use rethrow instead of throw e?
- Where should the delay go, and why not after the last
  failed attempt?

Write your code below:
*/
int _calls = 0;

Future<String> flaky() async {
  _calls++;
  await Future.delayed(const Duration(milliseconds: 50));
  if (_calls < 3) throw Exception('fail #$_calls');
  return 'ok after $_calls calls';
}

Future<String> alwaysFails() async {
  _calls++;
  await Future.delayed(const Duration(milliseconds: 50));
  throw Exception('always fails (call $_calls)');
}

Future<T> retry<T>(
  Future<T> Function() action, {
  int maxAttempts = 3,
  Duration delay = const Duration(milliseconds: 100),
}) {
  // write code here
  throw UnimplementedError();
}

Future<void> q7() async {
  // test here (reset _calls = 0 between the two tests)
}
/*
Your answer:

*/

/*
========================================================
Q8. UNHANDLED ERRORS AND ZONES
========================================================

Predict the exact output.
*/
void q8() {
  runZonedGuarded(
    () {
      Future.delayed(
        const Duration(milliseconds: 10),
        () => throw StateError('lost error'),
      );
      Future<void>.error('another');
      print('zone body done');
    },
    (error, stack) {
      print('zone caught: $error');
    },
  );
}
/*
Questions:

- What is the exact output order?
- Why can't a try/catch around runZonedGuarded catch these
  errors?
- What is a Zone, in one sentence?
- Where would you put this logic in a Flutter app? Name the
  two hooks and what each one catches.
- What does unawaited() do, and why does the
  unawaited_futures lint exist?

predicted:
actual:
Your answer:

*/

/*
========================================================
Q9. INTERVIEW — YOUR PROFILE CONTROLLER
========================================================

An interviewer asks:

"Your controller's loadProfile() is async. It sets
isLoading = true, awaits Future.wait, and sets
isLoading = false. What can go wrong, and how do you
make it safe?"

Questions:

- Why should isLoading = false be in a finally block?
- The user leaves the screen while the request is running.
  What happens when the function resumes?
- Explain the use_build_context_synchronously lint in
  terms of what happens at an await. What is the fix?
- What happens if notifyListeners() is called on a
  ChangeNotifier that was already disposed? (Check the
  docs.) How would you guard against it?
- Where would you report an error that nobody awaited?

Your answer:

*/

/*
========================================================
Q10. FINAL CHALLENGE — TRY / CATCH / FINALLY ORDER
========================================================

Predict the exact output.
*/
Future<int> compute() async {
  try {
    print('t1');
    await Future.delayed(const Duration(milliseconds: 10));
    throw StateError('bad');
  } catch (e) {
    print('catch ${e.runtimeType}');
    return 1;
  } finally {
    print('finally');
  }
}

Future<void> q10() async {
  print('start');
  final f = compute();
  print('after call');
  print(await f);
  print('end');
}
/*
Questions:

- What is the exact output?
- Which lines run before compute() reaches its first await?
- Does finally run before or after the caller receives 1?
- What would change if the catch block rethrew instead?

predicted:
actual:
Your answer:

*/

/*
========================================================
END OF DAY 03 — REFLECTION
========================================================

1. What became clearer about async/await today?

2. What is still confusing?

3. Can you explain the difference between:
   return fut vs return await fut (inside try)
   an async function that throws vs a normal function that
   throws before returning a Future
   forEach with async vs a for-in loop with await

========================================================
*/

Future<void> main() async {
  // Run ONE question at a time.
  // q2();
  // await q3();
  // q4a();
  // await q4b();
  // await q5();
  // await q6();
  // await q7();
  // q8();
  // await q10();
}
