import 'dart:async';

// e.g.: debouncer example:

class MyDebouncer {
  final Duration delay;
  MyDebouncer(this.delay);
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel(); // cancel the previous pending call
    _timer = Timer(delay, action); // schedule a new one
  }

  void dispose() => _timer?.cancel();
}

/*
========================================================
   DART — DAY 05: STREAMS IN PRACTICE (INTERVIEW ROUND)
========================================================

Run ONE question at a time (Q2, Q3, Q4 are runnable).
Write your prediction BEFORE running the code.

========================================================
Q1. STREAM OPERATIONS
========================================================

An interviewer asks: "What operations can you perform on a
Stream, and what's the difference between map and
asyncMap?"

Cover:
- map, where, take, skip, distinct (what does distinct
  actually compare?)
- Which methods return a Future instead of a Stream?
- map vs asyncMap
- What is the type of
    Stream.fromIterable([1, 2]).map((n) async => n * 2)
  and why is that a bug?

Your answer:
Dart provides several operations to transform and filter streams.
- map() transforms each event.
- where() filters events based on a condition.
- take() takes a specified number of events.
- skip() ignores the first specified number of events.
- distinct() removes consecutive duplicate events by comparing the current event with the previous one.
Some operations like first, last, firstWhere, and toList return a Future because they collect a result from the stream.

The difference between map and asyncMap is that map is used for synchronous transformations, whereas asyncMap is used when the transformation involves a Future. 
It waits for each asynchronous operation and emits the results in order.
If we use an async callback with map, we get a Stream<Future<T>> instead of the expected Stream<T>

*/

/*
========================================================
Q2. PREDICT THE OUTPUT
========================================================
*/
Future<void> q2() async {
  Stream.fromIterable([1, 2, 2, 3, 4, 4, 5])
      .distinct() // 1 2 3 4 5
      .where((n) => n.isEven) // 2 4
      .map((n) => n * 10) // 20 40
      .listen((n) => print('chain: $n'));

  await Stream.fromIterable([1, 2, 3])
      .asyncMap((n) async {
        await Future.delayed(
          Duration(milliseconds: 100 * (4 - n)),
        ); // 300ms, 200ms, 100ms
        print('processed $n'); // 1 2 3
        return n * 2;
      })
      .forEach((v) => print('result: $v')); // 2 4 6
}
/*
Questions:
- What is the exact output?
- Why do the 'chain' lines come before 'processed 1'?
- The delays are 300, 200 and 100 ms. Why are the results
  still in order 2, 4, 6, and how long does the asyncMap
  part take in total?

Your answer:
chain: 20
chain: 40
processed 1
result: 2
processed 2
result: 4
processed 3
result: 6

total time takes is: 300 + 200 + 100 ms = 600ms(the delays happens sequentially and not simultaneously)

asyncMap preserves the order of the original stream events. It processes asynchronous transformations one at a time, waiting for the current Future before 
moving to the next event. So even if different operations have different delays, the output remains in the original order.

*/

/*
========================================================
Q3. LIVE CODING — DEBOUNCER
========================================================

Write a Debouncer class with:
- a constructor taking a Duration delay
- run(void Function() action): runs the action only after
  `delay` has passed with no new run() call
- dispose(): cancels any pending action

Test it: simulate typing 'f', 'fl', 'flu', 'flut' with 100 ms
between keystrokes (delay 300 ms), then wait 500 ms, then
type 'flutter'. Only the right searches should run.

Then answer:
- What is the difference between debounce and throttle?
- Which one would you use for a search box? For a
  "refresh" button the user might spam?
- Why must dispose() exist in a Flutter State?

Write your code below:
*/
class Debouncer {
  final Duration delay;
  Debouncer(this.delay);

  Timer? _timer;
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}

