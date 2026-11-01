/*
========================================================
       SEASON 2 — DAY 16: THE THIS KEYWORD
========================================================

Topics:
- this in global space
- this inside regular functions
- Strict mode vs non-strict mode
- this substitution with null and undefined
- this inside object methods
- Detached methods
- call(), apply(), bind()
- Arrow functions and lexical this
- Nested functions and arrow functions
- DOM event handlers

IMPORTANT:
Unless a question specifies otherwise:
- Assume a non-strict JavaScript script.
- Assume a regular function call is not made using new.
- Q2 and Q9 specifically assume a browser environment.

Classes and constructors are outside today's scope.

========================================================
Q1. UMBRELLA THEORY QUESTION
========================================================

Explain the this keyword in JavaScript as if you were
answering an interview question.

Cover these points:

- What does this represent in JavaScript?
- What is its value in the global space?
- How does this behave inside a regular function?
- What is the difference between strict and non-strict mode?
- What happens when null or undefined is explicitly
  passed as the this value in a regular function?
- How does this behave inside an object method?
- How do call(), apply(), and bind() affect this?
- Why are arrow functions different?
- What is lexical this?
- How does this behave in DOM event handlers?

Your answer:
this keyword in js referes to a value whose indentity depends on the context in which it is used. for regurlar functions, it depends on how the function is called 
rather than where it is defined.
- in a broweres classic script this in the global space referes to the window object. 
e.g.: console.log(this === window); // true
- when a regular function is called without a object receiver, the value of this depends on whether strict mode is enabled or not.
e.g.: function showThis(){
        console.log(this);
}
showThis();
In a non strict mode it generally refers to the global object, in strict mode it is undefined.

- Difference between strict and non-strict mode
In non-strict mode, JavaScript substitutes the global object when null or undefined is supplied as the this value in a regular function call.
In strict mode, the explicitly supplied value is preserved.
function showThis() {
    console.log(this);
}
showThis.call(null);
showThis.call(undefined);
In non-strict mode, both calls use the global object as this. In strict mode, the first prints null and the second prints undefined.

- when a regular function is called as an object method, this referes to the the object used as the receiver of the call.
const user = {
    name: "Harsh",

    greet: function () {
        console.log(this.name);
    }
};

user.greet(); // Harsh
Here, this refers to user.

- These methods allow us to control the value of this for regular functions.
call() invokes a function immediately with a specified this value and passes arguments individually.
apply() invokes a function immediately with a specified this value and passes arguments as an array or array-like object.
bind() returns a new function with this bound to the specified value, which can be invoked later.

- Arrow functions do not have their own this. Instead, they inherit this from their surrounding lexical scope.
This behavior is called lexical this.
const user = {
    name: "Harsh",

    greet: function () {
        const inner = () => {
            console.log(this.name);
        };

        inner();
    }
};
user.greet(); // Harsh
Here, the arrow function inherits this from greet(), which refers to the user object.
Unlike regular functions, arrow functions cannot have their this changed using call(), apply(), or bind().
-In a regular DOM event-handler function, this generally refers to the DOM element to which the handler is attached.
button.addEventListener("click", function () {
    console.log(this);
});
Here, this refers to the button element.
However, with an arrow function, this is inherited from the surrounding lexical scope rather than being automatically set to the button element.
button.addEventListener("click", () => {
    console.log(this);
});
In this case, this depends on the surrounding scope.
The value of this in JavaScript depends on the execution context. For regular functions, it is primarily determined by how the function is called. Arrow 
functions are different because they inherit this lexically from their surrounding scope.
*/


/*
========================================================
Q2. THIS IN GLOBAL SPACE
========================================================

Assume this code runs in a browser classic script.
*/
console.log(this === window);
console.log(this === globalThis);
/*
Questions:

- What are the two outputs?
- What does this represent in the global space?
- Is window the global object in a browser?
- Why should we be careful when discussing global this
  across different JavaScript environments?

Your answer:
output: true
        true

- In a browser's classic script, top-level this refers to the global object, which is window.
- Yes. In browsers, window represents the global object. globalThis is the standard way to access the global object across JavaScript environments.
Therefore:
this === window → true
this === globalThis → true

- The value of top-level this depends on the environment and execution context.
For example, in Node.js CommonJS modules, top-level this refers to module.exports, not the global object.
In a browser's classic script, global this refers to window. However, this behavior is not universal across all JavaScript environments or module systems.

*/


