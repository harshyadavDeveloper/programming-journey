/*
=========================================================
DAY 06 — setTimeout + CLOSURES
=========================================================

Q1. FUNDAMENTALS — setTimeout EXECUTION

Predict the output order:
*/
function test() {
  let i = 1;

  setTimeout(function () {
    console.log(i);
  }, 2000);

  console.log("Namaste JavaScript");
}

test();

// Answer:
// 1. Write the output in order.
// 2. Explain why "Namaste JavaScript" does not wait for
//    the timer.
// 3. What does setTimeout do with the callback function?
// 4. What role does the closure play here?

// Do not focus on the event loop's internal details yet.
/*
Output: Namaste Javascript
        1
JS executes synchronous code first. console.log("Namaste Javascript") is synchronous and does wait for the timer. setTimeout 
schedules the callback to run after 2000ms(2s) and it does not pause the remaining code inside the function.
basically the setTimeout takes a callback function and delays it. the callback function is registered along with the timing 
mechanism. JS continus executing synchronous code and when the mentioned time is elapsed the callback function is then eligible 
to execute. the callback function runs when the callback is available.
closure allows the timeout function to retains the values of its lexical environment even when the outer function has complete 
execution.

*/

/*
Q2. INTERVIEW QUESTION — CLOSURES INSIDE A LOOP

Predict the output and approximate timing:

function printNumbers() {
    for (var i = 1; i <= 5; i++) {
        setTimeout(function () {
            console.log(i);
        }, i * 1000);
    }

    console.log("Namaste JavaScript");
}

printNumbers();

Answer:
1. What prints immediately?
2. What gets printed by the five callbacks?
3. Approximately when does each callback run?
4. Why doesn't the output show 1, 2, 3, 4, 5?

Explain the complete reasoning before running the code.
*/
/*
Namaste JavaScript prints immediately because it is synchronous code, and JavaScript does not wait for the timer callbacks to 
execute.
The output is 6, 6, 6, 6, 6 because all five callbacks share the same var variable i. When the loop finishes, i becomes 6, so 
every callback prints 6.
The first callback runs after approximately 1 second, the second after 2 seconds, the third after 3 seconds, the fourth after 4 seconds, and 
the fifth after 5 seconds. These are minimum delays, so callbacks may execute later.
The loop uses var, which is function-scoped. All five callbacks refer to the same variable i. The loop finishes before the 
callbacks execute, leaving i with the value 6. Therefore, all five callbacks print 6.
If we replace var with let, each iteration gets its own binding of i. Each callback can access its iteration's value through a 
closure, so the output becomes 1, 2, 3, 4, 5.
*/

/*
Q3. DEBUGGING — WHY DOES IT PRINT 6?

Use the code from Q2.

Explain step by step:
1. What are the values of i during the loop iterations?
2. Does setTimeout stop the loop until its timer expires?
3. Which i binding do the five callback functions access?
4. What is the value of i when the loop finishes?
5. Why do the callbacks access that final value?

Explain the connection between closures and var scope.
*/
/*
Iteration	Value of i	Timer delay
1	        1	        1 second
2	        2	        2 seconds
3	        3	        3 seconds
4	        4	        4 seconds
5	        5	        5 seconds
after the last iteration the value of i becomes 6. the condition i<=5 becomes fasle and loop stops. 

No. setTimeout() schedules the callback to execute after the specified delay. It does not block or pause the loop.

All five callbacks access the same i variable because var is function-scoped.
The callbacks do not get separate copies of i. Each callback has a closure that allows it to access the same variable in the 
surrounding lexical environment.

The value is 6.
After the iteration where i = 5, the increment expression i++ changes it to 6. The condition 6 <= 5 is false, so the 
loop terminates.

The callbacks execute after the loop has finished. Because they all refer to the same i variable, they read its current value, 
which is 6
*/

/*
Q4. PRACTICAL — FIX IT WITH let

Modify the code from Q2 using the smallest possible
change so that the callbacks print:

1
2
3
4
5

Each number should appear after its corresponding
approximately one-second interval.

Requirements:
- Do not change the callback's logic.
- Do not introduce another function.
- Explain why your change works.
- Explain how each iteration's variable binding differs.
*/
function printNumbers() {
  for (let i = 1; i <= 5; i++) {
    setTimeout(function () {
      console.log(i);
    }, i * 1000);
  }

  console.log("Namaste JavaScript");
}

printNumbers();
// let is block-scoped. In a for loop, JavaScript creates a separate binding of i for each iteration.
/*
- First iteration: the callback remembers i = 1.
- Second iteration: the callback remembers i = 2.
- Third iteration: the callback remembers i = 3.
- Fourth iteration: the callback remembers i = 4.
- Fifth iteration: the callback remembers i = 5.
Each callback has a closure that allows it to access its own iteration's binding of i. */

/*
Q5. INTERVIEW CHALLENGE — SOLVE IT USING var

An interviewer now says:

"You cannot use let or const. Solve the same problem
using var."

Write a working solution that prints 1, 2, 3, 4, 5 at
approximately one-second intervals.

Hints:
- Create a helper function that receives the current i.
- Call that helper inside the loop.
- Put setTimeout inside the helper.
- Use the received argument inside the callback.

Do not copy a solution from the internet. Derive it
from your understanding of closures.
*/
function printNumbers() {
  for (var i = 1; i <= 5; i++) {
    function x(y) {
      setTimeout(function () {
        console.log(y);
      }, y * 1000);
    }
    x(i);
  }

  console.log("Namaste JavaScript");
}

printNumbers();

/*
Q6. INTERVIEW THEORY — WHY DOES THE HELPER WORK?

Using your solution from Q5, explain:

1. What happens every time the helper function is called?
2. Why does each helper invocation have its own parameter?
3. Which variable does the delayed callback access?
4. Why does the solution work even though the loop
   still uses var?
5. What does the helper function have to do with
   creating separate lexical environments?

Answer as if the interviewer asks you to explain
your code without running it.

Every time `x(i)` is called, the helper function executes and receives the current value of `i` as its argument `y`. It schedules 
a callback using `setTimeout()` with a delay of `y * 1000` milliseconds.
Each function invocation creates its own execution context and parameter binding. Therefore, each call has its own `y` value: 1, 
2, 3, 4, or 5.
The delayed callback accesses the parameter `y` from the helper function's lexical environment. The closure allows it to access 
that parameter even after the helper function has finished executing.
Although the loop uses `var`, the callback does not access the loop variable `i` directly. Instead, it accesses `y`, which belongs 
to a separate helper-function invocation. Therefore, the callbacks print their respective values rather than all printing 6.
Every time the helper function is invoked, JavaScript creates a new execution context with a separate parameter binding for `y`. 
Each callback closes over the lexical environment of its corresponding helper invocation, preserving access to the correct value.

=========================================================
END OF DAY 06
=========================================================
*/
