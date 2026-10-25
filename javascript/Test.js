/*
========================================================
       SEASON 1 — JAVASCRIPT INTERVIEW TEST
========================================================

Total Questions: 15

Topics:
Execution Context, Hoisting, Scope, TDZ, Closures,
Callbacks, Higher-Order Functions, Event Loop,
Currying, call/apply/bind, map/filter/reduce.

Instructions:
1. Predict outputs before running the code.
2. Explain WHY, not just WHAT.
3. Write practical solutions yourself.
4. For output questions, include exact output.
5. Theory answers should be interview-ready.

========================================================
Q1. HOISTING — OUTPUT PREDICTION
========================================================

Predict the exact output and explain what happens during
the creation phase and execution phase.
*/
console.log(foo);

var foo = 10;

function foo() {
  console.log("Hello");
}

console.log(foo);

// Questions:
// - Why does the first console.log not print undefined?
// - What happens to foo during the creation phase?
// - Why does the second console.log produce a different result?

// Your answer:
// output: [Function: foo]
// 10
// because js hoists function declaration along with variable declaration. Functions are initialised with the actual function objects
// so the first console itself prints function and not undefiend.
// During the creation phase, JavaScript registers the var declaration and the function declaration. The function declaration
// initializes foo with the function object. Since both declarations use the same name, the function object is available before
// execution starts
// Because var foo = 10 assigns the value 10 to foo when that statement executes. This overwrites the function object stored in
// foo. Therefore, the second console.log(foo) prints 10

/*
========================================================
Q2. FUNCTION DECLARATION VS FUNCTION EXPRESSION
========================================================

Predict what happens when this code executes.
Does "End" get printed? Explain why or why not.
*/
sayHello();

var sayHello = function () {
  console.log("Hello");
};

console.log("End");

// Questions:
// - What is sayHello before its assignment executes?
// - Why does calling it fail?
// - How is this different from a function declaration?

// Your answer:
// output: typeError
// During the creation phase, JavaScript hoists the var declaration and initializes sayHello to undefined. The function expression
// has not been assigned yet.
// When JavaScript executes sayHello(), the variable still holds undefined because the assignment has not executed. Since
// undefined is not callable, JavaScript throws a TypeError and stops executing the remaining statements.
// JavaScript handles function declarations and function expressions differently. A function declaration is hoisted with its
// function object, so it can be called before its declaration appears in the code. With a function expression assigned to a var
// variable, only the variable declaration is hoisted; the assignment happens during execution.

/*
========================================================
Q3. SCOPE, var AND let
========================================================

Predict the output and explain the scope of each variable.
*/
var number = 10;

if (true) {
  var number = 20;
  let value = 30;
}

console.log(number);
console.log(value);

// Questions:
// - What does the first console.log print?
// - What happens at the second console.log?
// - Why do var and let behave differently here?

// Your answer:
// The first console.log prints 20 because var is function-scoped rather than block-scoped. Therefore, the declaration inside
// the if block refers to the same variable, and its assignment updates the value to 20.
// The second console.log throws a ReferenceError because value is declared using let, which is block-scoped. It is accessible
// only inside the if block.
// This demonstrates the difference between var, which ignores ordinary block scope, and let, which respects block scope.

/*
========================================================
Q4. TEMPORAL DEAD ZONE AND SHADOWING
========================================================

Predict what happens and explain the reason.
*/
let score = 100;

function checkScore() {
  console.log(score);
  let score = 50;
}

checkScore();

// Questions:
// - Why doesn't the function print the global score?
// - What is the Temporal Dead Zone?
// - At what point does the error occur?

// Your answer:
// Output: ReferenceError
// because the function contains the local a local let score variable and js creates a binding for that local let variable when
// entering the function scope. this local variable shadows the global let variable. Therefore the console log tries to access
// local variable instead of global
// TDZ is the peroid between entering the scope and the point where const and let variable are initialzed. During this period the
// the varibale exits but cannot be accessed. accessing it throws a referenceError
// the error occours at console.log(score) because the local score has not yet been initialzed. the statement  let score = 50 is
// never reached and function stops executing

/*
========================================================
Q5. SCOPE CHAIN, UNDEFINED AND NOT DEFINED
========================================================

Answer all parts.

A. Explain the difference between undefined and not defined.

B. Predict the output:
*/
let message = "Outer";

function outer() {
  let message = "Middle";

  function inner() {
    let result = "Inner";
    console.log(message);
    console.log(result);
  }

  inner();
  console.log(result);
}

outer();


// C. Explain:
// - How does lexical scope determine variable access?
// - How does the scope chain find a variable?
// - Why does the final console.log cause a problem?

// Your answer:


