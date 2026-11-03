/*
========================================================
       FLUTTER BLOC — DAY 01: EQUATABLE + BLOC BASICS
========================================================

Topics:
- Default == (identity) vs value equality
- Overriding == and hashCode manually
- Equatable and props
- UI, events, states, and the Bloc
- Why Bloc is scalable and testable

IMPORTANT:
- No Bloc code today, only theory.
- Add equatable to pubspec.yaml before running.
- Q2 has six outputs. Predict them BEFORE running.
- Do not use const when creating objects unless told to.
*/

import 'package:equatable/equatable.dart';

/*
========================================================
Q1. UMBRELLA THEORY — WHY EQUATABLE EXISTS
========================================================

Explain this as if answering an interview question.

Cover these points:
- What does == do by default for your own class?
- What is the difference between identity equality and
  value equality?
- What is the relationship between == and hashCode?
- What did we have to write by hand without Equatable?
- What does Equatable do for us, and what is props?

Your answer:
- By default, == in Dart compares object identity (memory reference), not the actual property values.
- Identity Equality: Checks whether two variables refer to the same object in memory. Value Equality: Checks whether two objects have the same property values, 
regardless of whether they are different instances.
- Both are used to determine object equality and identify objects efficiently in collections like HashSet and HashMap
- Important notes: If two objects are equal (== returns true), they must have the same hashCode, If two objects have the same hashCode, they are not necessarily equal. 
- two things: operator == -> to compare objects by their property values, to generate a consistent hash based on those properties.
- Equatable is a Dart package that eliminates boilerplate code by automatically implementing value-based equality (==) and hashCode for our classes.
props is a list of properties that Equatable uses to determine whether two objects are equal and to generate their hash codes.
*/

/*
========================================================
Q2. OUTPUT PREDICTION — IDENTITY, EQUATABLE, SETS
========================================================
*/
class PlainStudent {
  final String name;
  final int age;
  PlainStudent(this.name, this.age);
}

class EqStudent extends Equatable {
  final String name;
  final int age;
  const EqStudent(this.name, this.age);

  @override
  List<Object?> get props => [name, age];
}

void q2() {
  final a1 = PlainStudent("Sam", 20);
  final a2 = PlainStudent("Sam", 20);
  final a3 = a1;
  final b1 = EqStudent("Sam", 20);
  final b2 = EqStudent("Sam", 20);

  print(a1 == a2);
  print(a1 == a3);
  print(identical(b1, b2));
  print(b1 == b2);
  print({a1, a2}.length);
  print({b1, b2}.length);
}
/*
Questions:
- What are the six outputs?
- What does identical() check?
- Why is b1 == b2 true while identical(b1, b2) is false?
- Why do the two Sets have different lengths?
  (Hint: Sets use hashCode first, then ==.)

Your answer:
output: false
        true
        false
        true
        2
        1
- Checks whether two references point to the exact same object in memory.
- because == uses value equality through Equatable and indentical checks the object identity: same values different objects.
- PlainStudent: Different object identities → both elements remain.
EqStudent: Same property values → considered equal → only one remains.
*/

/*
========================================================
Q3. DEBUGGING — THE SILENT BUG
========================================================
*/
class Product extends Equatable {
  final String title;
  final double price;
  const Product({required this.title, required this.price});

  @override
  List<Object?> get props => [title];
}

void q3() {
  final p1 = Product(title: "Pen", price: 10);
  final p2 = Product(title: "Pen", price: 99);
  print(p1 == p2);
}
/*
Questions:
- What does this print?
- Is this a bug in the Equatable package? Why or why not?
- What is the one-line fix?
- Why is this kind of bug dangerous in a real app?

Your answer:
output: true
- so this is not a bug but a mistake or over look from a developer whatever we provide in the props list only those values gets compared and a result returned.
- in list we have to add price [title, price] this will print false rightly so
- Because two objects with different prices could be treated as equal.
For example:
- Product A: Pen, ₹10
- Product B: Pen, ₹99
Your application might incorrectly treat these as the same product.
- Equatable only compares what you tell it to compare through props. Forgetting a property can cause incorrect equality results.
*/

