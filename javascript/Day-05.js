/*
=========================================================
DAY 05 — CLOSURES
=========================================================

SECTION 1 — FUNDAMENTALS
Q1–Q5
*/

/*
Q1. THEORY — UNDERSTANDING CLOSURES

What is a closure in JavaScript?

Explain:
1. What a closure consists of.
2. What a lexical environment means here.
3. Why a function may access variables outside its own scope.

Answer in your own words, as if explaining to an interviewer.
*/
/*
A closure in JavaScript is a function along with its lexical environment. It allows a function to access variables 
from its outer scope even after the outer function has finished executing.
1. What a closure consists of: A function and its access to the lexical environment in which it was created.
2. Lexical environment: It is the environment that contains the variables and function declarations available in a 
particular scope, along with the connection to its outer scope.
3. Why a function can access variables outside its own scope: JavaScript uses lexical scoping, which means the scope 
of a function is determined by where it is defined, not where it is called. Therefore, an inner function can access 
variables from its outer scope through the scope chain, even when called later.
*/

/*
Q2. PRACTICAL — BASIC CLOSURE

Predict the EXACT output and explain why.
*/
function outer() {
    let message = "Hello";

    function inner() {
        console.log(message);
    }

    return inner;
}

const result = outer();
result();

// Do not just say "because of closure."
// Explain what happens when outer() finishes executing.
// output: Hello
// when outer() finishes executing result holds a reference to the returned function(inner in this case) and inner function actually prints
// the message and due to the lexical scope inner function will retain the message and when we call result() it will print it. This is a classic
// example of closure in js


/*
Q3. PRACTICAL — OUTER FUNCTION FINISHES

Predict the EXACT output:
*/
function outer() {
    let count = 10;

    return function inner() {
        count++;
        console.log(count);
    };
}

const fn = outer();

fn();
fn();
fn();

// Explain why the variable count still exists and why
// the output changes between calls.

/*
Ouput: 11
       12
       13
when the outer function is called the count is initialized and inner function is returned. the variable fn holds the reference of returned 
function here(inner) and retains access to count because of closure.
when fn is called the first time then count become 10 to 11, on second it same count becomes 11 to 12 and the third call becomes 12 to 13. 
the count values doesnt become 10 because outer() is only called once and same count variable is updated when the fn is called
*/

/*
Q4. PRACTICAL — CLOSURES AND CHANGING VALUES

Predict the EXACT output:
*/
function outer() {
    let value = 5;

    function inner() {
        console.log(value);
    }

    value = 15;

    return inner;
}

const fn = outer();
fn();

// Does inner remember the value 5 or access the value 15?

// Explain why. Do not assume a closure stores a frozen
// snapshot of a variable.

/*
output: 15
closure doent mean js take a snapshot of every variable it retains access to its lexical bindings and the values of bindings can change.

 */

/*
Q5. ACTUAL CODING — COUNTER

Write a function createCounter() that:

1. Creates a local variable count initialized to 0.
2. Returns an inner function.
3. Each time the returned function is called, count
   increases by 1 and the new count is printed.

Expected usage:

const counter = createCounter();

counter(); // 1
counter(); // 2
counter(); // 3

Important:
- Do not use a global variable.
- Do not use a class.
- Use a closure to preserve the count.
*/
function createCounter() {
    var count = 0;
    return function increment() {
        count++;
        console.log(count);
    }
}
const counter = createCounter();
counter();
counter();
counter();

/*
=========================================================
SECTION 2 — INTERVIEW PRACTICE
Q6–Q10
=========================================================
*/

/*
Q6. INTERVIEW HANDS-ON — INDEPENDENT CLOSURES

Predict the EXACT output:
*/
function createCounter() {
    let count = 0;

    return function () {
        count++;
        console.log(count);
    };
}

const counter1 = createCounter();
const counter2 = createCounter();

