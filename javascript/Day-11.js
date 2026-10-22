// 10 questions · Interview-focused

// Q1. Umbrella theory question
// Explain map(), filter(), and reduce() in JavaScript. Include their definitions, return values, use cases, and differences.
// Give one example of each.
// Write your answer in comments as if you were answering an interviewer aloud.
// map(): creates a new array by calling a callback function on each element of the original array and places the results in the
// new array. used when we want to transform every element of the array while preserving the original one. always returns same no.
// elements in the new array as in the old one.

// filter(): it is used to filter the elements of an array. creates a new array containing only the values that satisfies the
// condition. used when u want to keep the elements that pass the condition. can return 0 or more elements.

// reduce(): processes array element through a callback and updates the accumulator. ultimately producing a single accumulated
// result. used when u want to calculate sum, min/max, create an object, group data, find occourances or derive another value
// from the data.
const arr = [1, 3, 5, 2, 9];

const mapOutput = arr.map((e) => e * 2); // map example transformation

const filterOutput = arr.filter((e) => e % 2 === 0); // filtering

const reduceOuput = arr.reduce((acc, curr) => {
  // reduce
  acc += curr;
  return acc;
}, 0);

console.log(mapOutput);
console.log(filterOutput);
console.log(reduceOuput);

// Q2. Output prediction — map() return value
const nums2 = [1, 2, 3];
const result2 = nums2.map((n) => {
  n * 2;
});
console.log(result2);
// What is the output? Why? What single change would make the callback return the doubled values?
// output: [undefined, undefined, undefined];
// because when we use curly braces in an arrow function then we must explicilty use return to return the values
// the change is simply use return keyword in the callback function
const doubled = nums.map((n) => {
  return n * 2;
});
console.log(doubled);

// Q3. Output prediction — filter() truthiness
const values = [0, 1, "", "hello", null, undefined, false, true];
const result3 = values.filter(Boolean);
console.log(result3);
// Write the exact resulting array. Explain why some values are removed.
// output: [1, "hello", true]
// filter() runs the callback function and return only truthy values. some example of truthy values in js are true,"string", 3.

// Q4. Output prediction — reduce() without an initial value
const nums = [10, 20, 30];

const result4 = nums.reduce((acc, curr) => {
  console.log("acc:", acc, "curr:", curr);
  return acc + curr;
});

console.log("result:", result4);
// Predict every line of output. Explain why the callback doesn't execute for the first element.
// output: acc: 10, curr: 20
// acc: 30, curr:30
// result: 60
// for accumulator if we provide an initial value and it starts from there and if we do not provide the initial value it considers
// the first value of arr as a initial value and starts execution from second.

// Q5. Find the bug — reduce()
const prices = [100, 200, 300];

const total = prices.reduce((acc, price) => {
  acc + price;
}, 0);

console.log(total);
// What does this print, and why? Identify the missing behavior in the callback.
// output: undefiend
// because we are accumulating the prices correctly but in the end we are not returning the result
// in the end we simply have to return the acc so that total can receive it correctly
const newTotal = prices.reduce((acc, price) => {
  acc = acc + price;
  return acc;
}, 0);
console.log(newTotal);

// Q6. Practical — chain filter() and map()
// Given:
const users6 = [
  { name: "Amit", age: 17 },
  { name: "Sara", age: 25 },
  { name: "John", age: 16 },
  { name: "Priya", age: 30 },
];
// Use filter() and map() to produce:
// ["Sara", "Priya"]
// Only users aged 18 or above should be included. Do it in a single chained expression.
const userss = users6.filter((e) => e.age >= 18).map((e) => e.name);
console.log(userss);

// Q7. Practical — reduce() frequency counter
// Given:
const fruits = ["apple", "banana", "apple", "orange", "banana", "apple"];
// Use reduce() to produce this object:
// {
//     apple: 3,
//     banana: 2,
//     orange: 1
// }
const output7 = fruits.reduce((acc, curr) => {
  if (acc[curr]) {
    acc[curr]++;
  } else {
    acc[curr] = 1;
  }
  return acc;
}, {});

console.log(output7);

// Think about the accumulator's initial value and how each iteration updates it.
// Q8. Interview gotcha — mutation
const users = [
  { name: "Alex", active: false },
  { name: "Sam", active: true },
];

const result = users.map((user) => {
  user.active = true;
  return user;
});

console.log(users[0].active);
console.log(result === users);
console.log(result[0] === users[0]);
// Predict all three outputs. Explain how the original array can be affected even though map() itself doesn't mutate the array.
// output: true
// false
// true
// map() create a new array that is why result === users is false. however it copies the reference of the emelemt rather than cloning
// objects. When I modify user.active, I mutate the existing object, which also affects the object referenced by the original
// array. That's why users[0].active is true and result[0] === users[0] is true.

// Q9. Interview gotcha — empty arrays
// Predict what happens in each case:
console.log([].map((n) => n * 2));
console.log([].filter((n) => n > 0));
console.log([].reduce((acc, n) => acc + n, 0));
// Then explain what happens if the initial value 0 is removed from the reduce() call.
// output: []
// []
// 0
// if we remove the initial value as 0 and the code with throw a typeError. without an initial value reduce() normally takes the
// first element of the arr. when the arr is empty js cannot initialize the acc, so it throws typeError.

// Q10. Practical — one array, three methods
// Given:
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
// Using array methods, produce the sum of the squares of all even numbers.
// Expected result: 220
const output10 = numbers
  .filter((e) => e % 2 === 0)
  .map((e) => e * e)
  .reduce((acc, curr) => {
    acc += curr;
    return acc;
  }, 0);
console.log(output10);

// Try solving this with a chain of filter(), map(), and reduce(). Be ready to explain what each step does.
// Answer: first using filter() i just filter out all the odd numbers from the resultant arr and then using map() i transform
// the even numbers to its squares and then using reduce() i find out and return the sum 
