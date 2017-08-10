# References

## Immutable Objects (Numbers, Floats and nil)
- `x = 4` uses an assignment operator. It creates a reference to `4` and gives `x` that reference.
- Think of ruby memory as a linear strip with a bunch of chunks. When ruby sees `x = 4`, it will find a place with `4`, create a variable `x`, and then give `x` a pointer to the bucket with `4` in it. This is called a **reference** or sometimes a **pointer**.
- If you then reassign `x`, as in `x = 5`, you will still have your `x` but it will now change the pointer that was stored in `x` and give it `5` instead.
- A more complex example:
```ruby
x = 4
y = x
x = 10
p y
```
4 <br/>
<br/>
Here, `x` finds where `4` is in memory and assigns `x` a pointer to `4`. We then a create `y` and assign it a pointer to the place where `x` is pointed to. When we say `x = 10`, we destroy the original pointer `x` was using and then change it to a place in memory that has `10`. `y` is still `4`.
- Another complex example:
```ruby
x = 4
y = x
x += 2
p y
```
4 <br/>
<br/>
We create a variable `x`, and give it a pointer to a spot in memory that holds `4`. We create `y` and assign it a pointer to the same place in memory. `x += 2` is the same as `x = x + 2` which uses an assignment operator. `x` finds a memory where `6` is, and now points to the `6`, which means `y` does not change. <br/>
<br/>
There is nothing we can do to `x` to change `y` because the numbers in memory (`Fixum`) are immutable objects (cannot be mutated). Mutable means the object can me mutated.

## Mutable Objects (Arrays, Strings, and others)
- Example of mutation:
```ruby
x = "Donatello"
y = x
x << " the TMNT"
p y
```
Donatello the Teenage Mutant Ninja Turtle <br/>
<br/>
We create `x` and it points to `"Donatello"`. `y` points to the same location. The `<<` mutates what it stored in the memory chunk unlike what is seen with `Fixnum`. It will add `" the TMNT"` to the same spot in memory where `"Donatello"` resides. Since `y` is pointed to this memory chunk, `y` is also `"Donatello the TMNT"`.
- Example of non-mutation:
```ruby
x = "Donatello"
y = x
x += " the TMNT"
p y
```
Donatello
<br/>
<br/>
We assign `x` and `y` to the place in memory with `"Donatello"`. Since `x += " the TMNT"` is the same as `x = x + " the TMNT"`, and uses an assignment operator, this will not change `"Donatello"` in the memory chunk that `y` is pointed to. `x += " the TMNT"` takes the original string, adds the other string, creates a new space in memory for `"Donatello the TMNT"`, destroy the original pointer for `x`, and assign `x` a new pointer to `"Donatello the TMNT"`.
- Another thing you can mutate in ruby is an array:
```ruby
x = []
y = x
x << "Hello"
p y
```
["Hello"]
<br/>
<br/>
We create a place in a memory chunk that is going to point to `[]`. `x` and `y` point to the memory chunk. When we shovel into `x`, we are taking the empty array and putting into it `"Hello"`. Since `y` is pointed to the same memory chunk that points to `["Hello"]`, `y` is also now `["Hello"]`. `x += ["Hello"]` won't modify `y`.
- Weird example with 2D arrays:
```ruby
x = Array.new(3, [])
x[0] << "Hello"
p x
```
["Hello", "Hello", "Hello"]
<br/>
<br/>
In the first line, ruby will create a new memory bucket that will point to an array, create a 3 element array, and although each element in the array is empty, they will all be the **same** empty array created in the first line.
- But if we want to overcome this, do this:
```ruby
x = Array.new(3) { [] }
x[0] << "Hello"
p x
```
["Hello", [], []]
<br/>
<br/>
Here, we are passing in a block with what we want each element to be by default. It will evaluate this block **EACH** time it creates the default element for the top level array. We will have three different arrays in memory.
- Examples:
```ruby
a = Array.new(3, [])
a[0] = [3]
a[0] << "hello"
a[1] << "world"
p c
# a prints out as [[3, "hello"], ["world"], ["world"]]
b = []
c = Array.new(2) { b }
b << "hello"
p d
# d prints out as [["hello"], ["hello"]]
e = Array.new(2, [])
f = Array.new(2) { e }
e[0] << "hello"
p f
# f prints out as [[["hello"], ["hello"]], [["hello"], ["hello"]]]
f[0][0] << "hello"
p f
# f NOW prints out as [[["hello", "hello"], ["hello", "hello"]], [["hello", "hello"], ["hello", "hello"]]]
g = Array.new(2) { Array.new(2) }
g[0] << "hello"
p g
# g prints out as [[nil, nil, "hello"], [nil, nil]]
h = Array.new(2, Array.new(2) )
h[0] << "hello"
p h
# h prints out as [[nil, nil, "hello"], [nil, nil, "hello"]]
```
