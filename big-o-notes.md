# Big O

## Motivations
- Is algorithm A better (faster) than algorithm B and how can we say that with mathematical certainty?
- Possible factors determining the speed of an algorithm:
  - Hardware is a very important factor but not relevant to algorithms.
  - The number of steps that the algorithm does is a PRIME factor we should look at for algorithm speed.
  - Language implementation like JS vs C++ or JS (Chrome engine) VS JS (IE engine) is not relevant to algorithm.
  - Input like small vs very large argument is determined by algorithm itself so it does matter to a degree.

## RAM Model of Computation
- What constitutes a "step"? Some step constants are below (subject to change, a bit too complex, and more error-prone):
  - `+` - 1 step
  - `-` - 1.2 steps
  - `*` - 1.3 steps
  - `/` - 1.8 steps
  - `<`, `>` - 1 step
  - `<=`, `>=` - 2 steps
  - `===` - 1 step
- Model of computation allows us abstract away small and insignificant details. **SO forget about the constants!**
- In the RAM model of computation, all of the mathematical and comparison operators listed above are only one step.
- Loop: n (number of times) * number of steps in each iteration
- We also have memory access (and reassignment) and function calls. These two are considered 1 step.

## Asymptotic Analysis
- Example: `num = num1 + num2` has 4 steps.
_ Another example:
```ruby
def iter_add(num1, num2)
  num1.times { num2 = num2 + 1 }
  num2
end
```
Number of steps in `iter_add` is `3n + 1` because the number of steps depends on the first argument `num1`.
- Asymptotic means approaching a value arbitrarily close. In terms of mathematics, it describes the behavior of a line as it approaches some arbitrary limit (in this case, infinity).
- There are two major ways how this affects how we view the run time:
  - We ignore all the constants (for `3n + 1`, `3` and `1` are the constants). The constants will not affect the behavior of the line. Graphing `3n + 1` vs `3n + 10` will shift the position of the line but it will not change overall behavior of the line.
  - We really only consider the dominant term of bottleneck. In terms of `3n + 1`, `3n` is the dominant term. As the `n` gets larger, the `1` gets less significant.
- So lets look at `3n + 1` asymptoticly. Let's get rid of the constants so that you are left with `n`! If there is a step like `2710`, we reduce it to `1`. Asymptoticly, the run time for `2710` will be `1` and the run time for `3n + 1` will be `n`.
- Another way to look at `3n + 1` is to look at each term individually. We slash `3` so we are left with `n` and we reduce `1` to `1`. We then look at which one is more dominating. As `n` gets larger and larger, the `1` becomes insignificant and then we get rid of `1`, so we are still left with `n`. For `y = 2^x + x^2`, `2^x` is more dominating because as `x` gets larger, `2^x` gets way larger than `x^2`.

## The Worst Case
- Lets take a look at an example:
```ruby
def linear_search(arr, val)
  arr.each_with_index do |el, i|
    return i if el == val
  end
  -1
end
```
- What is the run time of `linear_search`? We had an iteration that was based on the size of the array. There is a best case scenario of speed (when `val` is the first element of `arr`) and a worst case scenario (when `val` is not even in the `arr` and we iterated through `arr` for nothing).
- **Big O** is the asymptotic **worst case** run time of an algorithm. For the example right above, the Big O is `n`. Since this is the worst case, now we can write out the official term `O(n)`.

## Big O Classifications (most common!)
- Fastest to slowest Big O:
  - `O(1)` - Constant: Its run time is independent of its input size. An example is basic addition which is one step.
  - `O(log n)` - Logarithmic: Log is the inverse of an exponent. This is important because if we decide to graph a log graph, it will show a line with steady nice growth. As the input size grows, the numbers of steps start growing in a logarithmic rate, getting slower and slower which is great! If at every step you are dividing the input space of say, 2, you are dealing with a log base 2 algorithm and so on. You know you are dealing with an logarithmic algorithm if at every step, the input space is being divided. A perfect example of this algorithm is binary search!
  - `O(n)` - Linear: Looking at something in a list like our `linear_search` method.
  - `O(n log n)` - Log Linear (Super Linear): Some algorithms here are merge sort and quick sort.
  - `O(n^2)` - Quadratic (subset of Polynomial functions): Examples are nested arrays. Another algorithm of this type is bubble sort that is nested twice.
  - `O(n^k)` - Polynomial: k has to be greater than or equal to 2.
  - `O(2^n)` or `O(k^n)`- Exponential: An example of this is subsets. What is important is the exponent is `n`.
  - `O(n!)` - Factorial: An example of this is permutations.

## Set Definition
-  `O(g) = { F | f does not dominate g }`
  - `F` does not dominate `g` where `g` can be things like `n^2`.
  - `n`, `2n`, `2n + 1000`, `n^2`, `2n^2`, `3n^2 + 4000` and so on would be in `O(n^2)` because they all do not dominate `n^2`.
- If an algorithm is `O(n^2)`, it is also `O(n!)` because if something does not dominate `n^2`, it does dominate `n!`. So a lot of things is `O(n^2)` and a few dominate `O(n^2)` but this is not as precise to say and we want to be as precide as possible. You want to give the closest upper bound.
- Don't ever say `O(2n^2)` = `O(n^2)`! Scalability between the two Big O are the same but we can't say the above because we are ignoring asymptotic analysis where we would remove the `2` in `2n^2`. This can be described as simplicity.
- Example: First part of a function is `O(n)` and second part is `O(n^3)`. But overall runtime of the entire function would be `O(n^3)`. The point is that the scalability of the overall algorithm is equal to the scalability of its bottleneck. This is called combination.

## Space and Time
- How much resources is our algorithm taking up relative to the size of the input, specifically how that taking up of the resources scales as the input size grows.
- XOR (`^` NOT TO BE CONFUSED WITH TO THE POWER OF AS PREVIOUSLY USED ABOVE): It only returns true if both arguments are different. If you XOR the same number into any byte representation twice, it will cancel itself out. Example being `2` and `3`. Byte representation for `2` is `010` and for `3` is `011`. If we XOR `2` into `3`, we will get some result and if we XOR `2` into it again, we will get back `3`. See this in use to solve which one element is different between two arrays here: https://vimeo.com/175565092.