counter1(); // 1
counter1(); // 2
counter2(); // 1
counter1(); // 3
counter2(); // 2

// Explain:
// 1. Why counter1 and counter2 do not share one count.
// 2. How many outer-function executions occur.
// 3. What each returned function remembers.
/*
output: 1
        2
        1
        3
        2
the counter1 and counter2 do not share the same count because they both are called seperately. Each time the function executes a new local 
variable is created and initialized to 0. Each returned function forms a closure over its own environment so they maintain different count.
*/


/*
Q7. INTERVIEW THEORY — DATA PRIVACY

An interviewer asks:

"How can closures help us create private variables
in JavaScript?"

Explain the concept, then write a small example of a
bank account that:

1. Stores a balance inside a function.
2. Returns a function that deposits money.
3. Returns a function that reports the current balance.
4. Does not expose the balance as a global variable.

You may return an object containing deposit and
getBalance methods.

Do not use a class.
*/
// closures allows us to cretae a private variable by declaring them inside the outer function and returning an inner function that access them.
function createBankAccount() {
    let balance = 0;

    return {
        deposit(amt) {
            balance += amt;
            console.log(`Deposited ${amt}`);
        },
        checkBalance() {
            console.log(`Current Balance: ${balance}`);
        }
    }
}

const bank = createBankAccount();

bank.checkBalance();
bank.deposit(500);
console.log(bank.balance); // undefined

/*
Q8. INTERVIEW HANDS-ON — WHAT DOES THE FUNCTION REMEMBER?

Predict the EXACT output:
*/
function outer() {
    let a = 10;

    return function middle() {
        let b = 20;

        return function inner() {
            console.log(a);
            console.log(b);
        };
    };
}

const first = outer();
const second = first();

second();

// Explain how inner accesses both a and b.

// Identify which lexical environments it needs to
// access to find those variables.
/*
Output: 10
        20
The output is 10 and 20.

The inner function can access both variables because JavaScript uses lexical scoping.

First, it looks for b in its outer lexical environment, which belongs to middle(). It finds b = 20 there.
For a, it continues searching through the scope chain and finds a = 10 in the lexical environment of outer().
Therefore, inner() retains access to both outer lexical environments through its scope chain, even after the outer functions have finished 
executing. 
*/


/*
Q9. INTERVIEW THEORY — IDENTIFYING A CLOSURE

Consider the following examples:

Example A:
*/
function greet() {
    console.log("Hello");
}

// Example B:

function outer() {
    let name = "Alex";

    return function inner() {
        console.log(name);
    };
}

// Answer:
// 1. Which example demonstrates the key behavior usually
//    associated with closures?
// 2. Does every function have access to its lexical
//    environment?
// 3. Is returning an inner function mandatory for a
//    closure to exist?
// 4. Does a closure require the outer function to have
//    finished executing before it can be useful?

// Explain your reasoning carefully.
// 1. Example 2 demonstrates closure
// 2. Yes. In JS every function has access to its lexical behaviour
// 3. No closure can exists even when we dont return a inner function.
// 4. No, a closure does not require the outer function to finish executing before it can be useful. An inner function can access variables
// from its outer lexical environment even while the outer function is executing. However, closures are especially useful when an inner
// function continues to access those variables after the outer function has finished executing.


/*
Q10. INTERVIEW CHALLENGE — CLOSURES IN A LOOP

Predict the EXACT output:
*/
const functions = [];

for (var i = 0; i < 3; i++) {
    functions.push(function () {
        console.log(i);
    });
}

functions[0]();
functions[1]();
functions[2]();

// Then make the smallest sensible change to the loop
// declaration so that the three function calls print:

// 0
// 1
// 2

// Explain:
// 1. What each function closes over in the first version.
// 2. Why the output is the same for all three calls.
// 3. Why changing var to let changes the behavior.

// Do not use setTimeout or Promises.


/*
=========================================================
END OF DAY 05
=========================================================
*/