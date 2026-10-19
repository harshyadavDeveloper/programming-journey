/*
=========================================================
DAY 09 — ASYNCHRONOUS JAVASCRIPT & EVENT LOOP
=========================================================

SECTION 1 — FUNDAMENTALS
Q1–Q5
*/

/*
Q1. INTERVIEW QUESTION — OUTPUT PREDICTION

Predict the EXACT output in order:
Predict the EXACT output:

console.log("Start");

Promise.resolve().then(() => {
    console.log("Promise 1");

    Promise.resolve().then(() => {
        console.log("Promise 2");
    });
});

setTimeout(() => {
    console.log("Timeout");
}, 0);

console.log("End");

Explain why Promise 2 does or does not execute before
the timer callback.
*/
/*
Output: Start
        End
        Promise 1 
        Promise 2
        Timeout
*/
console.log("1. Start");

setTimeout(() => {
    console.log("2. Timeout");
}, 0);

Promise.resolve().then(() => {
    console.log("3. Promise");
});

console.log("4. End");

// Explain:
// 1. Which statements execute synchronously?
// 2. Which callback enters the microtask queue?
// 3. Which callback becomes a task?
// 4. Why does the output follow this order?

// Do not run the code before predicting.
/* Output: 1. Start
           4. End
           3. Promise
           2. Timeout 

// Synchronous: console.log("1. Start") and console.log("4. End") execute immediately.
// Microtask queue: The Promise's .then() callback enters the microtask queue.
// Task queue: The setTimeout() callback is scheduled as a task (macrotask).
// Execution order: JavaScript executes synchronous code first. Once the call stack is empty, the event loop processes microtasks before tasks,
// so the Promise callback executes before the timeout callback.

/*
Q2. THEORY — JAVASCRIPT RUNTIME

Explain the difference between:

1. Call stack
2. Web APIs / host environment
3. Task queue (often called callback or macrotask queue)
4. Microtask queue
5. Event loop

Explain how these parts cooperate when setTimeout()
and a Promise are used.

Also explain why JavaScript cannot normally execute
a timer
/*
/*
1. Call Stack Executes JavaScript functions in a Last In, First Out (LIFO) order.
2. Web APIs / Host Environment  Handles operations such as timers, DOM events, and network requests outside the JavaScript call stack.
3. Task Queue (Macrotask Queue): Stores callbacks such as setTimeout() callbacks until the call stack is empty and the event loop can schedule 
them.
4. Microtask Queue: Stores callbacks from Promises, such as .then(), .catch(), and .finally(). Microtasks are processed before the next task.
5. Event Loop: Coordinates execution by checking whether the call stack is empty and scheduling queued callbacks. Microtasks are processed 
before the next task.

When JavaScript encounters setTimeout(), the host environment manages the timer and makes its callback eligible to run after the delay. A 
Promise's .then() callback is queued as a microtask. After synchronous execution finishes, microtasks run first, followed by eligible tasks.

JavaScript normally runs synchronous code to completion on its main thread. The event loop cannot schedule a timer callback in the middle of 
that execution because the call stack is still busy.
*/

/*Q3. PRACTICAL — PROMISE VS setTimeout

Predict the EXACT output:
*/
console.log("A");

setTimeout(() => {
    console.log("B");
}, 0);

Promise.resolve().then(() => {
    console.log("C");
});

Promise.resolve().then(() => {
    console.log("D");
});

console.log("E");

// Explain why the callbacks execute in this order.

/*
Output: A
        E
        C
        D
        B
A and E are executes synchronously in order.
C and D are mircro task and are processed in the order they were queued FIFO
B is a task, which executes after the microtask are processed

Microtasks executes before the next task, and micro task are queued in the same order and execute in that order
*/

/*
Q4. PRACTICAL — MICROTASKS CREATING MICROTASKS

Predict the EXACT output:
*/
console.log("Start");

Promise.resolve().then(() => {
    console.log("Promise 1");

    Promise.resolve().then(() => {
        console.log("Promise 2");
    });
});

setTimeout(() => {
    console.log("Timeout");
}, 0);

console.log("End");

// Explain why Promise 2 does or does not execute before
// the timer callback.

/*
Output: Start
        End
        Promise 1
        Promise 2
        Timeout
*/
// synchronous code runs first
// promise callbacks are executes in micro task queue which has priority over callback queue
// when promise 1 is executed it schedules anopther microtask Promise 2
// the event loop processes Promise 2 before moving to callback stack

// micro tasks are drained completey before moving to callback stack(macro task)

/*
Q5. THEORY — STARVATION

What is microtask starvation?

Explain how repeatedly scheduling new microtasks can
delay tasks in the task queue.

Why can this be a problem for browser responsiveness?

Write a small example that demonstrates the idea.
Do not create an infinite loop that prevents you from
testing the rest of your file.
*/
/*
suppose a micro task keeps scheduling another microtask indefinitely. now becasue the micro queue never gets empty event loop never reaches to 
callback queue. this can delay timer call back, user interaction and rendering. 
The event loop drains the microtask queue before executing the next task. If each microtask schedules another microtask, the queue may never 
become empty, delaying tasks such as setTimeout callbacks.
The browser may be unable to render updates or respond promptly to user interactions, such as clicks and scrolling, making the page slow or 
unresponsive.
*/
console.log("Start");

let count = 0;

function scheduleMircotask() {
    if (count >= 5) {
        return;
    }

    count++;
    Promise.resolve().then(() => {
        console.log("Microtask", count);
        scheduleMircotask();
    });
}
scheduleMircotask();
setTimeout(() => {
    console.log("Timeout");
}, 0);