Future<void> q3() async {
  final _debouncer = Debouncer(Duration(milliseconds: 300));

  _debouncer.run(() => print('Search: f'));
  await Future.delayed(Duration(milliseconds: 100));
  _debouncer.run(() => print('Search: fl'));

  await Future.delayed(Duration(milliseconds: 100));
  _debouncer.run(() => print('Search: flu'));

  await Future.delayed(Duration(milliseconds: 100));
  _debouncer.run(() => print('Search: flut'));

  await Future.delayed(Duration(milliseconds: 500));
  _debouncer.run(() => print('Search: flutter'));

  await Future.delayed(Duration(milliseconds: 500));

  _debouncer.dispose();
}

/*
Your answer:
Debounce waits until the user stops triggering events for a certain duration before executing a callback. Every new event resets the timer. Throttle, on the 
other hand, limits how frequently a callback can execute within a given time period.

Debounce is useful for search boxes, whereas throttle is useful for events like scrolling or limiting repeated actions.

We dispose the debouncer when the widget is destroyed to cancel any pending timer and prevent callbacks from executing after the widget's lifecycle has ended.

*/

/*
========================================================
Q4. SCENARIO — THE SEARCH RACE
========================================================

Predict the exact output.
*/
Future<String> search(String q) async {
  await Future.delayed(Duration(milliseconds: q.length == 1 ? 300 : 100));
  return 'results for $q';
}

Future<void> q4() async {
  var shown = '';
  Future<void> onChanged(String q) async {
    final result = await search(q);
    shown = result;
    print('UI shows: $shown');
  }

  onChanged('a');
  await Future.delayed(const Duration(milliseconds: 50));
  onChanged('ab');
  await Future.delayed(const Duration(milliseconds: 500));
  print('final UI: $shown');
}

/*
Questions:
- What is the output? What does the user end up seeing?
- Why does this happen even though the user typed 'a'
  first and 'ab' last?
- Fix it with a "latest query" guard (rewrite onChanged).
- Which operator (rxdart) or Bloc feature solves the same
  problem, and what does it do?

Your answer: 
UI shows: results for ab
UI shows: results for a
final UI: results for a
even after user types ab he ends up seeing result for a.

This is a race condition because asynchronous requests can complete in a different order than they were initiated. An older request can overwrite the result of a
newer request.
I can solve it using a latest-query guard, where I compare the query associated with the completed request against the latest query.
In RxDart, switchMap switches to the latest inner stream and stops forwarding events from the previous one. In BLoC, restartable() provides similar behavior 
by cancelling the previous event handler's ability to emit and handling the latest event instead

*/
Future<void> q4Fixed() async {
  var shown = '';
  String latestQuery = '';

  Future<void> onChanged(String q) async {
    latestQuery = q;

    final result = await search(q);

    if (q != latestQuery) return;

    shown = result;
    print('UI shows: $shown');
  }

  onChanged('a');
  await Future.delayed(Duration(milliseconds: 50));
  onChanged('ab');

  await Future.delayed(Duration(milliseconds: 500));
  print('final UI: $shown');
}

/*
========================================================
Q5. DESIGN — SEARCH AS YOU TYPE
========================================================

"Design a search-as-you-type screen in Flutter. What do you
do about API calls, stale results, loading and error states,
and cleanup?"

Your answer:
First, when to call the API. I don’t call it on every keystroke. I debounce the input, around 300 milliseconds, and I ignore very short queries. 
If the field is emptied, I just reset the screen.

Second, which response to trust. Debounce alone doesn’t solve stale results, because responses can come back out of order. A slow request for ‘a’ could 
overwrite the results for ‘abc’. So I use a restartable transformer or switchMap, or a simple latest-query check, so an old response is ignored. If the HTTP client supports cancellation, I’d also cancel the old request.

Third, what the user sees. The screen is driven by states: initial, loading, success with results, an empty-results message, and failure with a retry option. 
The UI just renders the current state.

Fourth, cleanup. With Bloc, the package closes its streams. In a plain StatefulWidget I’d cancel the debounce timer in dispose() and check mounted after any await.

In Bloc, that means one event, SearchQueryChanged, a debounce-plus-switchMap transformer, and a handler that emits loading, then success or failure.

TODO: to be implemented later(it is like a mini project initself)

*/

