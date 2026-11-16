import 'dart:async';

/*
========================================================
   DART — DAY 04: STREAMS (INTERVIEW ROUND)
========================================================

Run ONE question at a time (Q3, Q4, Q5 are runnable).
Write your prediction BEFORE running the code.

========================================================
Q1. EXPLAIN STREAMS
========================================================

An interviewer asks: "Explain Streams in Dart."

Cover:
- What is a Stream, and what kinds of events does it have?
- How is it different from a Future?
- Single-subscription vs broadcast
- How do you create one, and how do you consume one?
- How do you stop listening?

Your answer:
A Stream in Dart is a sequence of asynchronous events that are delivered over time. It can emit three types of events: data, error, and done.
Unlike a Future, which delivers a single result or error, a Stream can deliver multiple values over time.
Dart has two types of streams:
- Single-subscription: Allows only one listener. Once subscribed, another listener cannot be added.
- Broadcast: Allows multiple listeners, but listeners only receive events emitted while they are subscribed.
We can create streams using StreamController, async* with yield, or Stream.periodic.
To consume a stream, we can use listen(), which provides callbacks like onData, onError, and onDone.
We can also use await for to consume stream events sequentially inside an asynchronous function.
Finally, we can manage a stream subscription using pause(), resume(), and cancel(). Calling cancel() stops listening to the stream.

*/

/*
========================================================
Q2. SCENARIO — "Stream has already been listened to"
========================================================

Two widgets on the same screen both call listen() on the
same connectivity stream (created with a plain
StreamController). The app crashes with:

  Bad state: Stream has already been listened to.

Questions:
- Why does this happen?
- Give two ways to fix it.
- What is the catch with broadcast streams that you should
  tell the interviewer about?

Your answer:
- The error occurs because a normal StreamController creates a single-subscription stream by default, which allows only one listener. When both widgets try to 
listen to the same stream, the second subscription throws a Bad State exception.
- There are two ways to solve this:
First, we can use a broadcast stream by calling .broadcast() on the StreamController, which allows multiple listeners.
Second, we can maintain a single subscription in a shared controller or parent widget and distribute the received data to both widgets using state management.
- However, the catch with broadcast streams is that they don't buffer events. If a listener subscribes after an event has already been emitted, it won't receive 
that previous event. It only receives future events while subscribed.

*/

/*
========================================================
Q3. PREDICT THE OUTPUT
========================================================
*/
void q3a() {
  final c = StreamController<int>();
  c.add(1);
  c.add(2);
  c.stream.listen((v) => print('listener: $v'));
  c.add(3);
  print('end of q3a');
}

void q3b() {
  final c = StreamController<int>.broadcast();
  c.add(1);
  c.add(2);
  c.stream.listen((v) => print('listener: $v'));
  c.add(3);
  print('end of q3b');
}
/*
Questions:
- What does each version print?
- Why is the output different?
- Does the listener run inside add(), or later? Why does
  'end of ...' appear where it does?

Your answer:
output: for q3a: end of q3a
                 listener: 1
                 listener: 2
                 listener: 3

output: for q3b: end of q3b
            listener: 3

Single-subscription: If we add events before attaching a listener, those events are stored. When the listener attaches, it receives those stored events too.
Broadcast: If we add events before attaching a listener, those events are lost. The listener only receives new events after it subscribes.
Why does print('end') come first? Because add() doesn't execute the listener immediately. It schedules the event to be delivered later. 
Meanwhile, normal synchronous code continues executing.
*/

/*
========================================================
Q4. PREDICT THE OUTPUT — ERRORS
========================================================
*/
void q4() {
  final c = StreamController<String>();
  c.stream.listen(
    (m) => print('data: $m'),
    onError: (e) => print('error: $e'),
    onDone: () => print('done'),
  );
  c.add('hi');
  c.addError('oops');
  c.add('bye');
  c.close();
}
/*
Questions:
- What is the output? Does the error stop the stream?
- What changes if you add cancelOnError: true to listen()?
  Is onDone still called?
- How does an error behave inside an await for loop?

Your answer:
output: 
data: hi
error: oops
data: bye
done

By default, an error doesn't stop a Dart stream. We can handle it using the onError callback, and the stream continues receiving events. If we set cancelOnError 
to true, the subscription is cancelled on the first error, and onDone is not called. With await for, an error is thrown and terminates the loop, so we handle
it using try-catch

*/

