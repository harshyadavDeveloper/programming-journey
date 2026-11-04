/*
========================================================
   FLUTTER BLOC — DAY 02: COUNTER APP (EVENT, STATE, BLOC)
========================================================

Video covered: playlist video 5 (counter app with Bloc)

Topics:
- Abstract event class and concrete events
- Immutable state and copyWith
- Why state equality matters inside Bloc (emit)
- CounterBloc: generics, super(initial state), on<Event>, emit
- BlocProvider, BlocBuilder, context.read
- Which part of the UI rebuilds

IMPORTANT:
- Code shown in Q2, Q3 and Q5 sits inside comments. Those
  questions are predict-and-explain only.
- Q4 is real code you write. Add equatable and flutter_bloc
  to pubspec.yaml.
- Stick to today's video: no BlocListener, BlocConsumer,
  buildWhen or Cubit.
*/

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
========================================================
Q1. UMBRELLA THEORY — WHY EQUATABLE INSIDE BLOC
========================================================

Explain this as if answering an interview question.
Use the counter app as your example.

Cover these points:
- Why is the state immutable, and what is copyWith for?
- What does Bloc do when you emit a state that is equal
  to the current state?
- Why does that make Equatable important for states?
- What happens to rebuilds if the state does not use
  Equatable?
- Do events need Equatable? What does it change at
  runtime and what doesn't it change?

Your answer:
In BLoC, states are immutable because we should never modify the existing state directly. Instead, we create a new state whenever something changes. copyWith() 
helps us create a modified copy while keeping unchanged properties intact.
When we emit a state, BLoC checks whether it's equal to the current state. If both are equal, it suppresses the emission.
That's why Equatable is important for states. It compares objects based on their property values rather than memory references.
For example, if the counter is already 5 and we emit another state with count 5, Equatable considers them equal, so BLoC doesn't notify listeners.
Without Equatable, two different state objects with identical values are generally considered unequal, potentially causing unnecessary rebuilds.
Events don't necessarily need Equatable. It only provides value-based equality for events; it doesn't change normal event processing or state emissions.

*/

/*
========================================================
Q2. OUTPUT PREDICTION — RESET PRESSED THREE TIMES
========================================================

A third event is added to the counter app:

  class ResetCounterEvent extends CounterEvent {}

  void _reset(ResetCounterEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: 0));
  }

  class CounterState extends Equatable {
    final int counter;
    const CounterState({this.counter = 0});

    CounterState copyWith({int? counter}) {
      return CounterState(counter: counter ?? this.counter);
    }

    @override
    List<Object?> get props => [counter];
  }

Scenario: the counter currently shows 3. The user taps
Reset three times, one tap at a time. The screen has a
BlocBuilder<CounterBloc, CounterState>.

Version A: CounterState extends Equatable as above.
Version B: the same class with "extends Equatable" and
the props getter removed (a plain class).
*/
/*
Questions:
- Version A: how many new states reach the UI, and how
  many times does the BlocBuilder builder run because
  of the three taps?
- Version B: the same two numbers.
- Does the number shown on screen differ between A and B?
- Why does this matter in a real app with a large screen?

Your answer:
1. Version A: with equatables:
New states created: 3
States reaching the UI: 1
BlocBuilder rebuilds: 1
The first tap changes the counter from 3 to 0. The next two emissions are suppressed because the state value is already 0.

2. Version B — Without Equatable
- New states created: 3
- States reaching the UI: 3
- BlocBuilder rebuilds: 3
Each copyWith() creates a new object. Without Equatable, Dart compares object references, so all three states are considered different.

No. Both versions display 0. Only the number of state emissions and rebuilds differs.

Unnecessary rebuilds cause additional rendering work. On a large screen with multiple widgets, charts and lists, this can affect performance. Equatable helps 
avoid those unnecessary rebuilds.
*/

/*
========================================================
Q3. DEBUGGING — THE FROZEN COUNTER
========================================================

A teammate writes this to "save memory" by avoiding
copyWith:

  class MutableCounterState extends Equatable {
    int counter;
    MutableCounterState({this.counter = 0});

    @override
    List<Object?> get props => [counter];
  }

  class BrokenCounterBloc
      extends Bloc<CounterEvent, MutableCounterState> {
    BrokenCounterBloc() : super(MutableCounterState()) {
      on<IncrementCounterEvent>((event, emit) {
        state.counter++;
        emit(state);
      });
    }
  }

Symptom: the UI shows 1 after the first tap, then stays
at 1 forever, even though the value inside the Bloc
keeps going up.
*/
/*
Questions:
- Why does the UI stop updating after the first tap?
- Would removing Equatable from MutableCounterState fix
  it? Why or why not?
- What is the fix? Describe it in one or two lines,
  without rewriting the whole class.
- What rule does this teach about state classes?

Your answer:
- Because we are modifying the existing state object instead of creating a new one. When emit(state) is called, BLoC compares the state with itself, finds it equal 
and suppresses the emission.

- No. We are still emitting the same object reference. Removing Equatable doesn't solve the underlying problem of mutating the existing state.

- Make the state immutable and create a new state object whenever the counter changes, using copyWith().

- BLoC states should always be immutable. Never modify the existing state; always emit a new state when something changes.
*/