/*
========================================================
Q6. BLOC / CUBIT AND STREAMS
========================================================

Questions:
- How do Cubit/Bloc use streams under the hood?
- You emit a new state that is equal (==) to the current
  one. What happens in the UI? Why is Equatable (or
  overriding ==/hashCode) usually needed?
- After an await in a Cubit method the screen was closed.
  What can go wrong when you call emit, and how do you
  guard against it?
- Based on what you use (Provider + ChangeNotifier): when
  would you stay with that, and when would you choose
  Bloc or streams?

Your answer:
- Cubit and Bloc use Streams to expose state changes to the UI.
Cubit has methods that directly emit new states, whereas Bloc follows an event-driven approach where events are added and then processed to produce states.
Internally, both use a stream of states which widgets can subscribe to, allowing the UI to react whenever a new state is emitted.
Since the state stream is a broadcast stream, multiple listeners can subscribe to it. However, it doesn't replay all previous state emissions to a new listener 
by default. The current state can still be accessed through the Cubit or Bloc instance.

- Bloc and Cubit use equality to determine whether a new state is different from the current state.
If the new state is equal to the current state, the emission is generally suppressed, so the UI doesn't receive another state change and doesn't rebuild 
in response to that emission.
In Dart, objects generally use identity-based equality by default, meaning two separate objects with the same values aren't necessarily considered equal.
That's why we commonly use Equatable or override == and hashCode. It allows us to compare objects based on their values instead of their identity, 
helping avoid unnecessary state emissions and reducing boilerplate code.

- When an asynchronous operation is running, the Cubit might be closed before the operation completes.
For example, I might start an API call, but before it completes, the screen or the component owning that Cubit gets disposed and the Cubit is closed.
When the API call completes, if I try to emit a new state from that closed Cubit, it can throw a StateError.
To prevent this, I can check isClosed after the asynchronous operation completes and return early if the Cubit is already closed.
isClosed is used with Bloc or Cubit, whereas mounted is used with a Flutter StatefulWidget's State object.

- I would stick with Provider and ChangeNotifier for relatively simple applications or features where state management is straightforward, and I don't 
need to manage complex event flows.
When the application becomes more complex, with multiple events, workflows and state transitions that need to be predictable and easier to test, I would consider Bloc.
For features involving continuous data, such as chats, socket connections or live updates, Streams are particularly useful. I can use Streams directly or integrate
them with Bloc depending on the complexity of the feature.
I don't believe one state management solution is always better than another. I would choose based on the complexity, maintainability and requirements of the application.

*/

/*
========================================================
Q7. COMBINING STREAMS
========================================================

"A screen depends on two streams: the logged-in user and the
app settings. How do you build the UI from both? Does Dart
have a built-in way to combine streams?"

Cover:
- What is missing from Dart's core library?
- Name one package and one operator for combining
  (what does combineLatest do?)
- What does BehaviorSubject (rxdart) fix compared with a
  plain broadcast StreamController?

Your answer:
If a screen depends on multiple streams, such as the logged-in user and app settings, I can combine those streams to build the UI from both data sources.
Dart's core Stream API doesn't provide a built-in combineLatest operator, so I can use a package like RxDart.
RxDart provides combineLatest operators, such as combineLatest2, which wait until both streams have emitted at least once. After that, whenever either stream 
emits a new value, it combines that value with the latest value from the other stream and emits a new combined result.
RxDart also provides BehaviorSubject, which retains the latest emitted value and delivers it to new subscribers. This is useful compared with a plain broadcast 
StreamController, where listeners joining late don't receive previously emitted events.

Note: A BehaviorSubject doesn't replay all past events. It replays only its latest value.

*/

/*
========================================================
END OF DAY 05 — REFLECTION
========================================================

1. Which of these questions could you answer confidently
   in an interview?
2. Which one made you hesitate?
3. What would you want me to cover more of next?

========================================================
*/

Future<void> main() async {
  // Run ONE question at a time.
  // await q2();
  // await q3();
  await q4();
  await q4Fixed();
}