// undefined: The variable exists, but its current value is undefined.
// Example:
var a;
console.log(a); // undefined

// Not defined: The identifier has not been declared in an accessible scope.
// Accessing it throws a ReferenceError.
console.log(b); // ReferenceError

// output: Middle
// Inner
// ReferenceError
// ReferenceError — result is not accessible inside outer() because it belongs to inner()'s local scope. Execution stops at this
// error.

// lexical scope: Lexical scope means a function's access to variables is determined by where it is defined in the code, not
// where it is called. Inner functions can access variables from their outer scopes.

// scope chain: JavaScript searches for a variable in the current scope first. If it isn't found, it moves outward through parent
// scopes until it finds the variable or reaches the global scope. If it still cannot find it, a ReferenceError occurs.

// console.log(result) inside outer() throws a ReferenceError because result is declared inside inner(). Variables declared
// inside a function are not accessible from the function's outer scope.

/*
========================================================
Q6. CLOSURES — COUNTER
========================================================

Predict the exact output.
*/
function createCounter() {
  let count = 0;

  return function () {
    count++;
    return count;
  };
}

const counterA = createCounter();
const counterB = createCounter();

console.log(counterA());
console.log(counterA());
console.log(counterB());
console.log(counterA());
console.log(counterB());

// Questions:
// - Why does count not reset after every call?
// - Why do counterA and counterB maintain separate counts?
// - Explain closure using this example.

// Your answer:
/*
output: 1
        2
        1
        3
        2
- it does not reset because the return function retains the access to the count variable in its lexical scope, even after 
createCounter finishes executing. Each call increments the exisitng value instead of resetting it.
- each call to createCounter create a new lexical environment with its own count variable. so counterA and counterB maintains
seperate independent count
- closure is when a function ratains access to variables from its outer lexical scope, even when the outer function has finised
executing
here, the returned function creates a closure over count, allowing it preserve and update it between calls. 
*/

/*
========================================================
Q7. CLOSURES WITH setTimeout
========================================================

Predict the output and explain why.

for (var i = 0; i < 3; i++) {
    setTimeout(function () {
        console.log(i);
    }, 1000);
}

Questions:
- What gets printed?
- Why do all callbacks see the same variable?
- Rewrite the example so that it prints 0, 1, 2
  while keeping var.
- Explain how let would change the behavior.

Your answer:
*/
/*
output: 3
        3
        3
var is function-scoped, not block-scoped, so all three callbacks share the same i variable. The loop finishes before the callbacks 
execute, and by then i is 3.
When the callbacks run after approximately 1 second, each reads the current value of the same variable: 3.
Unlike var, let creates a separate binding for each loop iteration, so each callback retains access to its own value of i.

*/
for (var i = 0; i < 3; i++) {
  (function (j) {
    setTimeout(function () {
      console.log(j);
    }, 1000);
  })(i);
}

/*
========================================================
Q8. CALLBACKS AND HIGHER-ORDER FUNCTIONS
========================================================

A. Explain the difference between a callback function
   and a higher-order function.

B. Write a reusable function called processArray that:
   - Accepts an array and a callback.
   - Applies the callback to every array element.
   - Returns a new array containing the results.
   - Uses a regular for loop.

C. Test it with:
   - A function that doubles each number.
   - A function that squares each number.

D. Explain why reusable code is better than writing
   a separate loop for every operation.

Write your implementation below:
*/

/*
- JavaScript treats functions as first-class citizens, meaning they can be passed as arguments and returned from other functions. 
A callback is a function passed to another function to be invoked by it. A higher-order function is a function that accepts 
another function as an argument or returns a function. The same function can be a callback in one context and a higher-order 
function in another.

- Reusable code follows the DRY (Don't Repeat Yourself) principle by separating the iteration logic from the operation being 
performed. This reduces code duplication, improves readability and maintainability, and makes the code easier to extend. If the 
iteration logic needs to change, we update it in one place rather than modifying multiple loops.
*/
const arr = [2, 4, 7, 11, 8, 6];

const double = (num) => {
  return num * 2;
};

const sqr = (n) => {
  return n * n;
};

function processArray(arr, callback) {
  const output = [];

  for (let i = 0; i < arr.length; i++) {
    output.push(callback(arr[i]));
  }

  return output;
}

console.log(processArray(arr, double));
console.log(processArray(arr, sqr));

/*
========================================================
Q9. EVENT LOOP — OUTPUT PREDICTION
========================================================

Predict the exact output order.
*/
console.log("A");

setTimeout(() => {
  console.log("B");
}, 0);

Promise.resolve().then(() => {
  console.log("C");

  Promise.resolve().then(() => {
    console.log("D");
  });
});

console.log("E");

