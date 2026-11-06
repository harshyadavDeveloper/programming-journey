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
- In Dart, async and await are used to handle asynchronous operations without blocking the execution flow.
- An async function always returns a Future. If I return a normal value like a String or int, Dart automatically wraps it in a completed Future. If I return another 
Future, Dart adopts its result rather than creating a nested Future<Future<T>>.
- await pauses the execution of the current async function until the Future completes successfully. Once completed, execution resumes from the next line with 
the returned value.
- No. async/await does not create a new thread. It suspends the current async function and gives control back to the event loop. Therefore, it does not block
 the UI while waiting for an asynchronous operation.
- We use try-catch to handle exceptions and finally for cleanup operations, such as hiding a loading indicator.
- Both handle Futures and provide the same asynchronous functionality. then() uses callback chaining, whereas async/await provides cleaner, more readable code 
and makes asynchronous operations easier to maintain.

*/

/*
========================================================
Q2. IS async THE SAME AS PARALLEL?
========================================================

"If I make a function async, does it run in parallel?
Why can my UI still freeze when I use async code, and
what is the fix?"

Your answer:
No. async doesn’t run anything in parallel. It lets a function pause at await, so the single thread can do other work while it 
waits for something external, like the network, a file or a timer. Dart code inside one isolate runs on one thread. So async 
helps with waiting (I/O-bound work), not with heavy computation (CPU-bound work).

The UI can still freeze because code between awaits runs on the UI thread. Parsing a huge JSON response, processing an image, 
or a big loop inside an async function blocks the event loop, so frames get dropped, and Flutter has about 16 ms per frame at 
60 Hz. The network call itself doesn’t freeze the UI, because native code does that waiting.

The fix is to move the heavy work to another isolate, with Isolate.run() or Flutter’s compute()

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

Your answer:
ouput: main start
       fetch start
       main end 
       fetch end 
- When q3() executes, main start is printed first
- Then fetchData() is called. Since an async function executes synchronously until it encounters its first await, fetch start is printed immediately.
- When execution reaches await Future.delayed(), the function suspends and returns control to the caller.
- The remaining synchronous code in q3() continues executing, so main end is printed. 
- After one second, the Future completes, and execution resumes inside fetchData(), printing fetch end 

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

Future<void> loadUser({bool fail = false}) async {
  try {
    final name = await fetchUser(
      fail: fail,
    ).timeout(const Duration(seconds: 2));

    print('Hello $name');
  } on TimeoutException {
    print('Request timed out');
  } catch (e) {
    print('Something went wrong: $e');
  } finally {
    print('done');
  }
}
/*
Your answer:
Because finally always executes, regardless of whether:
- The Future completes successfully.
- A timeout occurs.
- Another exception is thrown.
This makes it perfect for cleanup operations, such as hiding a loader or closing resources.

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
- The issue is that the API call is inside the build method. Since Flutter can rebuild widgets multiple times, every rebuild creates a new Future and can 
trigger another API request.

- I would fix this by storing the Future in a variable and initializing it inside initState. This ensures that the same Future is reused during rebuilds.

- I use FutureBuilder for simple, screen-specific asynchronous operations. For complex business logic or shared application data, I prefer using a state management 
solution like Provider with a controller, keeping API logic separate from the UI

*/

// class UserPage extends StatefulWidget {
//   const UserPage({super.key});

//   @override
//   State<UserPage> createState() => _UserPageState();
// }

// class _UserPageState extends State<UserPage> {
//   late Future<String> userFuture;

//   @override
//   void initState() {
//     super.initState();
//     userFuture = fetchUser();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: userFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }

//         if (snapshot.hasError) {
//           return const Text('Error');
//         }

//         return Text(snapshot.data ?? '');
//       },
//     );
//   }
// }

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
If the user navigates away before the API response arrives, the asynchronous operation can still complete. If we call setState on a disposed widget, 
Flutter throws a setState called after dispose error.
I handle this using the mounted property, which checks whether the State object is still active before calling setState.
For loading and error handling, I maintain an isLoading Boolean and an error variable.
Inside loadName(), I use try for the API call, catch for handling exceptions, and finally to reset the loading state. I also check mounted before updating the UI.
*/

// class _ProfileState extends State<Profile> {
//   String? name;
//   String? error;

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadName();
//   }

//   Future<void> loadName() async {
//     try {
//       final result = await fetchUser();

//       if (!mounted) return;

//       setState(() {
//         name = result;
//       });

//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         error = e.toString();
//       });

//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (error != null) {
//       return Center(child: Text('Error: $error'));
//     }

//     return Center(child: Text(name ?? 'No name found'));
//   }
// }

/*
========================================================
Q7. UNHANDLED ERRORS IN FLUTTER
========================================================

"A Future throws an error and nobody awaits it or catches
it. What happens, and how do you catch such errors
globally in a Flutter app?"

Your answer:
- If a Future completes with an error and nobody handles it, the error is reported as an uncaught async error. In a plain Dart 
program, that terminates it. In a Flutter app, it’s logged and the app keeps running, so the problem can go unnoticed in 
production.

For global handling there are two hooks: FlutterError.onError for errors inside the framework (build, layout, gestures), and 
PlatformDispatcher.instance.onError for uncaught async errors. I use them to send errors to Crashlytics or Sentry. 
runZonedGuarded is the older way, and PlatformDispatcher.instance.onError is the recommended one now

FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true; // handled
};
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
Answer: Future<void> vs void in Dart
In Dart, both can be used with async functions, but the main difference is whether the function exposes a Future to the caller.
- Future<void>: Returns a Future without a meaningful value. The caller can use `await` to wait for completion and `try-catch` to handle errors.
- void async: Performs asynchronous operations internally but does not expose the Future to the caller. Therefore, the caller cannot await its completion 
or directly catch errors through the returned Future.
I prefer `Future<void>` for asynchronous functions because it allows proper error handling, waiting for completion and coordinating multiple asynchronous operations.
I use `void` mainly for synchronous functions or callbacks where no return value is expected.

Example:

Future<void> saveData() async {
  await Future.delayed(const Duration(seconds: 2));
  print('Data saved');
}

Future<void> main() async {
  await saveData();
  print('Done');
}

Output:
Data saved
Done

- 
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
  //  print('TEST 1: Timeout');
  // await loadUser();

  // print('\nTEST 2: Server Error');
  // await loadUser(fail: true);
}
