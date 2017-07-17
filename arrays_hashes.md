# Arrays

## General
- You can’t use `slice` for reassignment. Just use the bracket method `[] =`. You can do reassignment with the bracket-argument method and bracket-range method.
- Assigning a new element with an index not available in an array will add the new element and fill the rest of the indices with `nil`.
- The methods `take` and `drop` have arguments representing amount of elements, **NOT** index.
- The method `delete` **does modify** arrays but it **does not modify** strings! `delete` for strings returns the newly modified string but `delete` for arrays returns the element being deleted!
- The methods `max` and `min` work for strings of numbers in arrays!
- `puts` calls `puts` on every single object in the array. So if the array is empty, nothing is put onto the screen.
- If you pass a numeric parameter to first or last, you’ll get that number of items from the start or the end of the array
```ruby
x = [1,2,3]
puts x.first(2).join("-")
```
1-2

- To find the difference between two arrays, subtract them!
```ruby
x = [1,2,3,4, true, false, true]
y = [4,3,2, true]
p x - y
```
[1, false]

# Hashes

## General
- Both arrays and hashes are used to store collections of objects.
- Hashes do not keep track of insertion orders unlike arrays. Instead, we look up items using key-value pairs.
- Any ruby object can be a valid key or value in a hash.
- When you set up a counter hash with an empty array as a default, shoveling values regardless of which key you use modifies the counter default array.
- Hashes do have order even though you use them when you don’t really care about order.
