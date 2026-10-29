/*
========================================================
       SEASON 2 — DAY 15: PROMISE APIs
========================================================

Topics:
- Promise.all()
- Promise.allSettled()
- Promise.race()
- Promise.any()
- AggregateError
- Input order vs completion order
- Failure handling and practical use cases

Instructions:
1. Predict outputs before running the code.
2. Explain why, not just what.
3. Answer Q1 in interview-ready language.
4. Run each output-prediction example separately.

========================================================
Q1. UMBRELLA THEORY QUESTION
========================================================

Explain Promise.all(), Promise.allSettled(), Promise.race(),
and Promise.any().

For each method, explain:
- When does the returned Promise fulfill or reject?
- What result does it return?
- How does it handle rejected input Promises?
- Give one practical situation where you would use it.

Also explain AggregateError in the context of Promise.any().

Your answer:

- Promise.all(): it fulfills when all the input promises fulfills and returns the array of results in the same of of the input and 
not in the order of completion. It rejects as soon as any input promise rejects, without automatically cancelling the remaining 
operations. It is useful when multiple api request must be succeded such as fetching user details, packages and bookings togehter.

- Promise.allSetteled(): it fulfills when all promises gets setteled, regardless of whether they were fulfilled or rejected. it returns
the array of outcomes containing the status of either the result value or error reason for each promise. it does not rejects just
because an individual promise if rejected. It is useful when u need to call multiple independent api and you need to know which
one succeded and which one failed. 

- Promise.race(): it settles as soon and one input promise is settled. it fulfills with that promises values if it fulfils first
or rejects with its error. it does not automatically cancels the other promises. it is useful for implementing api timeouts by 
racing a request against a timeout promise.

- Promise.any(): fulfills as soon as first input promise fulfills and returns its value. it ignores individual rejections while 
waiting for a successful result. if all the input promise reject it rejects with an aggregator error. it is useful when requesting
data from multiple servers and using the first successful response.

- AgrregatorError is an error object that groups multiple errors into one. In promise.any, it is returned when all the input promises
rejects and its error property contains the rejection reason.
*/


/*
========================================================
Q2. PROMISE.race() VS Promise.any()
========================================================

Predict the output of BOTH examples.

Example A:
*/
{
    const slowSuccess = new Promise((resolve) => {
        setTimeout(() => resolve("Success"), 100);
    });

    const fastFailure = new Promise((resolve, reject) => {
        setTimeout(() => reject("Failure"), 20);
    });

    Promise.race([slowSuccess, fastFailure])
        .then((result) => console.log("Race:", result))
        .catch((error) => console.log("Race:", error));
}

/*
Example B:
*/
{
    const slowSuccess = new Promise((resolve) => {
        setTimeout(() => resolve("Success"), 100);
    });

    const fastFailure = new Promise((resolve, reject) => {
        setTimeout(() => reject("Failure"), 20);
    });

    Promise.any([slowSuccess, fastFailure])
        .then((result) => console.log("Any:", result))
        .catch((error) => console.log("Any:", error));
}

/*
Questions:
- What does each example print?
- Why do the two methods behave differently?
- Which method cares about the first settlement?
- Which method cares about the first fulfillment?

Your answer:
output: example 1: Race: Failure
        example 2: Any: Success

Both methods behave differently because Promise.race() settles based on the first Promise to fulfill or reject, whereas 
Promise.any() ignores rejected Promises and resolves with the first successful result. If all Promises reject, Promise.any() 
rejects with an AggregateError.
Promise.race() cares about the first settlement.
Promise.any() cares about the first fulfillment.
*/


/*
========================================================
Q3. PROMISE.all() — INPUT ORDER VS COMPLETION ORDER
========================================================
*/
{
    const first = new Promise((resolve) => {
        setTimeout(() => resolve("First input"), 80);
    });

    const second = new Promise((resolve) => {
        setTimeout(() => resolve("Second input"), 10);
    });

    const third = new Promise((resolve) => {
        setTimeout(() => resolve("Third input"), 40);
    });

    Promise.all([first, second, third])
        .then((results) => console.log(results));
}

/*
Questions:
- Which operation finishes first?
- What is the final array?
- Does Promise.all() arrange the output according to
  completion time or input order?

Your answer:
- here the second operation finishes first, then the third and then the first
- output: ["First input", "Second input", "Third input"]
- The Promise.all mehthod arranges the output in the order in which we provide the inputs and not in the order of completion
*/


/*
========================================================
Q4. PROMISE.all() — FAIL-FAST BEHAVIOR
========================================================
*/
{
    const slowTask = new Promise((resolve) => {
        setTimeout(() => {
            console.log("Slow task completed");
            resolve("Slow result");
        }, 100);
    });

    const failedTask = new Promise((resolve, reject) => {
        setTimeout(() => {
            reject(new Error("Task failed"));
        }, 20);
    });

    Promise.all([slowTask, failedTask])
        .then((results) => console.log(results))
        .catch((error) => console.log(error.message));
}