/*
========================================================
Q5. LIVE CODING — async* AND CANCELLING
========================================================

Write countdown(int from): a Stream<int> using async* that
emits from, from-1, ..., 1 with a short delay between values.
Add a finally block that prints 'countdown cleanup'.

Consume it two ways:
1. With await for, printing each value.
2. With listen(), cancelling the subscription after the
   second value.

Then answer:
- When does the code inside countdown start running?
- When does 'countdown cleanup' print in each case?
- Why is async* better here than a StreamController?

Write your code below:
*/
Stream<int> countdown(int from) async* {
  try {
    for (int i = from; i >= 1; i--) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  } finally {
    print('countdown cleanup');
  }
}

Future<void> q5() async {
  await for (int num in countdown(5)) {
    print(num);
  }
  late StreamSubscription<int> subscription;
  int count = 0;

  subscription = countdown(5).listen((n) {
    print(n);
    count++;

    if (count == 2) {
      subscription.cancel();
    }
  });
}

/*
Your answer:
- The code starts running when someone subscribes to the stream, not when we simply call countdown(5).
- With await for: After the countdown finishes naturally (after printing 1).
- With listen(): When we cancel the subscription (in our example, after receiving the second value).
The finally block runs in both cases.
- async* makes creating streams easier. We can use normal loops, await, and yield to generate values.
With StreamController, we have to manually add events using add() and close the controller using close().
For something like a countdown, async* is simpler and requires less code.

*/

/*
========================================================
Q6. FLUTTER SCENARIO — StreamBuilder
========================================================

  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      builder: (context, snapshot) {
        return Text('${snapshot.data}');
      },
    );
  }

Questions:
- What is wrong with creating the stream here?
- How do you fix it?
- What does the screen show before the first event, and
  how would you handle loading, error and data states
  using the snapshot?
- Does StreamBuilder cancel its subscription for you?

Your answer:
- StreamBuilder is a Flutter widget that listens to a Stream and rebuilds its UI whenever new data arrives.
- We should avoid creating a new stream directly inside the build method because build can execute multiple times, which may create unnecessary 
streams and subscriptions. Instead, we should create the stream once, for example in initState(), and reuse it.

- Using AsyncSnapshot, we can handle loading, error and data states. Before the first event, we can show a loading indicator using ConnectionState.waiting. Before 
the first event here it will show null becasue then snapshot.hasData is false.

- StreamBuilder also manages its subscription automatically. It cancels the subscription when the widget is disposed or when the stream changes. 

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late final Stream<int> counterStream;

  @override
  void initState() {
    super.initState();

    counterStream =
        Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: counterStream,
      builder: (context, snapshot) {
        return Text('${snapshot.data}');
      },
    );
  }
}
*/

/*
========================================================
Q7. FLUTTER SCENARIO — MANUAL listen()
========================================================

  class _ChatState extends State<Chat> {
    @override
    void initState() {
      super.initState();
      chatService.messages.listen((m) {
        setState(() => messages.add(m));
      });
    }
    ...
  }

Questions:
- What goes wrong when the user leaves the screen?
- Show the corrected State class (stored subscription,
  dispose, mounted).
- If you own the StreamController, what else must you do
  in dispose()?

Your answer:
- When manually listening to a stream inside a StatefulWidget, we should store the StreamSubscription so that we can cancel it when the widget is disposed
Otherwise, the subscription may continue receiving events after the screen is removed, potentially causing memory leaks or setState called after dispose errors

- I store the subscription in initState and cancel it in dispose. I can also check the mounted property before calling setState to ensure the widget is still active.
- If I own the StreamController, I should also close it in dispose. However, I should not close a controller owned by another service


class _ChatState extends State<Chat> {
  StreamSubscription<String>? _subscription;

  final List<String> messages = [];

  @override
  void initState() {
    super.initState();

    _subscription = chatService.messages.listen((m) {
      if (!mounted) return;

      setState(() {
        messages.add(m);
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}


*/

/*
========================================================
Q8. FUTURE OR STREAM?
========================================================

"Give three Flutter examples where you'd use a Stream and
three where you'd use a Future. How would you decide?"

Your answer:
In Flutter, I use a Future when I expect a single result from an asynchronous operation, and a Stream when I expect multiple values or continuous updates over time.
Future examples:
1. Fetching dashboard data from an API.
2. Adding a new user to the database.
3. Performing an add-to-cart API request. 

In all these cases, the operation completes with a single result.

Stream examples:
1. Chat applications, where new messages arrive continuously.
2. Live location tracking, where location updates are received continuously.
3. Real-time database updates, where I need to listen for changes in data.

I decide based on how the data is delivered. If I need one asynchronous result, I use Future. If I need to listen for multiple values over time, I use Stream

*/

/*
========================================================
END OF DAY 04 — REFLECTION
========================================================

========================================================
*/

Future<void> main() async {
  // Run ONE question at a time.
  // q3a();
  // q3b();
  // q4();
  // await q5();
}
