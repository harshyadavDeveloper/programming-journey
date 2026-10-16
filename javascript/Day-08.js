/*

# DAY 08 — CALLBACK FUNCTIONS & EVENT LISTENERS

Q1. INTERVIEW THEORY — CALLBACK FUNCTIONS

What is a callback function in JavaScript?

Explain:

1. How a function can be passed to another function.
2. When the callback gets executed.
3. Give one simple example using your own functions.

Explain the concept as if answering an interviewer.
*/
// a callback function is a function passed as an argement in another function and executed later either immediately
// or when a specific task or event occours
function greet(name) {
    console.log("Hello, " + name);
}

function processUser(callback) {
    callback("Harsh");
};

processUser();
/*
Explanation:
We pass the greet function as an argument to processUser.
The processUser function receives it as callback.
When callback("Harsh") is called, the greet function executes. */

/*
Q2. INTERVIEW HANDS-ON — CALLBACK EXECUTION ORDER

Predict the exact output:
*/
function first(callback) {
    console.log("First");
    callback();
    console.log("Third");
}

function second() {
    console.log("Second");
}

first(second);

// Explain:

// 1. Why does "Second" print between "First" and "Third"?
// 2. At what point does second execute?
// 3. Is second passed as a function reference or as a function call?
/*
output: First
        Second
        Third
Explanation: 
"Second" prints between "First" and "Third" because callback() executes before the third console.log().
second() executes when callback() is called inside first().
second is passed as a function reference, not a function call, because we pass second without parentheses in 
first(second).
*/


/*
Q3. INTERVIEW THEORY — EVENT LISTENERS

What is an event listener in JavaScript?

Explain:

1. What addEventListener() does.
2. What the event name and callback represent.
3. Why we normally pass a callback function instead of
   calling it immediately.

Write a small browser example that listens for a click
on a button with the id "clickMe".

Note: This question is about browser JavaScript.
*/
/*
An event listner in js is used to execute a function when a specific event occours, such as click, scroll or mouse 
movement.
addEventListener attaches a event handles to a HTML element. the event name specifies the event to listen for and a 
callback function is passsed that eexecutes when the event occours.
We pass a callback so it executes when that event occurs instead of exectuing immediately.
*/
<script>

    const button  = document.getElementById("clickMe");
    button.addEventListener("click", function(){
        console.log("Clicked!")
    })
</script>


/*
Q4. INTERVIEW HANDS-ON — CLOSURE WITH EVENT LISTENER

Study the code:
*/
function attachEventListeners() {
    let count = 0;


    document.getElementById("clickMe")
        .addEventListener("click", function () {
            count++;
            console.log("Button clicked", count);
        });
}

attachEventListeners();

// Answer:
// 1. What happens when the button is clicked three times?
// 2. Why does count not reset to zero after each click?
// 3. How does the callback access count after
//    attachEventListeners() has finished executing?
// 4. How many times is the event listener registered
//    when attachEventListeners() is called once?
// Do not run the code; reason it out.
/*
After three clicks: The output will be:
Button clicked 1
Button clicked 2
Button clicked 3

count is initialized only once when attachEventListeners() executes. Each click increments 
the same variable.
Because of a closure. The callback retains access to the lexical environment in which it was created, even after 
attachEventListeners() has finished executing.
Once, because attachEventListeners() is called only once.
*/


/*
Q5. INTERVIEW THEORY — removeEventListener()

An interviewer asks:

"How can we remove an event listener, and what mistakes
should we avoid?"

Explain:

1. How removeEventListener() works.
2. Why the event type and callback reference matter.
3. Why passing a new anonymous function when removing
   an existing anonymous listener does not work.

Write a small example that registers and then removes
a click listener using the same named function reference.
*/
/*
1. removeEventListener() removes an event listener previously registered using addEventListener().
2. The event type and callback reference must match the ones used during registration. The capture option must also 
match.
3. Passing a new anonymous function does not work because it creates a different function reference, even if the 
code inside is identical.
*/
function handleClick() {
    console.log("Button clicked!");
}

const button = document.getElementById("clickMe");

button.addEventListener("click", handleClick);

button.removeEventListener("click", handleClick);

/*
Q6. INTERVIEW CHALLENGE — EVENT LISTENER & MEMORY

Consider:
*/
function attachEventListeners() {
    let count = 0;

    function handleClick() {
        count++;
        console.log(count);
    }

    const button = document.getElementById("clickMe");
    button.addEventListener("click", handleClick);

    return handleClick;
}

const handler = attachEventListeners();

// Answer:

// 1. What does handler refer to?
// 2. Does handler retain access to count?
// 3. What is the difference between removing the event
//    listener and simply allowing the outer function to
//    finish executing?
// 4. How would you remove the listener using the available
//    variables?
// 5. Why should developers remove listeners when they are
//    no longer needed?

// Focus on closures, callback references, and event
// listener cleanup.
// 1.handler refers to the handleClick function returned by attachEventListeners().
// 2. Yes. Because of a closure, handler retains access to count, even after the outer function finishes executing.
// 3. When the outer function finishes, its execution ends, but the event listener remains registered. Removing the 
// listener is a separate action that stops it from responding to future clicks.
// 4. Use the same function reference to remove the listener:
button.removeEventListener("click", handler);
// This assumes button is accessible in the current scope. In the given code, button is local to
// attachEventListeners(), so you would need to return or otherwise retain a reference to it.
// 5. Developers should remove listeners when they are no longer needed to prevent unintended behavior,
// duplicate event handling, and potential memory leaks.
// =========================================================
// END OF DAY 08
// =============


