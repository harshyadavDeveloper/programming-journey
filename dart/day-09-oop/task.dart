/*
========================================================
   DART — DAY 09: OOP (INTERVIEW ROUND)
========================================================

Run ONE question at a time (Q2, Q3, Q4, Q5 are runnable).
Write your prediction BEFORE running the code.

========================================================
Q1. extends / implements / with
========================================================

"What's the difference between extends, implements and with
in Dart? Can you instantiate an abstract class? What does the
underscore prefix do?"

Your answer:
extends is used for inheritance in Dart. Dart supports single class inheritance, so a class can extend only one superclass and reuse or override its implementation.

implements is used to implement an interface. In Dart, every class implicitly defines an interface. A class can implement multiple interfaces, but it must provide 
implementations for all their required members.

with is used to apply mixins, which allow us to reuse functionality across multiple classes without using inheritance. We can apply multiple mixins, and when 
they contain conflicting method implementations, the later mixin takes precedence.

An abstract class cannot be instantiated directly. It is used as a base abstraction for other classes, although it can contain both implemented and abstract methods.

The underscore prefix makes a variable, method or class private to its library, not just its class. Other classes within the same library can still access it.

*/

/*
========================================================
Q2. PREDICT THE OUTPUT — CONSTRUCTOR ORDER
========================================================
*/
class Base {
  Base() {
    print('Base ctor');
  }
}

class Child extends Base {
  final String x = (() {
    print('field init');
    return 'x';
  })();

  Child() : super() {
    print('Child ctor');
  }
}

void q2() {
  Child();
}
/*
Questions:
- What is the exact output?
- In what order do field initializers, the super constructor
  and the constructor body run?

Your answer:
output:
field init
Base ctor
Child ctor

In Dart, instance field initializers of the subclass execute before the superclass constructor.
After the field initializers complete, the superclass constructor executes, followed by the subclass constructor body.
In this example, the field initializer prints field init, then the Base constructor prints Base ctor, and finally the Child constructor body prints Child ctor.

*/

/*
========================================================
Q3. PREDICT THE OUTPUT — MIXINS
========================================================
*/
mixin A {
  String hello() => 'A';
}

mixin B {
  String hello() => 'B';
}

class C with A, B {}

class D with B, A {}

void q3() {
  print('${C().hello()} ${D().hello()} ${C() is A} ${C() is B}');
}
/*
Questions:
- What is the exact output?
- Why does the order of mixins matter?
- Can a mixin have a constructor? What does `on` do?

Your answer:
output: B A true true

- Dart applies mixins in the order they are specified. When multiple mixins define the same method, the later mixin takes precedence over the earlier one.

- No, Dart mixins cannot have generative constructors. They are designed to provide reusable functionality across multiple classes. However, they can contain 
fields and methods.

- The on keyword defines a superclass constraint for a mixin. It restricts which classes can use that mixin and allows the mixin to access members of the 
specified superclass

*/

/*
========================================================
Q4. LIVE CODING — FACTORY CONSTRUCTOR
========================================================

Write a Logger class where Logger('a') always returns the SAME
instance for the same name (a cache), and different names give
different instances. Prove it with identical().

Then answer:
- How is a factory constructor different from a normal one?
- Where do you commonly use factory in Flutter apps?

Write your code below:
*/
class Logger {
  final String name;

  static final Map<String, Logger> _cached = {};
  Logger._internal(this.name);

  //   factory Logger(String name) {
  //     if (_cached.containsKey(name)) {
  //       return _cached[name]!;
  //     } else {
  //       final logger = Logger._internal(name);
  //       _cached[name] = logger;
  //       return logger;
  //     }
  //   }
  // OR
  factory Logger(String name) {
    return _cached.putIfAbsent(name, () => Logger._internal(name));
  }
}

void q4() {
  Logger logger1 = Logger('a');
  Logger logger2 = Logger('a');
  Logger logger3 = Logger('b');

  print(identical(logger1, logger2));
  print(identical(logger1, logger3));
}
/*
Your answer:
- A normal generative constructor creates and initializes a new instance of a class.
A factory constructor gives us more control over object creation. It doesn't necessarily create a new instance every time; it can return an existing cached instance, 
return a subtype, or decide which object should be created based on the input.

- In Flutter, one common use case is JSON parsing, where we use named factory constructors such as User.fromJson() to convert API responses into model objects.
We can also use factory constructors for caching and singleton-like implementations.
*/

/*
========================================================
Q5. LIVE CODING — EXTENSION METHOD
========================================================

Write an extension on String with a getter `capitalized` that
makes the first letter uppercase ('flutter' -> 'Flutter').
Call it on a String and on a `dynamic` variable holding a
string.

Then answer:
- What happens in the dynamic case, and why?
- Can an extension add a field? Can it override a method?

Write your code below:
*/
extension StringX on String {
  String get capitalized => this[0].toUpperCase() + this.substring(1);
}

void q5() {
    String word = "flutter";
    dynamic newW = "thisss";
    print(word.capitalized);
    print(newW.capitalized);
}
/*
Your answer:
output: Flutter
        NoSuchMethodError: 'capitalized'

- Extension methods are resolved using the static type of an expression, not its runtime type. When a variable is dynamic, Dart performs runtime member lookup instead 
of resolving the extension. Since the extension isn't an actual member of String, it results in a NoSuchMethodError. I can explicitly cast it to String to use the 
extension.

- No. Extensions cannot add instance fields or modify the original class. They can provide additional methods, getters, setters and operators. They also cannot 
override existing instance methods because extensions don't participate in normal inheritance or virtual method dispatch.

*/

/*
========================================================
Q6. SCENARIO — TESTABLE REPOSITORY
========================================================

"Your PostBloc takes a PostRepository that calls the real API.
How do you make the Bloc testable without hitting the
network?"

Cover:
- How would you define the repository (abstract class or
  interface)?
- How does a fake/mock repository relate to it: extends or
  implements, and why?
- How does the Bloc receive it?

Your answer:
I would define an abstract PostRepository containing the methods required by the Bloc. The real API repository and the fake/mock repository would both implement this 
contract using implements. The Bloc would receive the repository through constructor injection and depend only on the abstraction. In production, I inject the API
 implementation; in tests, I inject a fake or mock implementation. This allows me to test Bloc behaviour without making actual network calls

*/

/*
========================================================
Q7. MIXINS IN PRACTICE
========================================================

"What is a mixin, why does Dart have them, and where have you
seen one in Flutter?"

Your answer:
A mixin is a reusable collection of methods and properties that a class can include using the with keyword. Dart uses mixins to support code reuse without requiring 
multiple class inheritance. In Flutter, I've used SingleTickerProviderStateMixin with AnimationController. It provides a ticker through vsync, allowing animations 
to stay synchronized with screen refreshes and avoid unnecessary animation work when the widget isn't visible.

*/

void main() {
  // Run ONE question at a time.
  q2();
  // q3();
  // q4();
  // q5();
}
