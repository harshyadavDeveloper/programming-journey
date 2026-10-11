/*
=========================================================
DAY 04
Topics:
- var, let, const
- Function Scope vs Block Scope
- Hoisting and Temporal Dead Zone (TDZ)
- Block Scope
- Shadowing
- Illegal Shadowing
=========================================================
*/

/*
=========================================================
SECTION 1 — LEARN & PRACTICE
Q1–Q8
=========================================================
*/

/*
Q1. THEORY — var vs let vs const

Explain the differences between var, let, and const in
terms of:

1. Scope
2. Hoisting and initialization
3. Reassignment
4. Redeclaration

Give a small code example for each.

Also explain why const does not mean that an object's
contents can never change.
*/
// var is function scoped while let and const are block scoped.
// var is initialized with undefined, while let and const remain uninitialized in the Temporal Dead Zone (TDZ) until their
// declaration is executed. Accessing them before initialization throws a ReferenceError.
// because they are stored outside of global scope unlike var. They are also defined but before initialzation they are in a TDZ.
// Temporal dead zone is peroid between entering a scope and initializing a let or const.
// we can reassign var and let variable but we cannot reassing const. We can just declare var and let at top and maybe assing
// them value later in the code but const requires a value at the time of declaration.
// var allows redeclaration, whereas let and const do not allow redeclaration in the same scope.

var a = 10;
var a = 20; // Allowed

let b = 10;
let b = 20; // SyntaxError

const c = 10;
const c = 20; // SyntaxError


// Q2. PRACTICAL — BLOCK SCOPE

// Predict the EXACT output:

var a = 10;
let b = 20;
const c = 30;

{
    var a = 100;
    let b = 200;
    const c = 300;

    console.log(a);
    console.log(b);
    console.log(c);
}

console.log(a);
console.log(b);
console.log(c);

// Explain why each value is printed.

// Pay special attention to what happens to `a` after
// the block finishes.

// Output: 

// 100
// 200
// 300
// 100
// 20
// 30

/* 
First a → 100: var is not block-scoped. The inner var a = 100 refers to the same variable declared outside the block and overwrites 
its value from 10 to 100.
First b → 200: let is block-scoped. The inner b is a separate variable from the outer b, which remains 20.
First c → 300: const is also block-scoped. The inner c is separate from the outer c, which remains 30.
After the block: a is still 100 because the inner var changed the same variable. But b and c return to their outer values, 20 and 
30, because their inner declarations existed only inside the block.
*/


// Q3. PRACTICAL — TEMPORAL DEAD ZONE

// Predict the EXACT output or error:

console.log(a);
let a = 10;

// Then consider:

console.log(b);
var b = 20;

// Explain why the two examples behave differently.

// What is the Temporal Dead Zone, and when does it end?


/* 
Output: reference error
Output: undefined

Explanation:
let is hoisted but remains uninitialized in the
Temporal Dead Zone (TDZ) until its declaration is
executed. Accessing it before initialization causes
a ReferenceError.

var is hoisted and initialized with undefined
during the creation phase, so accessing it before
assignment prints undefined.

The TDZ ends when the let or const variable
is initialized during execution.
*/

/*
Q4. ACTUAL CODING — SCOPE

Write a program that:

1. Declares a variable named `message` in the global scope.
2. Creates a function named `showMessage`.
3. Inside that function, creates a block using `if`.
4. Declares another `message` using let inside the block.
5. Prints both the inner and outer values.

Your output should demonstrate that the inner block's
variable does not overwrite the outer variable.

Use meaningful values and explain the output.
*/

var message = "message";

function showMessage() {
    var message = "funcMessage"
    if (true) {
        let message = "letMessage";
        console.log(message);
    }

    console.log(message);
}

showMessage();
console.log(message);

// Q5. PRACTICAL — SHADOWING

// Predict the EXACT output:


let x = 10;

function test() {
    let x = 20;

    if (true) {
        let x = 30;
        console.log(x);
    }

    console.log(x);
}

test();
console.log(x);

// Explain which declaration each console.log accesses.
// the if true block prints 30. 
// the second log before the function ends prints 20
// the log aftter the function invoke prints 10.
// this happens because log also follows lexical rule if first looks for the variable inside its block and then its moves outwards


/*
Q6. PRACTICAL — var INSIDE A BLOCK

Predict the EXACT output:
*/
function test() {
    var a = 1;

    if (true) {
        var a = 2;
        console.log(a);
    }

    console.log(a);
}

test();

// Now explain what would change if the inner `var a = 2`
// were replaced with `let a = 2`.

