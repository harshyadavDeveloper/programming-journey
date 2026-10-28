/*
========================================================
       SEASON 2 — DAY 14: ASYNC / AWAIT
========================================================

Topics:
- async functions always return Promises
- Returning normal values and Promises
- await and Promise unwrapping
- Suspending and resuming async functions
- Multiple Promises with different timers
- Sequential execution with await
- Async/await vs .then()
- fetch() and response.json()
- Error handling with try/catch
- Practical asynchronous workflows

IMPORTANT:
Run output-prediction snippets individually when checking
your answers. Multiple timer examples can overlap if run
together.

========================================================
Q1. UMBRELLA THEORY QUESTION
========================================================

Explain async/await in JavaScript as if you were answering
an interview question.

Cover these points:

- What is an async function?
- Does an async function always return a Promise?
- What happens when it returns a string, number, or object?
- What happens when it returns another Promise?
- What does await do?
- Does await block the JavaScript main thread?
- What happens to an async function when it reaches await?
- How does execution resume?
- Why is async/await often preferred over .then()?
- How can try/catch handle rejected Promises?

Keep your answer concise and interview-ready.

Your answer:
Async/await is a JavaScript feature that simplifies writing asynchronous code, such as fetching data from an API or waiting for a timer, making it easier to read and 
maintain.
An async function is declared using the async keyword before a function. Every async function returns a Promise.
If an async function returns a string, number, or object, JavaScript fulfills the returned Promise with that value. If the function returns another Promise, its own 
Promise adopts the eventual state of that Promise, although it isn't necessarily the same Promise object by reference.
The await keyword is used inside an async function to suspend its execution until the awaited value is available. If the value is a Promise, await returns its 
fulfillment value or throws its rejection reason.
Await does not block the JavaScript main thread. Instead, the async function suspends at the await expression, allowing JavaScript to execute other work. When the 
awaited Promise settles, the suspended function resumes through Promise-related microtask processing.
Async/await is often preferred over .then() because it makes asynchronous code look more like synchronous code, improving readability and simplifying error handling.
Finally, try/catch can handle rejected Promises when they are awaited inside the try block. The rejection is thrown at the await expression and can be handled by the 
corresponding catch block.

*/


/*
========================================================
Q2. ASYNC FUNCTION RETURN VALUE
========================================================

Predict the exact output.
*/
{
    async function getMessage() {
        return "Namaste JavaScript";
    }

    console.log("A");

    getMessage().then((message) => {
        console.log(message);
    });

    console.log("B");
}

// Questions:

// - What is the exact output order?
// - Why does getMessage() return a Promise even though
//   it returns a string?
// - Why does the message appear after "B"?

// Your answer:
/*
output: A
        B
        Namaste JavaScript
In js async function always returns a Prmose.if an async function returns string number or an object js fulfils the promise with that value.
The message appears after "B" because the callback passed to `.then()` is added to the microtask queue once the Promise is fulfilled. JavaScript continues executing 
the remaining synchronous code first. After the synchronous execution is complete, the callback is taken from the microtask queue and executed on the call stack. 
*/



/*
========================================================
Q3. RETURNING A PROMISE FROM AN ASYNC FUNCTION
========================================================

Predict the exact output.
*/
{
    const originalPromise = Promise.resolve("Done");

    async function getResult() {
        return originalPromise;
    }

    const returnedPromise = getResult();

    console.log(returnedPromise instanceof Promise);
    console.log(returnedPromise === originalPromise);

    returnedPromise.then((value) => {
        console.log(value);
    });
}
/*
Questions:

- What are the three outputs?
- Does JavaScript create a nested Promise?
- Why can the two Promises resolve to the same value
  while still being different objects?

Your answer:
output: true
        false
        Done
No js does not created a nexted promise if a async function returns a promise by itself. return promise adopts the evental state of its own promise. getResult() 
returns a Promise that adopts the state of originalPromise, but it doesn't return the exact same Promise object.
Even tho both promises fulfil with the value they are not the same object in the memory. because async function return its own promise. when u return another promise 
inside it, the promise returned by the async function adopts the state and eventual result of that promise. it does not return the exact same promise object.
*/


/*
========================================================
Q4. WHAT HAPPENS AT await?
========================================================

Predict the exact output order.
*/
{
    console.log("Start");

    async function demo() {
        console.log("Before await");

        const value = await Promise.resolve("Resolved value");

        console.log(value);
        console.log("After await");
    }

    demo();

    console.log("End");
}

// Questions:

// - Why does "End" print before "Resolved value"?
// - Does Promise.resolve() need to wait for a timer?
// - Why does execution continue after await even though
//   the Promise is already fulfilled?