/*
========================================================
Q4. PRACTICAL — WRITE THE BLOC LAYER FROM MEMORY
========================================================

Without looking at the video or your old files, write
the following below.

1. abstract class CounterEvent extends Equatable
2. IncrementCounterEvent, DecrementCounterEvent and
   ResetCounterEvent
3. CounterState: one int counter that defaults to 0,
   a const constructor, copyWith, and props
4. CounterBloc that handles all three events

Write your code here:

*/
abstract class CounterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncrementCounterEvent extends CounterEvent {}

class DecrementCounterEvent extends CounterEvent {}

class ResetCounterEvent extends CounterEvent {}

class CounterState extends Equatable {
  final int counter;
  const CounterState({this.counter = 0});

  CounterState copyWith({int? counter}) {
    return CounterState(counter: counter ?? this.counter);
  }

  @override
  List<Object?> get props => [counter];
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<IncrementCounterEvent>(_increment);
    on<DecrementCounterEvent>(_decrement);
    on<ResetCounterEvent>(_reset);
  }

  void _increment(IncrementCounterEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: state.counter + 1));
  }

  void _decrement(DecrementCounterEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: state.counter - 1));
  }

  void _reset(ResetCounterEvent event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: 0));
  }
}

/*
Questions about your code:
- Why is CounterEvent abstract, and what does that let
  Bloc<CounterEvent, CounterState> accept?
- Why super(const CounterState())? What does Bloc need
  the initial state for?
- What does on<IncrementCounterEvent>(_increment) do?
- Where does `state` inside a handler come from, and why
  does a handler return nothing?

Your answer:
- Because it acts as a parent class for all counter events. We don't create CounterEvent directly; instead, we create specific events like Increment, Decrement 
and Reset.
It allows Bloc<CounterEvent, CounterState> to accept all event types derived from CounterEvent.

- It provides the initial state to BLoC.
Here, the counter starts at 0. BLoC needs an initial state so the UI has a valid state even before any event is triggered.

- It registers an event handler. Whenever BLoC receives an IncrementCounterEvent, it executes _increment.

- state is provided by the Bloc class, which maintains the current state.
A handler returns nothing because it uses emit() to publish a new state instead of returning the state directly.

*/

/*
========================================================
Q5. UI SIDE — LOGS, READ, PROVIDER
========================================================

Trimmed version of the counter screen:
*/
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});
  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  @override
  Widget build(BuildContext context) {
    print('main build');
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              print('builder run');
              return Text(state.counter.toString());
            },
          ),
          ElevatedButton(
            onPressed: () {
              print('increment tapped');
              context.read<CounterBloc>().add(IncrementCounterEvent());
            },
            child: Text('Increment'),
          ),
          ElevatedButton(
            onPressed: () {
              print('decrement tapped');
              context.read<CounterBloc>().add(DecrementCounterEvent());
            },
            child: Text('Decrement'),
          ),
        ],
      ),
    );
  }
}
/*
The app launches. The user taps Increment twice, then
Decrement once.
*/
/*
Questions:
- How many times does each line print:
  'main build', 'builder run', 'increment tapped',
  'decrement tapped'?
- Why does 'main build' not print again?
- Why is context.read used inside onPressed? What does
  it do and not do?
- Does CounterApp need to be a StatefulWidget? Explain.
- If no BlocProvider<CounterBloc> sits above this screen,
  what happens? Where should you place it so every
  screen can use the Bloc, and what is the downside of
  placing it lower in the tree?

Your answer:
output: main build: 1 time
        builder run: 4 time
        increment tapped: 2 times
        decrement tapped: 1 time

- Because the parent widget doesn't rebuild. BLoC manages the counter state independently, and BlocBuilder listens to state changes and rebuilds only its own UI.
- context.read() retrieves the nearest CounterBloc from the widget tree without subscribing to its state changes. We use .add() to dispatch an event to that BLoC.

*/

void main() {}

/*
========================================================
                  END OF DAY 02
========================================================
*/