// Do not just give the output. Explain the scope difference.
// ouput with both var: 2
//                      2
// output with let inside of block: 2
//                                  1
// When both declarations use `var`, they refer to the same function-scoped variable because `var` does not respect block scope. Therefore,
// assigning `2` changes the value of `a` to `2`, and both logs print `2`.
// When the inner declaration uses `let`, JavaScript creates a separ ate block-scoped variable. This inner variable shadows the outer variable
// inside the `if` block but does not overwrite it. Therefore, the logs print `2` inside the block and `1` outside it. 



/*
Q7. ACTUAL CODING — LOOP SCOPE

Write a program using a for loop that declares its counter
with `let`.

Print the counter inside the loop.

Then write a second version using `var`.

Explain the scope difference between the two declarations.

Do not use setTimeout or Promises for this question.
*/

function letLoop() {
    for (let i = 0; i < 5; i++) {
        console.log(i);
    }
}

function varLoop() {
    for (var i = 0; i < 5; i++) {
        console.log(i);
    }
    console.log(i);
}
letLoop();
varLoop();
/*
With let:
- The variable i is scoped to the for loop.
- You can access i inside the loop, but not outside the loop.
- After the loop finishes, i is no longer accessible.
With var:
- The variable i is scoped to the enclosing function, not the loop.
- You can access i both inside and outside the loop, as long as you're within the function.
- After the loop finishes, i still exists and its value is 5.
*/

/*
Q8. PRACTICAL — const

Predict the output:
*/
const user = {
    name: "Alex",
    age: 25
};

user.age = 26;
console.log(user.age);

// Then consider:

const user = {
    name: "Alex"
};

user = {
    name: "Sam"
};

// What happens in each example, and why?

// Explain what const actually prevents.
// first log prints 26. In JS, cosnt prevents re-asssignment of a variable, but it does not make it immutable.
// this is the reason it works. but the second and third line will give us TypeError so our code will never get executed.


/*
=========================================================
SECTION 2 — INTERVIEW PRACTICE
Q9–Q15
=========================================================
*/

/*
Q9. INTERVIEW THEORY — HOISTING

An interviewer asks:

"Are let and const hoisted in JavaScript?"

Give an interview-ready answer.

Explain how their behavior differs from var and what
the Temporal Dead Zone has to do with it.
*/
// Yes, `let` and `const` are hoisted in JavaScript, but unlike `var`, they are not initialized during the creation phase.
// `var` is initialized with `undefined`, so accessing it before its declaration returns `undefined`. However, accessing `let` or `const` before
// its declaration throws a `ReferenceError`.
// The period between entering the scope and initializing the variable is called the **Temporal Dead Zone (TDZ)**.

/*
Q10. INTERVIEW HANDS-ON — OUTPUT PREDICTION

Predict the EXACT output or error:
*/
var a = 1;

function test() {
    console.log(a);
    let a = 2;
}

test();

// Explain why JavaScript does not print the global value
// of `a` inside the function.

// Identify the role of the local declaration.
// When we invoke `test()`, JavaScript creates a Function Execution Context. During the creation phase, the local variable `a`, declared with
// `let`, is registered but remains uninitialized.
// Because the local `a` shadows the global `a`, JavaScript tries to access the local variable instead of the global one. Since the local
// variable is still in the Temporal Dead Zone (TDZ), accessing it throws a `ReferenceError`.


/*
Q11. INTERVIEW THEORY — SHADOWING

What is variable shadowing in JavaScript?

Explain it with an example involving an outer variable
and an inner variable with the same name.

Then explain the difference between shadowing with let
and redeclaring a variable with var inside a block.
*/
var a = 10;
function commonFunction() {
    var a = 20;
    console.log(a);
}

commonFunction();
console.log(a);

let b = 10;
function something() {
    var b = 10;
    console.log(b);
}
// Variable shadowing occurs when an inner scope declares a variable with the same name as an outer variable, hiding the outer variable within
// its scope without overwriting it.
// With `let`, shadowing is allowed when the variables belong to different scopes. However, `var` is function-scoped, not block-scoped. If a
// `var` declaration conflicts with an existing `let` or `const` declaration in the same scope, it causes a `SyntaxError`, known as illegal
// shadowing.

/*
Q12. INTERVIEW HANDS-ON — ILLEGAL SHADOWING

Predict what happens:
*/
let a = 10;

{
    var a = 20;
}

// Does this code execute successfully?

// Now compare it with:

var b = 10;

{
    let b = 20;
}

// Explain why the two cases behave differently.