// Your answer:
/*
output: Start
        Before await
        End
        Resolved value
        After await
When JavaScript encounters await, the async function pauses its execution at that point, and the remaining synchronous code continues executing. Once the current 
synchronous execution finishes, the async function resumes through the microtask queue.

No. Promise.resolve() immediately creates a fulfilled Promise when given a regular value. It does not need a timer or any asynchronous operation to complete.

Even if a Promise is already fulfilled, await suspends the async function and schedules its continuation as a microtask. The function resumes after the current 
synchronous code finishes, allowing JavaScript to continue executing without blocking.

*/



/*
========================================================
Q5. TWO PROMISES — THE TIMER GOTCHA
========================================================

Predict the exact output order and explain approximately
when each line appears.
*/
{
    const p1 = new Promise((resolve) => {
        setTimeout(() => {
            resolve("P1 promise is resolved");
        }, 8000);
    });

    const p2 = new Promise((resolve) => {
        setTimeout(() => {
            resolve("P2 promise is resolved");
        }, 4000);
    });

    async function handlePromise() {
        console.log("Hello world");

        const val1 = await p1;
        console.log(val1);

        const val2 = await p2;
        console.log("Namaste JS");
        console.log(val2);
    }

    handlePromise();
}
/*
Questions:

- Which Promise resolves first?
- Does the function continue immediately when p2 resolves?
- Why might both Promise values be logged around the
  same time, even though their timers differ?
- Does await p2 restart its four-second timer?

Your answer:
output: Hello World 
        P1 Promise is resolved
        Namaste JS
        P2 promise is resolved
- p2 resolves first because its timer is set to four seconds, while p1 has an eight-second timer. Both timers start when the Promises are created.
- No. The async function is suspended at await p1. Even though p2 resolves after four seconds, the function cannot proceed to the next statement until p1 resolves.
- Both timers start independently when the Promises are created. Although p2 resolves after four seconds, the function is waiting for p1, which resolves after eight 
seconds. By then, both Promises are fulfilled, so the function can process both values in quick succession.
- No. The timer starts when p2 is created. When execution reaches await p2, the Promise is already fulfilled, so the function resumes through a microtask without 
waiting another four seconds.
*/


/*
========================================================
Q6. DOES await BLOCK THE MAIN THREAD?
========================================================

Predict the output order.
*/
{
    function waitOneSecond() {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve("Timer finished");
            }, 1000);
        });
    }

    async function testWait() {
        console.log("Inside before await");

        const result = await waitOneSecond();

        console.log(result);
    }

    testWait();

    console.log("Outside after calling testWait()");
}
/*
Questions:

- Which line appears immediately after calling testWait()?
- Which line appears after approximately one second?
- Why can other JavaScript code execute while testWait()
  is suspended?
- Does the entire JavaScript program freeze at await?

Your answer:
output: Inside Before await
        Outside after calling testWait()
        Timer finished 
- The that appears immediately after calling testWait() is Inside before await and in the next line Outside after calling testWait()
- Timer finished appears approx after one second
- JavaScript suspends the execution of testWait() at await without blocking the main thread. This allows the remaining synchronous code to execute while the 
asynchronous operation is pending.
- No. await suspends only the execution of the current async function. The JavaScript runtime can continue executing other synchronous code and processing other 
tasks while the function is suspended.
*/


/*
========================================================
Q7. CONVERT .then() INTO ASYNC/AWAIT
========================================================

Given the following code:
*/
function fetchNumber() {
    return Promise.resolve(5);
}

function doubleNumber(number) {
    return Promise.resolve(number * 2);
}

fetchNumber()
    .then((number) => {
        return doubleNumber(number);
    })
    .then((result) => {
        console.log(result);
    })
    .catch((error) => {
        console.log("Error:", error.message);
    });

// Tasks:
// A. What does the original code print?
// B. Rewrite the workflow using an async function and await.
// C. Use try/catch for error handling.
// D. Explain why both versions produce the same result.
// Write your implementation below:
async function calculateResult() {
    try {
        const number = await fetchNumber();
        const result = await doubleNumber(number);
        console.log(result);
    } catch (err) {
        console.log("Error:", err.message);
    }
}
calculateResult();
/*
output: 10

Both versions perform the same sequence of asynchronous operations:
1. Retrieve the number 5 using fetchNumber().
2. Pass that number to doubleNumber(), which returns 10.
3. Print the final result.
Both approaches handle Promise fulfillment and can handle errors. In the original code, .catch() handles rejected Promises in the chain. In the rewritten version, 
try/catch handles errors thrown during execution or propagated by rejected Promises awaited inside the try block.

Interview takeaway: async/await is syntax built on Promises that makes asynchronous code easier to read and maintain. It doesn't make the underlying operations 
synchronous.
*/



