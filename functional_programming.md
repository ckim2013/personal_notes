# Functional Programming & Distributed Data

## Why should we care?
- Understandable
- Parallelizable
  - Split tasks into small subtasks and run those subtasks in parallel

## What is a functional programming?
- A style of programming in which pure functions are the main unit of computation
- Think jQuery vs React
  - jQuery sequence of instructions (append, remove)
  - React components are just functions
- Possible in most languages, but easier in some

## What makes a function pure?
- No side effects
  - Ex. ajax requests, writing to db, printing, changing external state
- Same input always returns the same output

## Purity requires immutability

##  How can we do anything useful?
- Functional core, imperative shell
- Redux
  - Model state changes as pure reducers
  - Your code never mutates state
- React
  - Model UI as pure components
  - Your code never mutates DOM

## Understandable
```javascript
const x = impureThing(a, b);
const x = pureThing(a, b);
// Even though we don't see what these functions do, we can somewhat deduce better what pureThing function does
```
- Impure functions have hidden inputs and outputs
  - Hidden inputs: mutable dependencies
  - hidden outputs: side effects
- Impure functions are often coupled in invisible ways
- Pure functions require all inputs/outputs to be explicit
- Calling a pure function can never break other code
- Values that change over time are difficult to keep track of

## Example: Tiramisu recipe
```javascript
const makeTiramisu = (
  eggs, sugar1, wine, cheese, cream, fingers, espresso, sugar2, cocoa
) => {
  dissolve(sugar2, espresso);
  const mixture = whisk(eggs);
  beat(mixture, sugar1, wine);
  whisk(mixture);
  // etc... this is not pure
}
```
```javascript
const makeTiramisu = (
  eggs, sugar1, wine, cheese, cream, fingers, espresso, sugar2, cocoa
) => {
  const beatEggs = beat(eggs);
  const mixture = beat(beatEggs, sugar1, wine);
  const whisked = whisk(mixture);
  // etc... this is pure and easier to read
}
```

## Parallelizable
- Can't parallelize if we don't understand dependencies between steps
- Mutable values make parallelization nearly impossible

## Airbnb
- Lots of transactions
- Complex db schema
- Incomprehensible to accountants

## Apache Spark
- "fast and general engine for large-scale data processing"
- Supports Python, Java, Scala
- Resilient Distributed Dataset (RDD)
  - Like an array but distributed

## Why doesn't everybody do this?
- Historical limitations in memory
  - Functional programming does use more memory
- Parallelism only needed recently
- Entrenched in education and language design
- Doesn't always align with real world perception
- But thing's are changing!

## What next?
- Javascript
  - Brian Londsdorf
    - Oh Composable World
    - Egghead series
  - Immutable.js
    - Explanation video
  - Elm
    - Tutorial
    - Egghead series

## Appendix: Performance
- "If you want fast, start with comprehensible" - Paul Phillips

## Lazy Evaluation
- Doing work at the latest and the most minimal way possible

## Memoization
- Ex:
```javascript
import { memoize } from 'lodash';
const memMakePair = memoize(makePair);
memMakePair(1); // [1, 1]
memMakePair(1); // use cached value

const onePair = memMakePair(1);
onePair.push(2);
memMakePair(1); // [1, 1, 2]
```
