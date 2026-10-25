/*
========================================================
       SEASON 2 — DAY 13: PROMISES
========================================================

Topics:
- Creating Promises
- resolve() and reject()
- Promise chaining using then()
- Error handling using catch()
- finally()
- Returning values through a Promise chain

Instructions:
1. Predict outputs before running the code.
2. Explain WHY, not just WHAT.
3. Do not use async/await yet.
4. Write theory answers in comments.
5. Attempt every question independently.

========================================================
Q1. UMBRELLA THEORY QUESTION
========================================================

Explain JavaScript Promises as if you were answering an
interview question.

Cover these points:
- What is a Promise?
- What are its three states?
- What do resolve() and reject() do?
- What is Promise chaining?
- What does then() return?
- What is the purpose of catch()?
- When does finally() execute?

Keep your answer concise and interview-ready.

Your answer:
A promise is JS object that represents the eventual success or failure of asynchronous operation. It's three stages 
are Pending: Initial state, operation is not complete, Fulfilled: operation completed successfully, Rejected: 
operation failed.
resolve() fulfills a promise with a value
reject() rejects the promise with a reason of error
Promise chaining means connecting multiple .then calls to execute async operations sequentially passing the result 
from one step to another.
.then() returns a new promsie, allowing further chaining
.catch() handles error or Promise rejection in a promise chain
.finally() executes when a promise is settled, whether fulfilled or rejected. it is commonly used for cleanup operations.

*/

/*
========================================================
Q2. CREATING A PROMISE
========================================================

Predict the exact output.
*/
const promise2 = new Promise((resolve, reject) => {
    resolve("Order Created");
});

promise2.then((result) => {
    console.log(result);
});

// Questions:
// - What is printed?
// - What does resolve() do here?
// - Does the callback passed to then() execute immediately
//   when resolve() is called?

// Your answer:
/* 
output: Order Created
resolve() here fulfills the promsie with a value "Order Created"
No. it exectues asynchronously as a micro task, after the current synchronous code is finished.
*/

/*
========================================================
Q3. PROMISE EXECUTOR — SYNCHRONOUS OR ASYNCHRONOUS?
========================================================

Predict the exact output order.
*/
console.log("A");

const promise3 = new Promise((resolve) => {
    console.log("B");
    resolve("C");
});

promise3.then((result) => {
    console.log(result);
});

console.log("D");

// Questions:
// - Why does B appear before D?
// - Why does C appear after D?
// - Which part executes synchronously?
/*
output: A
        B
        D
        C
The Promise executor function (the function passed to new Promise()) executes synchronously.
Execution order:
1. console.log("A") → prints A.
2. new Promise() → executor runs immediately and prints B.
3. resolve("C") → fulfills the Promise with "C".
4. .then() → schedules its callback as a microtask.
5. console.log("D") → prints D.
6. The .then() callback executes → prints C.

The Promise executor function ((resolve) => { console.log("B"); resolve("C"); }) and the regular console.log("A") 
and console.log("D") statements execute synchronously. Only the callback passed to .then() executes asynchronously as 
a microtask.

*/

/*
========================================================
Q4. PROMISE CHAINING
========================================================

Predict the exact output.
*/
Promise.resolve(5)
    .then((value) => {
        console.log(value);
        return value * 2;
    })
    .then((value) => {
        console.log(value);
        return value + 10;
    })
    .then((value) => {
        console.log(value);
    });

// Questions:
// - What is printed?
// - How does each returned value reach the next then()?
// - Why is returning a value important in a Promise chain?

// Your answer:
/*
output: 5
        10
        20
Each .then() returns a new Promise. When its callback returns a value, that Promise fulfills with the returned value, 
which becomes the argument of the next .then() callback.

Returning a value passes the result to the next .then(), allowing us to perform sequential operations. Without 
return, the next .then() receives undefined (assuming no other value is returned).

*/

/*
========================================================
Q5. FIND THE BUG — MISSING RETURN
========================================================

Predict the exact output.
*/
Promise.resolve(10)
    .then((value) => {
        value * 2;
    })
    .then((result) => {
        console.log(result);
    });

// Questions:
// - What is printed?
// - Why doesn't the second then() receive 20?
// - What change is needed to pass 20 to the next then()?

// Your answer:
/*
output: undefined
the second .then() is not able to receive 20 becasue we are not returning the value*2
if we add the key word return before value*2 then the promise will be able to pass the result correctly
*/
Promise.resolve(10)
    .then((value) => {
        return value * 2;
    })
    .then((result) => {
        console.log(result);
    });

/*
========================================================
Q6. ERROR HANDLING WITH catch()
========================================================

Predict the exact output.
*/
Promise.reject("Payment Failed")
    .catch((error) => {
        console.log(error);
        return "Payment Retried";
    })
    .then((result) => {
        console.log(result);
    });
/*
Questions:
- What gets printed?
- Why does then() execute after catch()?
- What happens if catch() handles an error and returns
  a normal value?

Your answer:
output: Payment Failed
        Payment Retried
Because catch() handles the rejection and returns a normal value, allowing the Promise chain to continue successfully
to the next then()

The Promise returned by catch() becomes fulfilled with that value, and the next then() receives it as its argument.



*/

/*
========================================================
Q7. finally() — INTERVIEW GOTCHA
========================================================

Predict the exact output.
*/
Promise.resolve(100)
    .then((value) => {
        console.log("Value:", value);
        return value + 50;
    })
    .finally(() => {
        console.log("Cleanup");
    })
    .then((value) => {
        console.log("Final value:", value);
    });
/** 
Questions:
- What is printed, in order?
- Does finally() normally receive the resolved value?
- Does finally() normally replace the previous result
  when its callback completes successfully?

Your answer:
output: Value: 100
        Cleanup
        Final value: 150
No. finally() does not receive the resolved value or rejection reason as an argument.

No. If its callback completes successfully, finally() preserves the previous result or rejection, allowing the Promise chain to continue with 
the original outcome.

*/

// ========================================================
// Q8. PRACTICAL — ORDER PROCESSING
// ========================================================

// Write the missing code to create the following Promise
// workflow.

// Requirements:

// 1. createOrder() returns a Promise that resolves with
//    "Order Created".

// 2. proceedToPayment() accepts the order status and
//    returns a Promise that resolves with:
//    "Payment Successful"

// 3. showOrderSummary() accepts the payment status and
//    prints it.

// 4. Chain the three operations so that they execute in
//    the correct order.

// 5. Add a catch() that prints any error.

// Expected output:

// Order Created
// Payment Successful

// Write your implementation below:

function createOrder() {
    return Promise.resolve("Order Created");
}

function proceedToPayment(orderStatus) {
    console.log(orderStatus);
    return Promise.resolve("Payment Successful");
}

function showOrderSummary(paymentStatus) {
    console.log(paymentStatus);
}



// Write the Promise chain here.
createOrder()
    .then((res) => {
        return proceedToPayment(res);
    })
    .then((res) => {
        showOrderSummary(res);
    })
    .catch((err) => {
        console.log("Error:", err);
    })
    .finally(() => {
        console.log("Cleanup runs anyways");
    });
/*
========================================================
END OF DAY 13 TEST
========================================================
*/
