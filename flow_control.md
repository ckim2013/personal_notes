# Flow Control

## General
- The return value for `each`, `each_char`, and `each_index` is the receiver.
- For if-else statements, the interpreter will return the last line in the method regardless if an if-else statement goes through, UNLESS there is nothing after the if-else statement. However, you can return early if you explicitly say `return` inside an if-else statement.
- For while statements, the interpreter will try to return the last line in the method. If nothing is there, it will return a `nil`. You have to explicitly say `return` inside the while statement if you want to return from within the while statement (although when will this be the case??).
