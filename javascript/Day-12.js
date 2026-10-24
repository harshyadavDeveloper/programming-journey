/*
========================================================
       SEASON 2 — DAY 12: CALLBACK HELL
========================================================

Topics covered:
- JavaScript and asynchronous programming
- Callbacks
- Callback Hell / Pyramid of Doom
- Inversion of Control

Instructions:
1. Answer in your own words.
2. Explain WHY, not just WHAT.
3. Don't use solutions from the next video.
4. Keep answers interview-ready.

========================================================
Q1. JAVASCRIPT AND ASYNCHRONOUS PROGRAMMING
========================================================

JavaScript is described as a single-threaded and synchronous
language, yet it can perform asynchronous operations.

Explain what role callbacks play in this.

Use the following example in your explanation:

createOrder()
    -> proceedToPayment()
        -> showOrderSummary()

Your answer:
- JavaScript can handle asynchronous with the help of brower or NodeJs API, the event loops and callback.
A callback is a function that is passed as an arguement to another function which can be executed when a paticular operation is 
completed.

- in the example proceedToPayment is called after createOrder is completed, and showSummary is called after proceedToPayment is 
completed. 

- Callbacks help us define that waht should happen when an operation finishes. allowing JavaScript to continue handling other 
work instead of blocking the main thread while waiting for asynchronous operations.

*/

/*
========================================================
Q2. CALLBACK HELL / PYRAMID OF DOOM
========================================================

What is callback hell?

Why is deeply nested callback code also called the
"Pyramid of Doom"?

Your answer:
Callback hell occurs when multiple callbacks are nested inside one another, usually because several asynchronous operations 
depend on the completion of previous operations. This makes the code difficult to read, understand, debug, and maintain.

It is called the Pyramid of Doom because each nested callback adds another indentation level, causing the code to grow toward 
the right and form a pyramid-like shape.

*/

/*
========================================================
Q3. INVERSION OF CONTROL
========================================================

Define Inversion of Control in the context of callbacks.

Why can passing a callback function to another function
be risky?

Your answer:
Inversion of Control (IoC) in the context of callbacks means that when we pass a callback function to another function, we give 
that function control over when and how our callback gets executed.

The function receiving our callback controls its execution. If it is poorly implemented, it might:
- Execute the callback at the wrong time.
- Never execute the callback.
- Execute the callback multiple times.
- Pass unexpected arguments or produce unexpected behavior.
This creates a problem because we depend on another function to execute our code correctly.

*/

/*
========================================================
Q4. IDENTIFY THE TWO MAJOR PROBLEMS
========================================================

Suppose createOrder() receives a callback for
proceedToPayment(), which receives another callback for
showOrderSummary().

A. Name the two major problems discussed in the video.

B. Explain each problem briefly.

Your answer:

two major problem that can arise is call back hell and inversion of control.
callback hell: to handle several async code we had to pass showOrderSummary inside proceedToPayment which was already inside createOrder
which made our code grow horizontally instead of vertically. this in the longer run makes the code very less maintainable, 
less scalables and less redable.

inversion of control: here when we pass one function to another function we are giving the control of the function we wrote to 
another function. this can result in un-expected behaviour of our written code: what if callback executes at the wrong time,
what if callback was never executes, what if callback was executes multiple times, what if that function passes unexpected args
to produce unexpected behaviour

*/

/*
========================================================
                 END OF DAY 12 TEST
========================================================
*/
