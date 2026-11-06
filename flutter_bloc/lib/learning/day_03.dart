/*
========================================================
   FLUTTER BLOC — DAY 03: MULTIPLE STATES + buildWhen
========================================================

Video covered: playlist video 6 (switch + slider app)

Topics:
- State with more than one field
- Events that carry values
- When a handler reads from state vs from the event
- MultiBlocProvider
- buildWhen
- Equatable vs buildWhen (two different layers)

IMPORTANT:
- Code shown in Q2, Q3, Q4 and Q6 sits inside comments.
  Those are predict-and-explain only.
- Q5 is real code you write. Add equatable and flutter_bloc
  to pubspec.yaml.
- Stick to today's video: no BlocListener, BlocConsumer,
  listenWhen or context.select.
*/

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
========================================================
Q1. UMBRELLA THEORY — EQUATABLE vs buildWhen
========================================================

Explain this as if answering an interview question.
Use the switch + slider app as your example.

Cover these points:
- Before buildWhen was added, why did the notification
  switch rebuild when only the slider moved?
- What does buildWhen receive, what does returning true
  or false mean, and who owns it (the Bloc or the
  BlocBuilder)?
- What is the difference between what Equatable does and
  what buildWhen does?
- Why can't Equatable alone fix the problem?
- What does buildWhen actually save? Is it required for
  the app to work?

Your answer:
- Equatable and buildWhen serve two different purposes in BLoC.
Equatable is used for value-based equality in state classes. It helps BLoC determine whether a newly emitted state is actually different from the current state.
For example, in a settings app, suppose we have a notification switch and a volume slider. When the slider changes from 50 to 60, the overall state changes,
so Equatable correctly identifies the two states as different
However, the notification switch doesn't need to rebuild because its value hasn't changed.
That's where buildWhen comes in. It is a parameter of BlocBuilder that receives the previous and current states and decides whether the widget should rebuild.
If it returns true, the builder executes. If it returns false, that particular BlocBuilder skips the rebuild.
So, Equatable handles state equality, whereas buildWhen controls UI rebuilds based on state changes.
buildWhen helps reduce unnecessary widget rebuilds and improves UI performance. However, it is optional and not required for the app's functionality

*/

/*
========================================================
Q2. OUTPUT PREDICTION — WHO REBUILDS WHEN
========================================================

The screen has three BlocBuilder<SwitchBloc, SwitchState>
widgets. Each one prints its letter when its builder runs:

  A) Notification switch
     buildWhen: previous.switchValue != current.switchValue
     prints 'A'

  B) Red box (opacity depends on state.slider)
     NO buildWhen
     prints 'B'

  C) Slider
     buildWhen: previous.slider != current.slider
     prints 'C'

Scenario, in this order:
  1. The app launches.
  2. The user toggles the switch once.
  3. The user drags the slider through three different
     values (three events).
  4. The user toggles the switch once more. 
*/
/*
Questions:
- How many times does each of A, B and C print in total?
- Which builder rebuilds more than it needs to?
- What one-line change fixes it?

Your answer:
- output:
A,	3,	Initial build + 2 switch changes
B,	6,	Initial build + every state emission
C,	4,	Initial build + 3 slider changes

- B Red Box - It has no buildWhen, so it rebuilds whenever it receives a new state, even though its opacity only depends on the slider.
- one-line-fix: buildWhen: (previous, current) =>
    previous.slider != current.slider,

- 
*/

/*
========================================================
Q3. DEBUGGING — THE SLIDER THAT WON'T MOVE
========================================================

A teammate writes the state like this:

  class SwitchState extends Equatable {
    final bool switchValue;
    final double slider;

    const SwitchState({this.switchValue = false, this.slider = 0.4});

    SwitchState copyWith({bool? switchValue, double? slider}) {
      return SwitchState(
        switchValue: switchValue ?? this.switchValue,
        slider: slider ?? this.slider,
      );
    }

    @override
    List<Object?> get props => [switchValue];
  }

Symptom: the user toggles the switch once and it works.
Then the user drags the slider: the thumb does not move
and the red box does not change.
*/
/*
Questions:
- Why does the UI ignore the slider events?
- Is anything wrong with the Slider widget, the
  handler or buildWhen? Why or why not?
- What is the one-line fix?
- Which Day 01 bug is this a cousin of?

Your answer:
- In this scenario, the problem is that we have forgotten to include the slider property in the Equatable props list.
- In Dart, objects use identity-based equality by default, but Equatable overrides the equality behaviour to provide value-based comparison.
- However, Equatable only compares the properties that we define inside the props list. It doesn't automatically compare every property of our class.
- For example, if the previous state has switchValue = true and slider = 0.4, and the new state has switchValue = true and slider = 0.8, Equatable compares only 
switchValue because that's the only property in props.
- Since both switch values are true, Equatable considers these two states equal, even though the slider value has changed.
- BLoC uses state equality when emitting new states. Since the new state is considered equal to the current state, the emission gets suppressed. As a result, 
the UI doesn't receive the updated state, so neither the slider thumb nor the red box updates
- There is nothing wrong with the Slider widget, event handler, or buildWhen. The issue is entirely in the state equality definition
- The fix is to include both properties in the props list:
@override
List<Object?> get props => [switchValue, slider];
*/