// Questions:
// - Which statements execute synchronously?
// - Why does the Promise callback run before the timer?
// - Why does D print before B?
// - Explain the roles of the call stack, microtask queue,
//   task queue and event loop.

// Your answer:
/*
output: A
        E
        C
        D
        B
A and E executes synchronously. Promise callback are added micro-task queue and timer are added into callback task. Micro tasks
executes before call back tasks and if a micro task creates another micro task then that new task also will execute before 
callback task. D prints before because it is created by another micro task and gets added in the micro task queue and call back 
task will start executing when micro task queue is empty.

JavaScript executes synchronous code on the call stack. When asynchronous operations are scheduled, their callbacks are processed 
later according to the event loop and the type of queue they belong to.

The call stack keeps track of the functions currently executing. In our example, console.log("A") and console.log("E") execute 
synchronously on the call stack.

The microtask queue holds callbacks from operations such as Promise.then(). After the current synchronous code finishes, the 
event loop ensures that pending microtasks are processed before the next task begins.

The task queue, also commonly called the macrotask queue, handles callbacks from operations such as setTimeout().

The event loop coordinates execution by allowing the runtime to process queued callbacks when the call stack is clear. After the 
synchronous code finishes, it processes microtasks until the microtask queue is empty, including any new microtasks added during 
that process, before moving on to the next task.

That's why the output is A, E, C, D, B: the Promise callback runs before the timer, and the nested Promise callback that prints 
D also runs before the timer callback that prints B.
*/

/*
========================================================
Q10. call(), apply() AND bind()
========================================================

Predict the exact output.
*/
const user = {
  name: "Alex",
};

function introduce(city, country) {
  console.log(this.name + " from " + city + ", " + country);
}

introduce.call(user, "Goa", "India");

introduce.apply(user, ["Pune", "India"]);

const boundIntroduce = introduce.bind(user, "Delhi");

boundIntroduce("India");

// Questions:
// - What is the difference between call and apply?
// - Why does bind not execute the function immediately?
// - What would happen if introduce("Goa", "India")
//   were called directly, without call/apply/bind?
// - Does bind permanently modify the original function?

// Your answer:
/*
output: Alex from Goa, India
        Alex from Pune, India
        Alex from Delhi, India

- both methods invokes functions immediately and explicitly sets the value of this. the difference is how they accpet arguements:
call() accepts argements individually
apply() accepts arguement as array(or array-like object)

- bind() returns a new function with this bound to the specific object. we can execute that returned function later. it does this 
to let us control when the function executes and reuse it later with a specific this.

- When I call introduce("Goa", "India") directly, the value of this depends on the execution context.

In a non-strict CommonJS JavaScript file running in Node.js, this inside a regular function refers to the global object. Since 
the global object normally doesn't have a name property, this.name evaluates to undefined. so the output is:
undefined from Goa, India

If I call introduce("Goa", "India") directly without using call(), apply(), or bind(), the value of this depends on the 
execution mode.
In a non-strict CommonJS JavaScript file running in Node.js, this inside the regular function refers to the global object. Since 
the global object normally doesn't have a name property, this.name evaluates to undefined.

The output would be:
undefined from Goa, India

However, in strict mode or an ES module, this is undefined, so accessing this.name throws a TypeError.

Unlike call(), apply(), and bind(), a direct function call does not explicitly set this to the user object."

- No. bind() does not modify the original function. It returns a new function with its own bound this and, optionally, preset 
arguments. The original introduce function remains unchanged. You can still invoke it using call(), apply(), or a normal 
function call.
*/

/*
========================================================
Q11. CURRYING VS PARTIAL APPLICATION
========================================================

Predict both outputs.
*/
function multiply(a, b) {
  return a * b;
}

const multiplyByTwo = multiply.bind(null, 2);

console.log(multiplyByTwo(5));

function curriedMultiply(a) {
  return function (b) {
    return a * b;
  };
}

console.log(curriedMultiply(2)(5));

// Questions:
// - Explain currying.
// - Explain partial application.
// - How are the two examples different?
// - How does a closure help curriedMultiply work?

// Your answer:
/*
output: 10
        10

- Currying is a technique in JavaScript where a function that takes multiple arguments is transformed into a sequence of functions, 
each taking one argument at a time.

- Partial application is a technique where we fix some arguments of a function in advance, creating a new function that accepts 
the remaining arguments. Here, bind(null, 2) presets the first argument to 2. The new function only needs the remaining 
argument, 5.

- partial application: Presets some arguments of an existing function, Uses bind() in our example, multiplyByTwo(5)
  currying: Breaks a multi-argument function into a sequence of single-argument functions, Uses nested functions in our example,
  curriedMultiply(2)(5)
Both techniques can make functions more reusable, but they work differently.

A closure allows an inner function to access variables from its outer function's lexical scope, even after the outer function 
has finished executing.
*/

