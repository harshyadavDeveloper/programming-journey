/*
=========================================================
DAY 07 — FIRST-CLASS FUNCTIONS
=========================================================

SECTION 1 — FUNDAMENTALS
Q1–Q5
*/

/*
Q1. THEORY — FUNCTION DECLARATION VS EXPRESSION

Explain the difference between a function declaration
(function statement) and a function expression.

Include:
1. One example of each.
2. How they differ when called before their definition.
3. What happens during hoisting in each case.

Use your own words.
*/
/*
A function declaration(or statement) is a function defined with a keyword function as a function.
function expression is when created function is assigned to a variable, the variable holds the reference to that function.
the differ because the function declaration will executed but a function expression will throw error i.e. typeError.
during the hoisting of a declaration js engine creates a function object and binds it to its identifier. but for the expression 
it is treated as a varibale so it assigns it with undefiend and basically we are calling undefined() hence the typeError
*/
a(); // executes
b(); // executes
function a() {
  // function delcaration(statement)
  console.log("a called");
}
a(); // executes

var b = function () {
  // function expression
  console.log("b called");
};
b(); // executes

/*
Q2. OUTPUT PREDICTION — FUNCTION HOISTING

Predict the EXACT output or error:

greet();

function greet() {
    console.log("Hello");
}

sayHi();

var sayHi = function () {
    console.log("Hi");
};

Explain why the two calls behave differently.
*/
/*
here the greets executes as intended and sayHi will throw error. reason is how they both are hoisted in js. here for greet js 
engine creates a function object and binds it to its identifier that is why it runs correctly. but in the sayHi case it is
treated as a variable so it is assings it as udefined and when we execture it we are basically doing undefined() so we get typeError

*/

/*
Q3. PRACTICAL — NAMED FUNCTION EXPRESSION

Consider:

var result = function calculate() {
    return 10 + 20;
};

Answer:
1. What does result refer to?
2. What does result() return?
3. Can calculate() be called from outside this expression?
4. What happens if you try to call calculate() outside?

Then write your own named function expression that
returns the square of a number and call it successfully.
*/
// here the result refers to the calculate function itself and when we try to log result it will print [function: calculate].
// when we invoke it with () it will return 30
// no calculate() cannot be called from the outside because it is not defined in the global scope so it bound to its function own
// local scope. basically it is completely invisible to the global scope.
// if we call calculate from out side we will get referenceError.

var square = function calculate(num) {
  return num * num;
};
console.log(square(3));

/*
Q4. THEORY + PRACTICAL — PARAMETERS VS ARGUMENTS

Explain the difference between parameters and arguments.

Then write a function called multiply that accepts two
parameters and returns their product.

Call it with the arguments 4 and 5.

Finally, identify the parameters and arguments in your
own code.
*/
/* parameter are the labels that we give when we are delcaring a function and arguements are passed in the function when we are 
invoking it.
*/
function multiply(num1, num2) {
  // num1 and num2 are params
  return num1 * num2;
}

multiply(5, 3); // 5 and 3 are arguements

/*
Q5. ACTUAL CODING — PASSING A FUNCTION

Write two functions:

1. greet() returns the string "Hello, JavaScript!".
2. executeFunction(fn) accepts a function as an
   argument and prints the result of calling it.

Call executeFunction(greet).

Explain why you pass greet rather than greet().
*/
function greet() {
  return "Hello, Javascript";
}

function executeFunction(fn) {
  console.log(fn());
}

executeFunction(greet);
// we dont pass it with () because that would mean we are executing the function there but we pass it as greet because we are passing
// the reference of the function

/*
=========================================================
SECTION 2 — INTERVIEW PRACTICE
Q6–Q10
=========================================================
*/

/*
Q6. INTERVIEW THEORY — FIRST-CLASS FUNCTIONS

An interviewer asks:

"What does it mean that JavaScript functions are
first-class citizens?"

Give an interview-ready answer.

Explain the three capabilities:
1. Assigning functions to variables.
2. Passing functions as arguments.
3. Returning functions from other functions.

Include a short example that demonstrates at least
two of these capabilities.
*/
/*
in js, functions are first class citizens. this means they can be treated as any other values: they can be assigned to a variable,
passed a arguement in a function and returned from functions.
*/
function morning() {
  return "good morning";
}
var g = morning;
function canExecute(fn) {
  console.log(fn());
}

function returnFunction() {
  return function () {
    console.log("returned function");
  };
}

var result = returnFunction();
result();

canExecute(morning);

/*
Q7. OUTPUT PREDICTION — PASSING VS INVOKING

Predict the EXACT output:

function greet() {
    console.log("Hello");
}

function execute(fn) {
    console.log("Start");
    fn();
    console.log("End");
}

execute(greet);

Explain:
1. What value is passed to execute?
2. When does greet actually execute?
3. Why is execute(greet) different from execute(greet())?
*/
/*
output: Start
        Hello
        End

1. The function reference of greet is passed to execute as an argument.

2. greet executes when fn() is called inside execute().
   Since fn refers to greet, fn() executes greet and prints "Hello".

3. execute(greet) passes the function reference without executing it immediately.

   execute(greet()) executes greet immediately. Since greet() only prints
   "Hello" and returns undefined, execute receives undefined instead
   of a function. When fn() is then called inside execute, it causes a
   TypeError because fn is not a function.

*/

/*
Q8. ACTUAL CODING — RETURNING A FUNCTION

Write a function multiplier(factor) that returns another
function.

The returned function should accept a number and return
that number multiplied by factor.

Expected usage:

const double = multiplier(2);
const triple = multiplier(3);

console.log(double(5)); // 10
console.log(triple(5)); // 15

Explain how your solution demonstrates functions being
returned from other functions.
*/
function multiplier(factor) {
  return function (num) {
    return factor * num;
  };
}
const double = multiplier(2);
const triple = multiplier(3);

console.log(double(5)); // 10
console.log(triple(5)); // 15
// This demonstrates that JavaScript functions are first-class citizens because a function (multiplier) can return another
// function as its result. The returned function retains access to the factor variable from its outer function's scope, even
// after multiplier() has finished executing. This is also an example of a closure.
/*
=========================================================
END OF DAY 07
=========================================================
*/