/*
Questions:
- Which message prints first?
- Does "Slow task completed" eventually print?
- Does Promise.all() cancel the slow operation?
- Why is this behavior described as fail-fast?

Your answer:
output: Task Failed
        Slow task completed

- Task failed prints first because failedTask rejects after 20 ms, causing Promise.all() to reject and execute the .catch() handler.
- Yes. After 100 ms, the slow task's setTimeout() callback executes and prints Slow task completed.
- No. Promise.all() does not automatically cancel the other Promises when one rejects. The slow task continues running and completes normally.
- It is called fail-fast because Promise.all() rejects as soon as any input Promise rejects, without waiting for the remaining Promises to finish. However, the other 
operations continue running unless they are cancelled separately.
*/


/*
========================================================
Q5. PROMISE.allSettled()
========================================================
*/
{
    const tasks = [
        Promise.resolve("Profile loaded"),
        Promise.reject("Settings failed"),
        Promise.resolve("Notifications loaded")
    ];

    Promise.allSettled(tasks).then((results) => {
        console.log(results);
    });
}

/*
Questions:
- How many outcome objects are returned?
- What properties appear in a fulfilled outcome?
- What properties appear in a rejected outcome?
- Does one rejection prevent allSettled() from returning
  the other outcomes?

Your answer:
output: [
  { status: 'fulfilled', value: 'Profile loaded' },
  { status: 'rejected', reason: 'Settings failed' },
  { status: 'fulfilled', value: 'Notifications loaded' }
]

Number of outcome objects: Three outcome objects are returned, one for each input Promise.
Fulfilled outcome: Contains two properties: status: 'fulfilled' and value, which holds the successful result.
Rejected outcome: Contains two properties: status: 'rejected' and reason, which holds the rejection reason.
Handling rejections: No. A rejected Promise does not prevent Promise.allSettled() from returning the outcomes of the other Promises. It waits until every Promise has 
settled, regardless of whether it fulfilled or rejected.
*/


/*
========================================================
Q6. PROMISE.any() AND AggregateError
========================================================
*/
{
    const taskA = new Promise((resolve, reject) => {
        setTimeout(() => reject(new Error("A failed")), 30);
    });

    const taskB = new Promise((resolve, reject) => {
        setTimeout(() => reject(new Error("B failed")), 10);
    });

    Promise.any([taskA, taskB])
        .then((result) => console.log(result))
        .catch((error) => {
            console.log(error instanceof AggregateError);
            console.log(error.errors.map((err) => err.message));
        });
}

/*
Questions:
- What is the exact output?
- Why does Promise.any() reject?
- What does AggregateError represent here?
- Why is the errors array in input order even though
  taskB fails first?

Your answer:
output: true
        [ 'A failed', 'B failed' ]

- Promise.any() rejects with an AggregateError when all input Promises reject and none fulfills successfully.
- It groups the rejection reasons from all the input Promises into a single error object. Its errors property contains those reasons.
- Because Promise.any() stores rejection reasons according to the original input order, not the order in which the Promises reject. Although taskB fails after 10 ms 
and taskA after 30 ms, taskA was passed first, so "A failed" appears before "B failed" in the array.

*/


/*
========================================================
Q7. CHOOSE THE CORRECT PROMISE API
========================================================

For each situation, choose Promise.all(),
Promise.allSettled(), Promise.race(), or Promise.any().

A. Three required API calls must all succeed before
   displaying a dashboard.

B. Three independent uploads are attempted. You need
   a report showing which succeeded and which failed.

C. Several mirror servers are queried. You need the
   first successful response, even if another server
   fails sooner.

D. You need to know whether the first completed request
   succeeded or failed, without waiting for the others.

Explain why you selected each method.

Your answer:
A. Promise.all() — Use this when all three API calls must succeed before displaying the dashboard. It fulfills when all Promises fulfill and rejects if any one of them 
rejects.
B. Promise.allSettled() — Use this when you need a complete report of all upload attempts. It waits for every Promise to settle and returns the status and result or 
error for each upload, regardless of success or failure.
C. Promise.any() — Use this when querying multiple mirror servers and you need the first successful response. It ignores individual rejections and fulfills with the 
first successful result. If all servers fail, it rejects with an AggregateError.
D. Promise.race() — Use this when you need the outcome of the first request to finish. It settles with the first Promise to fulfill or reject, without waiting for the 
others.
*/


/*
========================================================
Q8. PRACTICAL INTERVIEW CHALLENGE
========================================================

Write a function called getFirstSuccessfulResult(tasks)
that accepts an array of Promises.

Requirements:
- Return the first fulfilled result.
- If all tasks reject, catch the AggregateError.
- Print every individual rejection reason.
- Return a sensible fallback string if all tasks fail.

You may use async/await and try/catch.

Test the function with:
1. One rejected Promise and one fulfilled Promise.
2. Two rejected Promises.

Your implementation:
*/

async function getFirstSuccessfulResult(tasks) {
    try {
        const result = await Promise.any(tasks);
        return result;
    } catch (error) {
        if (error instanceof AggregateError) {
            error.errors.forEach((reason) => {
                console.log(reason);
            });
        }

        return "All tasks failed. No successful result found.";
    }
}
getFirstSuccessfulResult([
    Promise.reject("Task A failed"),
    Promise.resolve("Task B succeeded")
]).then(console.log);

// Output: Task B succeeded

getFirstSuccessfulResult([
    Promise.reject("Task A failed"),
    Promise.reject("Task B failed")
]).then(console.log);

// Output:
// Task A failed
// Task B failed
// All tasks failed. No successful result found.


/*
========================================================
                 END OF DAY 15 TEST
========================================================
*/