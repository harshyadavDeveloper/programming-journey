/*
========================================================
   DART — DAY 08: NULL SAFETY (INTERVIEW ROUND)
========================================================

Run ONE question at a time (Q2, Q3, Q4 are runnable).
Write your prediction BEFORE running the code.

=======================================================a==

"What is null safety in Dart? What does 'sound' mean, and
when is the ! operator risky?"

Your answer:
Null safety is a feature in Dart that helps prevent null-related runtime errors by distinguishing between nullable and non-nullable types.

Sound null safety means that Dart can guarantee that non-nullable variables cannot contain null at runtime in soundly null-safe code. It achieves this through 
compile-time type checking and flow analysis.

The ! operator is called the null assertion operator. It tells Dart that I am certain a nullable value is not null, and it allows me to treat it as non-nullable.

However, it is risky because if the value actually turns out to be null at runtime, it throws an error. This is particularly important when handling API 
responses because server data may contain unexpected null values. I would prefer null checks or the ?? operator wherever appropriate.

*/

/*
========================================================
Q2. PREDICT THE OUTPUT
========================================================
*/
void q2() {
  String? name;
  print(name?.length); // null
  print(name ?? 'guest'); // guest
  name ??= 'Ali';
  print(name.length); // 3
  String? none;
  try {
    print(none!.length);
  } catch (e) {
    print('${e.runtimeType}: $e'); // type error: unexpected null value.
  }
}
/*
Questions:
- What is the exact output?
- Why does name.length compile without a ! after the ??= line?
- What does ! actually do at runtime?

Your answer:
After using the ??= operator, Dart's flow analysis knows that the variable cannot be null because the operator assigns a value if the variable was previously null. 
That's why I can access its properties without using the null assertion operator.

The ! operator is the null assertion operator. It tells Dart to treat a nullable value as non-nullable, but it performs a runtime null check. If the value is 
actually null, it throws a TypeError.

*/

/*
========================================================
Q3. PREDICT THE OUTPUT — final vs const
========================================================
*/
class Point {
  const Point(this.x);
  final int x;
}

void q3() {
  final a = [1, 2];
  a.add(3);
  print(a);
  const b = [1, 2];
  try {
    b.add(3);
  } catch (e) {
    print(e.runtimeType);
  }
  print(identical(const Point(1), const Point(1)));
  print(identical(Point(1), Point(1)));
}
/*
Questions:
- What is the exact output?
- Why does a.add(3) work if a is final?
- What does "canonicalized" mean here?

Your answer:
output: 
[1, 2, 3]
UnsupportedError
true
false

The main difference between final and const is that final prevents a variable from being reassigned, whereas const creates a compile-time constant value.

A final variable can still reference a mutable object, which is why I can add elements to a final list. However, a const list is immutable, so modifying it 
throws an UnsupportedError.

Canonicalization means Dart reuses the same instance for equivalent compile-time constant objects. That's why two identical const constructor expressions 
can return true when compared using identical(), whereas two regular constructor calls create separate instances.

*/

/*
========================================================
Q4. PREDICT THE OUTPUT — late
========================================================
*/
String loadConfig() {
  print('loading');
  return 'cfg';
}

late String config = loadConfig();
late String missing;

void q4() {
  print('start');
  print(config);
  print(config);
  try {
    print(missing);
  } catch (e) {
    print('error: ${e.runtimeType}');
  }
}
/*
Questions:
- What is the exact output?
- When does loadConfig() run, and how many times?
- Why does reading `missing` fail, and what is the risk
  of using late like this?

Your answer:
output: 
start
loading
cfg
cfg
error: LateError

The late keyword tells Dart that a non-nullable variable will be initialized later, before its first access.

When we use late with an initializer, Dart performs lazy initialization, meaning the initializer executes only when the variable is accessed for the first time. 
The result is then stored and reused.

If we declare a late variable without an initializer and access it before assigning a value, Dart throws a LateInitializationError.

The risk is that initialization mistakes aren't caught at compile time. They can cause runtime errors, so I use late only when I'm confident the variable will 
be initialized before it's accessed.

*/

/*
========================================================
Q5. SCENARIO — A FIELD THAT WON'T PROMOTE
========================================================

  class User {
    String? nickname;
    void show() {
      if (nickname != null) print(nickname.length);
    }
  }

The compiler reports an error on nickname.length.

Questions:
- Why can't it promote nickname, even after the check?
- Give three ways to fix it.

Your answer:
Dart can promote local variables after null checks, but instance fields are different. why: Because an instance field can potentially change between the null check and its usage.

3 ways to fix this is:
first(recommended): use a local variable
void show(){
final nick = nickname;
if(nick!=null) print(nick.length);
}
-------------
second: using null assertion operator:
void show(){
if(nickname!=null) print(nickname!.length);
}
------------
third: using null aware access
void show(){
if(nickname!=null) print(nickname?.length);
}
-------
Dart performs flow analysis and promotes local variables when it can guarantee that they are non-null.

However, instance fields are not generally promoted because they can potentially change between the null check and their usage. This is especially relevant 
for mutable fields and getters.

I can solve this by assigning the field to a local final variable and then checking that variable, using the null assertion operator if I'm certain it's non-null, 
or using null-aware access with the ?. operator.
*/

/*
========================================================
Q6. final vs const vs var
========================================================

"Explain the difference between var, final and const. What
is a const constructor, and why do const widgets help in
Flutter?"

Your answer:
var allows a variable to be reassigned, whereas final allows it to be assigned only once. However, a final variable can still reference a mutable object.

const creates a compile-time constant value, which cannot be modified.

A const constructor allows us to create compile-time constant instances of a class. For this, instance fields must be final and the constructor must be marked const.

In Flutter, const widgets help improve performance because their configurations are immutable. When a parent rebuilds, Flutter can reuse an existing const widget 
instance instead of creating an equivalent new instance, reducing unnecessary widget construction work.

*/

/*
========================================================
Q7. SCENARIO — MISSING FIELD FROM THE API
========================================================

"The backend sometimes omits `email`. Your model has
`final String email` and the app crashes while parsing.
How do you model and handle this?"

Cover:
- How do you declare the field and parse it?
- How does the UI show a fallback?
- Why avoid ! here?
- What would you do for a field that must always exist?

Your answer:

If the backend sometimes omits email, I would model it as a nullable field using String?.

While parsing the JSON, I would use my parsing helper to convert the value into the expected Dart type while preserving null if the field is missing.

In the UI, I would use a fallback value with the null-coalescing operator (??) or conditionally display the field.

I would avoid using the null assertion operator (!) because the backend doesn't guarantee that email will always exist, and it could cause a runtime error.

For fields that are mandatory, such as a user ID, I would keep them non-nullable and validate their presence and type during JSON parsing. If the required field is 
missing or invalid, I would throw a FormatException or return an appropriate parsing failure instead of silently accepting invalid data.

*/


void main() {
  // Run ONE question at a time.
  // q2();
  // q3();
  q4();
}