/*
========================================================
Q3. THIS INSIDE REGULAR FUNCTIONS
========================================================

Predict the exact output.
*/
function normalFunction() {
    return this;
}

function strictFunction() {
    "use strict";
    return this;
}

console.log(normalFunction() === globalThis);
console.log(strictFunction());
/*
Questions:

- Why does the first function return the global object?
- Why does the second function return undefined?
- How does strict mode change the default this binding?

Your answer:
output: true
        undefined
- In non-strict mode, when a regular function is called without an object, this defaults to the global object (globalThis in this browser context).
- The "use strict" directive enables strict mode. In strict mode, JavaScript does not substitute the global object when this is undefined in a regular function call.
- Non-strict mode: A regular function called without an object gets the global object as this.
Strict mode: A regular function called without an object gets undefined as this.
*/


/*
========================================================
Q4. THIS WITH null AND undefined
========================================================

Predict the exact output.
*/
function showThis() {
    return this === globalThis;
}

console.log(showThis.call(null));
console.log(showThis.apply(undefined));

function strictShowThis() {
    "use strict";
    return this;
}

console.log(strictShowThis.call(null));
console.log(strictShowThis.call(undefined));
/*
Questions:

- Why do call(null) and apply(undefined) behave this way
  in the first function?
- Why do the strict function's results differ?
- Explain the this substitution rule.

Your answer:
output: true
        true
        null
        undefined
- The function runs in non-strict mode, so JavaScript substitutes null or undefined with the global object (globalThis) when binding this.
- In strict mode, JavaScript preserves the exact this value passed to the function. Therefore, call(null) returns null, and call(undefined) returns undefined. and 
even if we keep .call() empty it will show undefined
- In non-strict mode, a regular function converts null or undefined supplied as this into the global object. In strict mode, the original value is preserved.
*/


/*
========================================================
Q5. THIS INSIDE OBJECT METHODS
========================================================

Predict the exact output.
*/
const student = {
    name: "Alex",

    printName: function () {
        console.log(this.name);
    }
};

const anotherStudent = {
    name: "Sam",

    printName: student.printName
};

student.printName();
anotherStudent.printName();
/*
Questions:

- Why does the same function print different names?
- Does this depend on where printName was originally
  defined or how it was called?
- What determines the value of this in a method call?

Your answer:
output: Alex
        Sam
- The same function is called on two different objects. Therefore, this refers to student in the first call and anotherStudent in the second call, printing Alex and 
Sam, respectively.
- It depends on how the function is called, not where it was originally defined.
- In a regular method call, this refers to the object immediately before the dot used to invoke the method. this refers to the object used as the receiver of 
the method call
*/


/*
========================================================
Q6. DETACHED OBJECT METHODS
========================================================

Predict the exact output.
*/
const user = {
    name: "Harsh",

    getThis: function () {
        return this;
    }
};

const detachedMethod = user.getThis;

console.log(user.getThis() === user);
console.log(detachedMethod() === globalThis);
/*
Questions:

- Why does the first comparison return true?
- Why does the second comparison also behave differently?
- What happened when we assigned the method to another
  variable?
- How could bind() help preserve the original context?

Your answer:
output: true
        true

- Because user.getThis() is a method call, so this refers to the user object.
- Because detachedMethod() is a plain function call. In non-strict mode, this defaults to the global object, so the comparison returns true.
- We copied the function reference, not its this context. When called independently, its this value is determined by the new call site.
- bind(user) creates a new function whose this is permanently bound to user, even when called independently.

Bind e.g.:
*/
const bindDetachedMethod = user.getThis.bind(user);
console.log(bindDetachedMethod() == globalThis); // false. because this is permanently bound to user 


/*
========================================================
Q7. NESTED REGULAR FUNCTION VS ARROW FUNCTION
========================================================

Predict the exact output.
*/
const person = {
    name: "Sam",

    greet: function () {

        function regularInner() {
            return this;
        }

        const arrowInner = () => {
            return this;
        };

        console.log(regularInner() === person);
        console.log(arrowInner() === person);
    }
};

