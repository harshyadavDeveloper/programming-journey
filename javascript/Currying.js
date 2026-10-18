// Q1. Output prediction — Currying
function calculate(a) {
    return function (b) {
        return a + b;
    };
}

const result = calculate(5);

console.log(result);
console.log(result(10));
console.log(calculate(3)(7));


// What are the three outputs? Explain what calculate(5) returns.
/*Output: [Function (anonymous)] 
          15
          10
calculate(5) returns an inner function that takes b and returns a + b. It remembers a = 5 through a closure. 
*/


// Q2.Output prediction — bind()
function multiply(a, b) {
    return a * b;
}

const double = multiply.bind(null, 2);

console.log(double(4));
console.log(double(9));
console.log(multiply(3, 5));


// Predict all outputs.Why does double() need only one argument ?
/*Output: 8
          18
          15
multiply.bind(null, 2) creates a new function with the first argument, a, permanently set to 2.

          */


// Q3.Output prediction — call(), apply(), bind()
const person = {
    name: "Sam"
};

function introduce(city) {
    return this.name + " from " + city;
}

console.log(introduce.call(person, "Goa"));
console.log(introduce.apply(person, ["Pune"]));

const intro = introduce.bind(person, "Delhi");
console.log(intro());

// Write the exact output and explain when the function executes in each case.
/*
Output: Sam from Goa
        Sam from Pune
        Sam from Delhi
call() and apply() execute the function immediately when their respective lines are executed. bind() does not execute 
the function immediately; it returns a new function with this and the specified arguments preset, which executes when 
intro() is called.
*/


// Q4.Write code — Currying
// Write a curried function called subtract so this works:

function subtract(x) {
    return function subtraction(y) {
        return x - y;
    }
}
console.log(subtract(10)(3)); // 7
console.log(subtract(20)(8)); // 12

// Don't look up the solution. Try building it using a function that returns another function.

// Q5.Write code — bind()
// Given this function:
function greet(greeting, name) {
    return greeting + ", " + name + "!";
}
// Use bind() to create a function called sayHello that pre - fills "Hello" as the greeting.
// It should produce:
const sayHello = greet.bind(null, "Hello");
console.log(sayHello("Harsh")); // Hello, Harsh!
console.log(sayHello("Alex"));  // Hello, Alex!

// Q6.Explain the difference
// In your own words, answer these three:
//- How does currying differ from partial application ?
//- Why can a curried inner function access an outer function's argument?
//- What is the main difference between call() and bind() ?

/*
1. Currying vs Partial Application: Currying converts a function with multiple arguments into a chain of functions taking one argument at a time. Partial application fixes some arguments in advance.
2. Closure: A curried inner function can access outer function arguments because of a closure, which preserves access to the outer function's variables.
3. call() vs bind(): call() executes the function immediately, while bind() returns a new function to execute later.
*/