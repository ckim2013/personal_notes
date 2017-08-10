# Recursion
## Intro
- Recursion is a function that calls itself.
- Has a base case and an inductive step.
- If you can solve something recursively, you can always solve the same thing iteratively.
- Generally, doing something iteratively is a bit more efficient than doing something recursively, albeit small.
- Some examples below:
```ruby
def upcase(str)
  return str.upcase if str.length <= 1
  str[0].upcase + upcase([str[1..-1]])
end
#
def iterative_upcase(str)
  str.chars.inject('') do |upcased_str, char|
    upcased_str << char.upcase
  end
end
#
def reverse(str)
  return str if str.length < 2
  str[-1] + reverse(str[0..-2])
end
#
def iterative_reverse(str)
  str.reverse.chars.reduce('') do |word, ch|
    word += ch
  end
end
```

## Quicksort
- For an array, each step, we need to partition the array (divide into one side that is kind of sorted and another side that is kind of sorted), knowing that at least one element goes exactly where it belongs in an array.
- Let's say we have an array `[4, 12, 3, 9, 8, 2, 7]`. We take `4` and pivot around `4`. We are going to partition the array into things that are smaller than `4` and into things that are bigger than `4`. Now the array is `[3, 2, 4, 12, 9, 8, 7]`. We know for sure the `4` is sorted and it at the location it is supposed to be in. We quicksort the left side, quicksort the right side, and append them with the pivot, `4` in the middle.
```ruby
# Ruby's sort method actually uses quicksort
def def quick_sort(arr)
  return arr if arr.length < 2
  pivot_arr = [arr.first]
  left_side = arr[1..-1].select { |el| el < arr.first }
  right_side = arr[1..-1].select { |el| el > arr.first }
  quick_sort(left_side) + pivot_arr + quick_sort(right_side)
end
```

# Stack Overflow
## Intro
- Example when stack overflow occurs:
```ruby
def factorial(n)
  n * factorial(n - 1)
end
```
- Stack overflow happens when there are so many stack frames and recursive calls that it got so deep, causing the system ran out of memory. The recursion either never stops, fails to stop, or the input size is too large.

# The Stack
## Intro
- When you run any program, there is always a stack frame that you are inside of. The idea is that as ruby pushes on context, it creates what are known as stack frames which are literally stored in the memory.
- Bottom stack frame for any ruby program is `main`. `main` is the global self. Everything runs within `main`. There are constants, local variables, `gets`, `puts`, etc and any functions defined outside of `main`.
- Let's say we are on line 20 in `main` and we call a recursive function, `reverse` on `"hello"`. What that does is it jumps into the frame of the function that we just called. We jumped into a new function `reverse`. Now we have a set of local variables inside of `reverse` and one of the local variables is the string. When there is a recursive call to find the value in an inductive step, we push on another stack with another recursive call. Once the base case is found, the string is popped off the top stack (which is also popped off from the stack frame), and returned to the stack below, and so on. 
