// question link: https://leetcode.com/problems/create-hello-world-function/
// question difficulty: Easy
// description:  Write a function createHelloWorld. It should return a new function that always returns "Hello World".

// approach: Higher-Order Function
// The outer function createHelloWorld returns another function. The returned function uses the rest parameter (...args) to accept any number of arguments, but ignores 
// them and always returns the fixed string "Hello World". This demonstrates JavaScript's ability to return functions from other functions.

/**
 * @return {Function}
 */
var createHelloWorld = function () {

    return function (...args) {
        return "Hello World"
    }
};

/**
 * const f = createHelloWorld();
 * f(); // "Hello World"
 */