/*
========================================================
Q12. map() — COMMON INTERVIEW GOTCHA
========================================================

Predict the exact output.
*/
const numbers = [1, 2, 3];

const result = numbers.map((number) => {
  number * 2;
});

console.log(result);
console.log(numbers);

// Questions:
// - Why does result contain what it contains?
// - Does map automatically return the last expression?
// - Fix the code so result becomes [2, 4, 6].
// - Does map itself modify the original array?

// Your answer:
/*
output: [undefined, undefined, undefined]
        [1, 2, 3]
- it contains that because we are using {} and then not explicitly returning each transformed values.
- map() does not automatically returns the last the expression unless we are using an implicit return with an arrow function
no map does not modify the orignal array but it returns the transformed array whose length is same as the original array

*/
// code fix:
const fresult = numbers.map((number) => {
  return number * 2;
});

/*
========================================================
Q13. filter() AND map() — PRACTICAL
========================================================

Given this array:
*/
const employees = [
  { name: "Amit", salary: 25000 },
  { name: "Sara", salary: 50000 },
  { name: "John", salary: 35000 },
  { name: "Priya", salary: 60000 },
  { name: "Neha", salary: 20000 },
];

// Write a single chained expression using filter and map
// that returns the names of employees earning at least
// 35000.

// Expected result:

// ["Sara", "John", "Priya"]

// Questions:
// - Why should filter come before map in this solution?
// - What would change if map came first?
// - What does each method return?

// Write your code below:
const empNames = employees
  .filter((emp) => emp.salary >= 35000)
  .map((emp) => emp.name);
/*
- we filter first because it filters out the employee whose salary is less than 35000, then the map only creates a array that only
has names in it.
- if map comes first then the employee object will becomes name strings and so the subsequent salary check would fail returning 
only an empty array
- filter() returns a new array containing the element that passes its condition. map() returns a new array containing the results
of applying callback to each element

*/
/*
========================================================
Q14. reduce() — ACCUMULATOR AND INITIAL VALUE
========================================================

Predict every line of output.
*/
const numbers14 = [5, 10, 15];

const result14 = numbers14.reduce((acc, curr) => {
  console.log("acc:", acc, "curr:", curr);
  return acc + curr;
});

console.log("result:", result14);

// Questions:
// - Why does the callback not execute for the first element?
// - What changes if you supply an initial value of 0?
// - What happens if reduce is called on an empty array
//   without an initial value?
// - Why is returning the accumulator important?

// Your answer:
/*
output: acc: 5 curr: 10
        acc: 15 curr: 15
        result: 30

- reduce() requires initial values of the acc as a second arguement and if we not provide it then it considers the first element as
the initial value of its acc and starts from second element

- if we supply 0 as initial values then it will start from the first element of the array

- It throws a TypeError because reduce() cannot determine an initial accumulator from an empty array when no initial value is 
provided

- if we dont return anything then it implicitly return undefined. after the first iteration the acc becomes undefiend
*/

/*
========================================================
Q15. FINAL CODING CHALLENGE — map/filter/reduce
========================================================

Given:
*/
const orders = [
  { item: "Laptop", price: 50000, quantity: 1 },
  { item: "Mouse", price: 1000, quantity: 2 },
  { item: "Keyboard", price: 3000, quantity: 1 },
  { item: "Monitor", price: 12000, quantity: 2 },
  { item: "USB Cable", price: 500, quantity: 4 },
];

// Task:

// Calculate the total cost of orders where the individual
// item price is at least 1000.

// For each qualifying order:
//     order total = price * quantity

// Expected calculation:
//     Laptop:   50000 * 1
//     Mouse:     1000 * 2
//     Keyboard:  3000 * 1
//     Monitor:  12000 * 2

// Expected final result:
//     79000

// Requirements:
// - Use filter(), map() and reduce().
// - Do not use a regular for loop.
// - Keep the solution in a single chained expression.

// Write your code below:
const price = orders
  .filter((o) => o.price >= 1000)
  .map((o) => {
    const total = o.price * o.quantity;
    return total;
  })
  .reduce((acc, curr) => {
    acc += curr;
    return acc;
  }, 0);

console.log(price);
/*
filter() selects orders whose individual item price is at least 1000. The USB Cable order is excluded because its price is 500.
map() calculates the total for each qualifying order by multiplying price * quantity. It returns [50000, 2000, 3000, 24000].
reduce() adds all those totals together, using 0 as the initial accumulator, to produce 79000.

reduce() is suitable because we need to combine multiple order totals into a single value. It accumulates the values one by one 
and returns the final sum.
*/

/*
========================================================
END OF TEST
========================================================

*/