// Do not run the code before making your prediction.


/* 1. First case — let a outside and var a inside: The code throws a SyntaxError because var is not block-scoped. Its declaration conflicts 
with the existing let a in the same surrounding scope, so the code cannot execute.
2. Second case — var b outside and let b inside: The code executes successfully because let is block-scoped. It creates a separate variable b 
inside the block, shadowing the outer variable without conflicting with it. */

/*
Q13. INTERVIEW HANDS-ON — LOOP CLOSURE PREVIEW

Predict the output:
*/
for (var i = 0; i < 3; i++) {
    console.log(i);
}

for (let j = 0; j < 3; j++) {
    console.log(j);
}

// Write the complete output in order.

// Explain the scope of `i` and `j` after their loops finish.

// Do not use closures or asynchronous code in your explanation.

/*
Output for var i: 0, 1, 2
Output for let j: 0, 1, 2

var is not block-scoped, so i remains accessible after the loop finishes. If we access i outside the loop, its value will be 3 because of the 
post-increment operation (i++).
let is block-scoped, so j is accessible only inside the loop. If we try to access j outside the loop, JavaScript throws a ReferenceError.

*/

/*
Q14. INTERVIEW THEORY — BLOCK SCOPE

An interviewer asks:

"What is a block in JavaScript, and which declarations
are block-scoped?"

Explain:

1. What curly braces represent in a block statement.
2. How let and const behave inside a block.
3. Why var behaves differently.
4. Whether every pair of curly braces automatically
   creates a block scope.

Give examples to support your explanation.
*/
/*
A block in JavaScript is a group of statements enclosed within curly braces `{}`. It creates a scope for variables declared with `let` and `const`, making them accessible only inside that block.

`var` behaves differently because it is function-scoped rather than block-scoped, so it can be accessed outside the block within the same function.

However, not every pair of curly braces creates a block scope. For example, curly braces used in an object literal do not create a block scope.

Example:


{
    let a = 10;
    const b = 20;
    var c = 30;
}

console.log(c); // 30
// console.log(a); // ReferenceError
// console.log(b); // ReferenceError

*/

/*
Q15. INTERVIEW CHALLENGE — DEBUGGING

A developer writes:

let count = 10;

if (true) {
    var count = 20;
}

console.log(count);

They expect the output to be 10.

Answer the following:

1. What happens when JavaScript processes this code?
2. Does it print 10, print 20, or throw an error?
3. Why?
4. Rewrite the code with the smallest sensible change
   so that the output is 10.

Explain the underlying scope rule.
*/

/*
1. JavaScript throws a `SyntaxError` because `var` is function-scoped, not block-scoped, and conflicts with the existing `let count` 
declaration in the same scope.
2. It throws an error; it does not print 10 or 20.
3. The `var count` declaration inside the `if` block conflicts with the outer `let count` because `var` does not respect block scope.
4. The smallest sensible change is to replace `var` with `let` inside the block:

```javascript
let count = 10;

if (true) {
    let count = 20;
}

console.log(count); // 10
```

**Underlying scope rule:** `let` is block-scoped, whereas `var` is function-scoped. An inner `let` can shadow an outer `let`, but a `var` 
declaration cannot conflict with an existing `let` declaration in the same scope.
*/

/*
DAY 04 — REFLECTION

Today, I learned about var, let, and const in JavaScript and understood their differences in scope, hoisting, reassignment, and redeclaration.

Key learnings:
1. var is function-scoped, while let and const are block-scoped.
2. var is initialized with undefined during hoisting, whereas let and const remain in the Temporal Dead Zone (TDZ) until initialization.
3. Accessing let or const before initialization causes a ReferenceError.
4. Shadowing occurs when a variable in an inner scope has the same name as a variable in an outer scope.
5. var declared inside a block is not block-scoped, but let and const are.
6. Redeclaring let or const in the same scope causes a SyntaxError.
7. const prevents reassignment of a variable binding, but it does not make objects or arrays immutable.
8. Illegal shadowing can occur when var conflicts with a let declaration in an enclosing scope.
9. In loops, let creates a separate binding for each iteration, unlike var.
10. I learned to explain these concepts with examples and interview-ready definitions.

What I need to revise:
- Temporal Dead Zone (TDZ)
- Block scope vs function scope
- Shadowing vs illegal shadowing
- Hoisting differences between var, let, and const
- Reassignment vs mutation of const objects

Conclusion:
I now understand how JavaScript handles variable declarations and scope. I need to keep practising output-based and coding questions to strengthen my understanding before moving to the next topic.
*/