console.log("End");

/*
=========================================================
SECTION 2 — INTERVIEW PRACTICE
Q6–Q10
=========================================================
*/

/*
Q6. INTERVIEW THEORY — WHAT IS ASYNCHRONOUS?

An interviewer asks:

"JavaScript is single-threaded, so how can it handle
asynchronous operations?"

Explain:
1. What single-threaded means in this context.
2. What the host environment does.
3. How callbacks are scheduled.
4. Why asynchronous operations do not necessarily
   block the JavaScript call stack.

Use setTimeout() as an example.
*/
/*
Single-threaded means JavaScript executes one piece of code at a time on a single main thread using a single call stack
The browser or Node.js provides APIs to handle operations like timers, network requests, and file operations outside the JavaScript call stack
When an asynchronous operation completes, its callback is scheduled for execution. For setTimeout(), the callback becomes eligible to run after 
the specified delay and is placed in the task queue.
JavaScript continues executing other code while the timer runs. Once the call stack is empty and higher-priority microtasks are processed, 
the event loop allows the timer callback to execute.
*/
console.log("Start");
setTimeout(() => {
    console.log("Timeout");
}, 0);
console.log("End");
/*
output: Start
        End
        Timeout
setTimeout does not block the call stack. the timer is handled by the hsot environment, and its callback its callback executes later when the
event loop allows it
*/

/*
Q7. OUTPUT PREDICTION — CALL STACK AND QUEUES

Predict the EXACT output:
*/
function first() {
    console.log("First");

    setTimeout(() => {
        console.log("Timer");
    }, 0);

    Promise.resolve().then(() => {
        console.log("Promise");
    });

    console.log("Last");
}

first();

// Explain the execution order, including when the
// microtask queue is processed.
/*
output: First 
        Last
        Promise
        Timer
First prints when first() executes.
setTimeout() schedules the timer callback.
Promise.then() schedules a microtask.
Last prints because synchronous code continues executing.
Once the call stack is empty, the event loop processes the microtask queue first, printing Promise.
The timer callback executes afterward, printing Timer.
*/


/*
Q8. INTERVIEW CHALLENGE — NESTED MICROTASKS

Predict the EXACT output:
*/
Promise.resolve().then(() => {
    console.log("A");

    Promise.resolve().then(() => {
        console.log("B");
    });
});

Promise.resolve().then(() => {
    console.log("C");
});

setTimeout(() => {
    console.log("D");
}, 0);

// Explain why the order of B and C matters.
// Do not assume a nested microtask runs immediately
// when it is created.

/*
output: A
        C
        B
        D
The first Promise schedules A, and the second Promise schedules C.
A executes and schedules B as a new microtask at the end of the microtask queue.
C is already queued, so it executes before B.
After all microtasks finish, the timer callback prints D.
A newly scheduled microtask does not interrupt the currently executing microtask. It joins the queue, and previously queued microtasks execute 
first.
*/


/*
Q9. THEORY — JAVASCRIPT VS WEB APIs

An interviewer asks:

"Are setTimeout(), fetch(), document, and console
part of the JavaScript language itself?"

Explain the distinction between:
1. The JavaScript language and engine.
2. Browser-provided APIs.
3. The runtime's role in asynchronous operations.

Mention that Node.js provides its own host APIs,
which are not identical to browser APIs.

1. JavaScript language and engine: JavaScript defines the language syntax and core features, such as variables, functions, objects, and 
Promises. The engine executes JavaScript code.
2. Browser APIs: Features like setTimeout(), fetch(), document, and console are provided by the browser environment, not all by the JavaScript 
language itself. For example, document is part of the browser's DOM API.
3. Runtime's role: The runtime provides host APIs and coordinates asynchronous operations with the event loop and task queues, allowing 
JavaScript to handle operations without unnecessarily blocking the call stack.
Note: Node.js also provides its own host APIs, such as file system and networking APIs, which are not identical to browser APIs.
*/

/*
Q10. INTERVIEW HANDS-ON — DEBUG THE EXECUTION ORDER

Predict the EXACT output:
*/
console.log("Start");

setTimeout(() => {
    console.log("Timer 1");
}, 0);

Promise.resolve().then(() => {
    console.log("Microtask 1");

    setTimeout(() => {
        console.log("Timer 2");
    }, 0);
});

Promise.resolve().then(() => {
    console.log("Microtask 2");
});

console.log("End");
/*
Explain:
1. What executes before the first microtask?
2. Which microtasks run, and in what order?
3. When does Timer 1 become eligible to execute?
4. When is Timer 2 scheduled?
5. What is the expected ordering of the two timer
   callbacks in a browser?

Output: Start
        End
        Microtask 1 
        Mircotask 2
        Timer 1
        Timer 2
Before the first microtask: All synchronous code executes first, printing Start and End.
Microtask order: Microtask 1 runs first, followed by Microtask 2. The first microtask schedules Timer 2, but that timer does not interrupt the 
microtask queue.
Timer 1 eligibility: Its timer is registered during synchronous execution. With a delay of 0, it becomes eligible after the minimum delay has 
passed.
Timer 2 scheduling: It is scheduled when Microtask 1 executes.
Timer ordering: In this example, Timer 1 is expected before Timer 2 in browsers because its timer was registered first. A zero-millisecond 
delay does not guarantee immediate execution.

=========================================================
END OF DAY 09
=========================================================
*/