/*
========================================================
Q4. PRACTICAL — WRITE == AND hashCode BY HAND
========================================================

Complete the class below WITHOUT Equatable so that
Point(1, 2) == Point(1, 2) is true. Write it yourself
from understanding, not from the video notes.
*/
class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);

  // Write your == override here
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Point &&
            runtimeType == other.runtimeType &&
            x == other.x &&
            y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

// Write your hashCode override here
void q4() {
  print(Point(1, 2) == Point(1, 2));
}

/*
Questions:
- Why is the parameter type Object and not Point?
- What is the purpose of the identical() check at the start?
- What does `other is Point` do besides checking the type?
- Why must hashCode be overridden along with ==?
- How would the same class look using Equatable?
  (Write only the part that changes.)

Your answer:
- Because == is designed to compare an object with any other object, not just another Point.
It allows us to check the type of the incoming object safely using is.
- It checks whether both references point to the exact same object. if they do we immediately return true without comparing individuals properties.
- It performs a type check and type promotion. after this check knows other is Point and can safely access other.x and other.y
- Because equal objects must have the same hash code. Collections like HashSet and HashMap use hashCode and == to identify objects.If we override == but not hashCode, 
these collections may behave incorrectly.
*/
class PointEq extends Equatable {
  final int x;
  final int y;

  const PointEq(this.x, this.y);

  @override
  List<Object> get props => [x, y];
}

/*
========================================================
Q5. UMBRELLA THEORY — BLOC FLOW
========================================================

Explain the Bloc flow as if answering an interview
question. Use the counter app as your example.

Cover these points:
- What are UI, events, states, and the Bloc?
- Which direction does each arrow in the diagram go?
- What exactly does the Bloc do when it receives an event?
- Why does the UI not change the counter value itself?
- Why is Bloc considered scalable and easy to test?

Your answer:
BLoC: Business Logic Components
it is a state management pattern in flutter that seperates business logic from the UI. it uses event as inputs and state as ouput.
UI: Displays data and listens for state changes
Event: represents the user action or request, such as IncrementCounter.
BLoc: receives events, process business logic and produces new state
State: represents the current condition of the UI, such as count = 1.

       USER ACTION
            |
            v
           UI
            |
            | add(Event)
            v
          EVENT
            |
            v
           BLOC
            |
            | emit(New State)
            v
          STATE
            |
            v
            UI
       (Rebuilds) 
Direction of flow: UI -> Event -> Bloc
                   Bloc -> State -> UI

- lets take the counter application:c
1. user click the increment button
2. UI dispatches the IncrementCounter event
3. Bloc receives the event
4. Bloc executes the corresponding business logic
5. Bloc calculates the updated counter value.
6. Bloc emits the new state
7. UI receives the new state and rebuilds correctly

- Because BLoC follows the separation of concerns principle. The UI is responsible for displaying information and capturing user interactions, while the Bloc handles 
business logic and state changes. this keeps the business logic seperated from the ui.

Scalable:
- Separates UI and business logic.
- Makes code modular and maintainable.
- Handles complex application states systematically.
Easy to test:
- Business logic is separated from UI.
- We can provide events and verify the expected states.
- We don't need to render the actual UI to test Bloc logic.

*/

/*
========================================================
Q6. INTERVIEW SCENARIO — SPOT THE WRONG STATEMENTS
========================================================

A junior developer describes a counter app built with
Bloc. Two statements are wrong. Find them and correct
them.

1. "When the user taps the + button, the UI creates an
   IncrementCounter event and gives it to the Bloc."
2. "The Bloc receives the event, calculates the new
   count, and returns the state to the UI like a
   normal function return value."
3. "The UI listens to the states coming from the Bloc
   and rebuilds to show the new value."
4. "To keep things quick, the button's onPressed can
   change the count directly and let the Bloc just
   store it."

Also answer:
- For the counter app, what are the two events?
- What information would a state need to hold?

Your answer:
Statement 2 is incorrect because Bloc emits new states using emit()
rather than returning them like a normal function.

Statement 4 is incorrect because the UI should only dispatch events;
the Bloc is responsible for updating the counter through business logic.

- Two events are IncrementCounter and DecrementCounter
- state would hold the count 

*/

void main() {
  // q2();
  // q3();
}

/*
========================================================
                  END OF DAY 01
========================================================
*/
