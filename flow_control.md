# Flow Control

## Random Snippets
- The return value for `each`, `each_char`, and `each_index` is the receiver.
- For `if` `else` statements, the interpreter will return the last line in the method regardless if an `if` `else` statement goes through, UNLESS there is nothing after the if-else statement. However, you can return early if you explicitly say `return` inside an `if` `else` statement.
- For `while` and `until` statements, the interpreter will try to return the last line in the method. If nothing is there, it will return a `nil`. You have to explicitly say `return` inside the while statement if you want to return from within the while statement (although when will you ever need to do this??).
- The ternary operator is a nice way of doing if-else statements. <br/> Format is `<condition> ? <result if condition is true> : <result if condition is false>`
  ```ruby
  puts true ? "True is true!" : "True is not...true?"
  ```
  True is true!

## An Introduction to Procs, Lambdas and Closures in Ruby
- [Youtube video!](https://www.youtube.com/watch?v=VBC-G6hahWA)
- You can have a method without `yield` inside the method nor proc parameters. Instead, inside of the method, you can assign a variable to `Proc.new` which will see if the current scope has been passed a code block which the method will then use, REGARDLESS if you have a `&variable` in the method name.
```ruby
def method_no_yield_nor_amp_param(arr)
  prc = Proc.new { |x| x + 1 }
  arr.each do |el|
    puts prc.call(el)
  end
end
method_no_yield_nor_amp_param([1,2,3])
```
2 <br/>
3 <br/>
4 <br/>

- Ways to call procs:
  - `my_proc.call(10)`
  - `my_proc.(20)`
  - `my_proc[30]`
  - `My_proc === 40` <br/>
  Case equality operator: It gets used in `case` `when` statements!! It’s a boolean operator which asks the question, “if I have a drawer labelled a, would it make sense to put b in that drawer?” for `a === b`.
- Instead of `Proc.new`, you can just write `proc` in newer versions of Ruby.
- Lambdas are proc objects but have a few different behaviors.
  - Lambdas enforce arity. Lambdas are particular about having numbers of parameters and numbers of arguments match up. You can replace `Proc.new` with `lambda` which acts a little more like a method.
  - A `return` in a proc will try to do a return from the context of where the proc was defined, not where it is currently running.
- Closures: In ruby, a closure is like what we’ve seen already, but one that maintains references to local variables that were present and being used at the time of the definition of the code.
- A reference is kept to those variables rather than the value. The contents of variables can be changed before the proc gets a chance to be ran.