/*
========================================================
Q8. FETCH AND response.json()
========================================================

Complete the missing code.

Assume fetchUserResponse() simulates a fetch response
and its json() method returns a Promise.
*/
{
    function fetchUserResponse() {
        return Promise.resolve({
            json: () => Promise.resolve({
                name: "Alex",
                role: "Developer"
            })
        });
    }

    async function getUser() {
        try {
            // 1. Await fetchUserResponse() and store
            //    the result in a variable called response.
            const response = await fetchUserResponse();

            // 2. Await response.json() and store the
            //    resulting data in a variable called data.
            const data = await response.json()

            // 3. Print data.name and data.role.
            console.log(data.name + ' ' + data.role);

        } catch (error) {
            console.log("Request failed:", error.message);
        }
    }

    getUser();
}
/*
Questions:

- Why are there two await expressions?
- What does fetch() normally resolve to?
- Why does response.json() also need to be awaited?
- What is the purpose of try/catch here?

Expected output:

Alex
Developer

Write your missing code below:
- There are two separate asynchronous operations:
1. fetchUserResponse() returns a Promise that resolves to a response object.
2. response.json() returns another Promise that resolves to the parsed data.
Each Promise must be awaited to obtain its resolved value before proceeding.

- The fetch() function returns a Promise that fulfills with a Response object when the response is available.
An HTTP error status, such as 404 or 500, doesn't automatically reject the Promise. You generally need to check response.ok to detect unsuccessful HTTP 
responses

- Because response.json() returns a Promise that fulfills with the parsed response body. Using await lets you access the resulting JavaScript object.

- It handles errors thrown inside the try block, including rejections from Promises awaited there. This lets you handle failures gracefully instead of leaving them 
unhandled.
*/


/*
========================================================
Q9. ERROR HANDLING WITH TRY/CATCH
========================================================

Predict the exact output.
*/
{
    async function processPayment() {
        try {
            const result = await Promise.reject(
                new Error("Payment failed")
            );

            console.log("Result:", result);
        } catch (error) {
            console.log("Caught:", error.message);
        }

        console.log("Process ended");
    }

    processPayment();
}
/*
Questions:

- Why does execution enter the catch block?
- Why doesn't "Result:" get printed?
- Why does "Process ended" still get printed?
- What would happen to the async function's returned
  Promise if the error were not caught?

Your answer:
output: Caught: Payment Failed
        Process Ended
Promise.reject() creates a rejected Promise. When await encounters this rejected Promise, it throws the rejection reason as an exception inside the async function. 
The catch block catches that exception.

Because the Promise is rejected, await throws an error instead of returning a value. Execution skips the remaining statements in the try block and moves directly to 
the catch block.

The catch block handles the error, allowing execution to continue after the entire try/catch statement. Therefore, "Process ended" is printed.

If the error is not caught, the Promise returned by the async function becomes rejected with that error.
*/


/*
========================================================
Q10. FINAL PRACTICAL — ORDER PROCESSING
========================================================

Rewrite the following Promise-based workflow using
async/await and try/catch.
*/

function createOrder() {
    return Promise.resolve("Order Created");
}

function proceedToPayment(orderStatus) {
    return Promise.resolve("Payment Successful");
}

function showOrderSummary(paymentStatus) {
    console.log(paymentStatus);
}

createOrder()
    .then((order) => {
        console.log(order);
        return proceedToPayment(order);
    })
    .then((payment) => {
        showOrderSummary(payment);
    })
    .catch((error) => {
        console.log("Error:", error.message);
    });
/*
Requirements:

- Keep the three existing functions unchanged.
- Write an async function called processOrder().
- Use await to process each operation in order.
- Print the order status and payment status.
- Catch errors using try/catch.
- Call processOrder() after defining it.

Expected output:

Order Created
Payment Successful

After writing your code, explain how await lets the
workflow read sequentially without blocking the main
JavaScript thread.

Write your implementation below:
*/
async function processOrder() {
    try {
        const order = await createOrder();
        console.log(order);
        const payment = await proceedToPayment(order);
        showOrderSummary(payment);

    } catch (err) {
        console.log('Error: ', err.message);
    }
}
// await makes asynchronous code read sequentially by pausing the execution of the current async function until the awaited Promise settles. During this time,
// JavaScript can continue executing other code on the main thread instead of blocking it.

// Once the Promise settles, the async function resumes through the microtask queue and continues from where it paused. This allows us to write asynchronous operations
// in a clear, sequential style without blocking the main JavaScript thread.


/*
========================================================
                 END OF DAY 14 TEST
========================================================

*/