person.greet();
/*
Questions:

- Why does regularInner() behave differently?
- Where does arrowInner get its this value from?
- Why does the arrow function retain access to person?

Your answer:
output: false
        true

- A regular function has its own this, determined by how it is called. Since regularInner() is called independently in non-strict mode, this refers to globalThis, 
not person. Therefore, the comparison returns false.
- An arrow function doesn't have its own this. It inherits this lexically from its surrounding scope.
- Because arrowInner is defined inside greet(), where this refers to person. The arrow function inherits that same this value, so the comparison returns true.
*/


/*
========================================================
Q8. ARROW FUNCTION — LEXICAL THIS GOTCHA
========================================================

Predict the exact output.
*/
function createUser() {

    return {
        name: "Alex",

        getName: () => {
            return this.name;
        }
    };
}

const user = createUser.call({
    name: "Outer"
});

console.log(user.name);
console.log(user.getName());

const anotherContext = {
    name: "Another"
};

console.log(user.getName.call(anotherContext));
/*
Questions:

- Why does user.name return one value while
  user.getName() returns another?
- Where does the arrow function get its this value?
- Can call() change the this value of an arrow function?
- Why is the arrow function not using the object
  containing it as its this?

Your answer:
output: Alex
        Outer
        Outer
- user.name accesses the name property of the returned object, which is "Alex". However, getName is an arrow function that inherits this from createUser(), so 
it returns "Outer".
- It inherits this lexically from its surrounding scope, which is the execution of createUser(). There, this refers to the object passed to createUser.call().
- No. Arrow functions don't have their own this binding, so call(), apply(), and bind() cannot override their inherited this.
Because an arrow function doesn't derive this from the object used to invoke it. It inherits this from its surrounding lexical scope, regardless of which object 
contains it.
*/


/*
========================================================
Q9. THIS INSIDE DOM EVENT HANDLERS
========================================================

Assume this HTML element exists in a browser:
*/
<button id="myButton">Click Me</button>

const button = document.getElementById("myButton");

button.addEventListener("click", function () {
    console.log(this === button);
});

button.addEventListener("click", () => {
    console.log(this === button);
});
/*
Questions:

- When the button is clicked, what are the two outputs?
- Why does the regular function refer to the button?
- Why does the arrow function behave differently?
- What does this represent inside the regular event
  handler in this example?

Your answer:
output: true
        false
- true, followed by false.
- DOM event handlers using regular functions receive the event element as this.
- Arrow functions don't have their own this; they inherit it from their surrounding lexical scope.
- It represents the DOM element to which the event handler is attached, which is the button in this example.
*/


/*
========================================================
Q10. PRACTICAL — BORROWING METHODS
========================================================

Given:
*/
const user1 = {
    name: "Alex"
};

const user2 = {
    name: "Sam"
};

function introduce(city, country) {
    return this.name + " from " + city + ", " + country;
}


/*

Tasks:

A. Use call() to introduce user1 from Goa, India.

B. Use apply() to introduce user2 from Pune, India.

C. Use bind() to create a function called introduceAlex
   that permanently uses user1 as its this value and
   pre-fills "Delhi" as the city.

D. Call introduceAlex("India").

E. Explain why this technique is called method borrowing
   and how the three methods differ.

Expected outputs:

Alex from Goa, India
Sam from Pune, India
Alex from Delhi, India

Write your implementation below:
Method borrowing is the technique of using a function with a different object's this value without copying that function into the object.
call() invokes the function immediately, accepting arguments individually.
apply() invokes the function immediately, accepting arguments as an array (or array-like object).
bind() returns a new function with a permanently bound this value and optionally pre-filled arguments. It does not invoke the function immediately.
*/
console.log(introduce.call(user1, "Goa", "India"));
console.log(introduce.apply(user2, ["Pune", "India"]));
const introduceAlex = introduce.bind(user1, "Delhi");
console.log(introduceAlex("India"));


/*
========================================================
                 END OF DAY 16 TEST
========================================================

========================================================
*/