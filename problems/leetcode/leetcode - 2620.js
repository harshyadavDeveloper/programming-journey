// question link: https://leetcode.com/problems/counter/description/
// question difficulty: Easy
// description: Given an integer n, return a counter function. This counter function initially returns n and then returns 1 more than the previous value every subsequent time it is called (n, n + 1, n + 2, etc).

// approach: Closure + Post-Increment
// Use a closure to maintain the value of n between function calls. The outer function returns an inner anonymous function that retains access to n. Each time the returned function is invoked, use the post-increment operator (n++) to return the current value first and then increment it by 1 for the next call. This eliminates the need for an additional counter variable.

/**
 * @param {number} n
 * @return {Function} counter
 */
var createCounter = function (n) {

    return function () {
        return n++;

    };
};

/** 
 * const counter = createCounter(10)
 * counter() // 10
 * counter() // 11
 * counter() // 12
 */