/*
========================================================
Q4. DEBUGGING — TWO WRONG buildWhen CONDITIONS
========================================================

Mistake 1: on the slider widget, a teammate writes

  buildWhen: (previous, current) =>
      previous.slider == current.slider,

Mistake 2: on the notification switch, another teammate
writes

  buildWhen: (previous, current) => previous != current,
*/
/*
Questions:
- Mistake 1: what does the user see while dragging the
  slider? What happens when the switch is toggled?
- What does returning true from buildWhen mean?
- Mistake 2: does this stop the switch from rebuilding
  when only the slider moves? Why or why not?
  (Hint: think about the Day 02 emit rule.)

Your answer:
- In the first mistake, the developer has used the equality operator instead of the inequality operator in buildWhen. As a result, the slider rebuilds when its 
value hasn't changed, rather than when it actually changes. During slider dragging, the condition returns false, so the slider doesn't update through that builder. 
When only the switch changes, the condition returns true, causing an unnecessary slider rebuild.

- In the second mistake, the developer compares the entire previous and current states using previous != current. This doesn't solve the problem because 
Equatable compares all the properties defined in props. When the slider changes, the overall state becomes different, so the condition returns true and 
the notification switch still rebuilds.

The correct approach is to compare only the property that the particular widget depends on.

This is why buildWhen should use property-specific comparisons rather than comparing the entire state

*/

/*
========================================================
Q5. PRACTICAL — WRITE THE SWITCH BLOC FROM MEMORY
========================================================

Without looking at the video or your old files, write:

1. abstract class SwitchEvent extends Equatable
2. SwitchNotification (carries no data)
3. SliderEvent (carries a double called slider)
4. SwitchState: bool switchValue defaulting to false,
   double slider defaulting to 0.4, a const constructor,
   copyWith for both fields, and props
5. SwitchBloc with a handler for each event

Write your code here:

*/
abstract class SwitchEvent extends Equatable {
  const SwitchEvent();

  @override
  List<Object?> get props => [];
}

class SwitchNotification extends SwitchEvent {}

class SliderEvent extends SwitchEvent {
  final double slider;
  const SliderEvent({required this.slider});

  @override
  List<Object?> get props => [slider];
}

class SwitchState extends Equatable {
  final bool switchValue;
  final double slider;
  const SwitchState({this.switchValue = false, this.slider = 0.4});

  SwitchState copyWith({bool? switchValue, double? slider}) {
    return SwitchState(
      switchValue: switchValue ?? this.switchValue,
      slider: slider ?? this.slider,
    );
  }

  @override
  List<Object?> get props => [switchValue, slider];
}

class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  SwitchBloc() : super(const SwitchState()) {
    on<SwitchNotification>(_handleNotification);
    on<SliderEvent>(_handleSlider);
  }

  void _handleNotification(
    SwitchNotification event,
    Emitter<SwitchState> emit,
  ) {
    emit(state.copyWith(switchValue: !state.switchValue));
  }

  void _handleSlider(SliderEvent event, Emitter<SwitchState> emit) {
    emit(state.copyWith(slider: event.slider));
  }
}

/*
Questions about your code:
- The toggle handler reads from state, but the slider
  handler reads from the event. What is the rule for
  choosing?
- In the slider handler, what would
  emit(state.copyWith(slider: state.slider)) do? Why?
- Why are both copyWith parameters nullable and optional?
- Should SliderEvent include slider in its props? What
  changes at runtime, and what changes in tests?

Your answer:
- Read from state when you need the existing value to calculate the next value.
Read from event when the event carries the new value supplied by the user.

- Suppose the current slider value is 0.4.
You're copying the state and assigning the same slider value, 0.4. 
The resulting state is equal to the current state according to Equatable because both properties remain unchanged.

- Because we want to update only the properties we need without changing the remaining properties.

- Yes! Absolutely. BLoC processes events through its event stream. It does not generally suppress incoming events simply because they are equal according to Equatable.
So even without overriding props, both slider events can be processed and update the state correctly.

- Equatable becomes important when comparing expected and actual events. Without slider in props, events carrying different values can compare equal, potentially
 causing incorrect test results.
*/

/*
========================================================
Q6. MULTIBLOCPROVIDER
========================================================

Your app now has CounterBloc (Day 02) and SwitchBloc.
Write, as a comment below, how you would register both
with MultiBlocProvider at the app root. CounterBloc lives
in your Day 02 file, so don't write this as live code.

Questions:
- What problem does MultiBlocProvider solve?
- Does it change behavior compared with nesting two
  BlocProviders?
- A Bloc is provided only on one screen. What is the
  downside, and what is the downside of providing
  everything at the root?

Your answer:
MultiBlocProvider is used to register multiple BLoC or Cubit providers at a common location without manually nesting multiple BlocProviders.
For example, if an application has CounterBloc and SwitchBloc, we can register both inside a single MultiBlocProvider at the application root.
It doesn't change the actual behaviour compared with nesting individual BlocProviders. It's mainly a cleaner and more maintainable way of organising providers.
Regarding placement, if we provide a BLoC only on one screen, other screens outside its provider scope cannot directly access that instance.
On the other hand, providing every BLoC at the application root can unnecessarily increase its lifetime and make dependency management harder.
So, we should provide BLoCs at the appropriate level based on where they are actually needed.
*/

void main() {}

/*
========================================================
                  END OF DAY 03
========================================================
*/
