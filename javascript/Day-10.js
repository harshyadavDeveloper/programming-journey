// Q1. Identify the HOF and callback
function processNumber(num, callback) {
  return callback(num);
}

function square(n) {
  return n * n;
}

console.log(processNumber(5, square));

// - What is the output?
// - Which function is the HOF?
// - Which function is the callback?
// - Why do we pass square instead of square(5)?
// Answer: Output: 25
// here the higher order function is processNumber because it accpets a function as a arguemnt
// here the call back function is square because it is passed to another function as a arguement to be executed later
// because the processNumber accepts the function and executes it later. passing square(5) meaning we are execting the function
// right there. passing square(5) meaning actually we are doing processNumber(5, 25) which will be a typeError

// Q2. Output prediction
function greet(name) {
  return "Hello " + name;
}

function execute(fn) {
  console.log("Start");
  console.log(fn("Harsh"));
  console.log("End");
}

execute(greet);

// Write the exact output and explain when greet() executes.
// Answer: Output: Start
// Hello Harsh
// End
// here greet executes after the line console.log("Start") executes

// Q3. Make code reusable

// Suppose you have three separate functions:
function double(n) {
  return n * 2;
}

function triple(n) {
  return n * 3;
}

function square(n) {
  return n * n;
}

function calculate(n, callback) {
  return callback(n);
}

// Write a reusable function called calculate that accepts a number and a callback, then returns the result of applying that
// callback to the number.

// Demonstrate it with all three functions using the number 4.
console.log(calculate(4, double));
console.log(calculate(4, triple));
console.log(calculate(4, square));

// Q4. Function returning a function
function multiplier(factor) {
  return function (number) {
    return factor * number;
  };
}

const double = multiplier(2);
console.log(double(6));
console.log(multiplier(3)(5));

// Predict both outputs. Is multiplier a HOF? Explain why.
// Answer: Output: 12
//                 15
// Yes multiplier is a higher order function because it returns another function.

// Q5. Build your own reusable array operation

// Given:
const numbers = [1, 2, 3, 4, 5];

// Write a function called operateOnArray that accepts an array and a callback. It should return a new array containing the
// callback's result for every element.
function doubleNum(num) {
  return num * 2;
}
function operateOnArray(arr, callback) {
  const output = [];
  for (let i = 0; i < arr.length; i++) {
    output.push(callback(arr[i]));
  }
  return output;
}
// Test it with a callback that doubles each number.
console.log(operateOnArray(numbers, doubleNum));

// For this question, use a regular for loop like the video, rather than using the built-in map().
// Output: [4, 6, 8, 2, 12]

// Q6. Spot the bug
function transform(number, callback) {
  return callback(number);
}

function addTen(n) {
  return n + 10;
}

console.log(transform(5, addTen(5)));

// - What happens when this runs?
// - Which part of the function call is incorrect?
// - How would you fix the call without changing transform() or addTen()?

// Answer: this throw a typeError when we try to execute this(callback is not a function)
// the part where we do addTen(5) is in-correct
// to fix this we can simply make console.log(transform(5, addTen)). here we are correctly passing the function reference instead
// of exectuing it right there and returning the result

//   Q7. Interview theory
// Explain in your own words:
// 1. What is a higher-order function?
// 2. What is a callback function?
// 3. Can a function be both a HOF and a callback in different situations?

// Answer: HOF is function that accpets function as a arguement or a function that retuns another function
// a callback function is a function that is passed to another function(HOF)
// yes in js a function can be a HOF and a callback at the same time, because this terms describe roles rather than strict data-
// types, a single function can simultaneously fulfill both roles.
function sayHello() {
  console.log("Hello!"); // just a basic function to be used later
}

// this function here accepts a function and executes it later. so rn it is a HOF
const processAndRun = (callback) => {
  console.log("Procesing starts...");
  callback();
};

const mainThread = (callback) => {
  console.log("Start mainThread");
  callback(sayHello);
};

mainThread(processAndRun); // passing processAndRun here makes it a callback

// Q8. Refactor for reusability

// You need to calculate the area and circumference of circles for several radii.

// Write a reusable function that accepts radii and a calculation callback, then returns an array of results. Use it to calculate both area and circumference.

// Don't modify the original functions. Focus on avoiding duplicate looping logic.
const radii = [2, 3, 5];

function area(radius) {
  return Math.PI * radius * radius;
}

function circumference(radius) {
  return 2 * Math.PI * radius;
}

function calculateFormula(arr, logic) {
  const output = [];
  for (let i = 0; i < arr.length; i++) {
    output.push(logic(arr[i]));
  }
  return output;
}

console.log(calculateFormula(radii, area));
console.log(calculateFormula(radii, circumference));
