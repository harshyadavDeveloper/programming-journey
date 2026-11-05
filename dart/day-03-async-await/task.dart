import 'dart:async';

/*
========================================================
   DART — DAY 03: ASYNC / AWAIT (INTERVIEW ROUND)
========================================================

Questions an interviewer is likely to ask about Futures
and async/await in a Flutter interview.
Run ONE question at a time (Q3 and Q4 are runnable).

========================================================
Q1. EXPLAIN async / await
========================================================

An interviewer asks: "Explain async/await in Dart."

Cover:
- What does an async function return?
- What does await do?
- Does async create a new thread? Does await block the UI?
- How do you handle errors?
- What is the difference between then() and async/await?

Your answer:

*/

/*
========================================================
Q2. IS async THE SAME AS PARALLEL?
========================================================

"If I make a function async, does it run in parallel?
Why can my UI still freeze when I use async code, and
what is the fix?"

Your answer:

*/

/*
========================================================
Q3. PREDICT THE OUTPUT (CLASSIC)
========================================================
*/
void q3() {
  print('main start');
  fetchData();
  print('main end');
}

Future<void> fetchData() async {
  print('fetch start');
  await Future.delayed(const Duration(seconds: 1));
  print('fetch end');
}
/*
Questions:
- What is the output, and why does 'main end' come before
  'fetch end'?
- Which lines run before the first await?

predicted:
actual:
Your answer:

*/

/*
========================================================
Q4. LIVE CODING — TIMEOUT AND ERROR HANDLING
========================================================

Write loadUser() that:
- calls fetchUser() with a 2 second timeout
- prints 'Hello <name>' on success
- prints 'Request timed out' on a timeout
- prints 'Something went wrong: <error>' on any other error
- always prints 'done' at the end

Test it with fetchUser() (takes 3 seconds, so it times out)
and fetchUser(fail: true).

Then answer: where did you put the 'done' print, and why?
*/
Future<String> fetchUser({bool fail = false}) async {
  await Future.delayed(const Duration(seconds: 3));
  if (fail) throw Exception('server error');
  return 'Alex';
}

Future<void> loadUser() async {
  // write code here
}
/*
Your answer:

*/

/*
========================================================
Q5. FLUTTER SCENARIO — FutureBuilder
========================================================

A teammate wrote this. The screen keeps calling the API
every time it rebuilds.

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) return Text('Error');
        return Text(snapshot.data ?? '');
      },
    );
  }

Questions:
- What is the bug and why does it happen?
- How do you fix it?
- When would you use FutureBuilder, and when would you load
  data in your controller instead?

Your answer:

*/

/*
========================================================
Q6. FLUTTER SCENARIO — API CALL IN initState
========================================================

  class _ProfileState extends State<Profile> {
    String? name;

    @override
    void initState() {
      super.initState();
      loadName();
    }

    Future<void> loadName() async {
      final result = await fetchUser();
      setState(() => name = result);
    }
    ...
  }

Questions:
- What can go wrong if the user leaves the screen before
  the response arrives? How do you fix it?
- How would you add loading and error states?
- Where do try/catch/finally go in loadName()?

Your answer:

*/

/*
========================================================
Q7. UNHANDLED ERRORS IN FLUTTER
========================================================

"A Future throws an error and nobody awaits it or catches
it. What happens, and how do you catch such errors
globally in a Flutter app?"

Your answer:

*/

/*
========================================================
Q8. Future<void> vs void
========================================================

"What is the difference between
  Future<void> foo() async { ... }
and
  void foo() async { ... }
Which is better and why?"

Your answer:

*/

/*
========================================================
END OF DAY 03 — REFLECTION
========================================================

1. Which of these questions could you answer confidently
   in an interview?
2. Which one made you hesitate?
3. What would you want me to cover more of next?

========================================================
*/

Future<void> main() async {
  // Run ONE question at a time.
  // q3();
  // await loadUser();
}