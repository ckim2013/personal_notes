## Methods (aka functions)
#### Introduction
- They have sequences of steps (subroutine) that can be executed at any time.
- We can wrap steps in a method (into the method body) and tell Ruby to invoke the method once needed.
- We use a `def` to define a method and `end` to finish the method.
Anything in between `def` and `end` are the sequence of steps to follow when the method is invoked.

#### Return Values
- If we were to set a variable to equal the invocation of the method, that variable will have the value of the return value of that method.

#### Built in Methods
- Although we can define our own methods, there are native methods already built into the Ruby language that we can use.
- Regardless of where the method comes from or if return is explicitly stated or not in the method, every method has a return value!

#### Implicit Returns
- If there is no explicit `return` in the method, Ruby will choose the last line evaluated as the return value.

#### Scope
- Methods create their own scope. Variables inside of methods do not interact with variables outside those methods. Thus, methods would have no impact on variables outside of the methods.

#### Arguments
- Methods can be defined to accept arguments by setting up parameters after the method name. Parameters are variables declared upon method definition that represent the arguments passed in upon invocation.
- Normally, variables inside of methods do not reference variables outside the methods. However, we can enable a method to access information outside of the method by passing objects as arguments to the method.

#### One last conversation
- You can categorize all methods into one of two categories: There are (1) methods we use for their return values and there are (2) methods we use for their side-effects.
- An example of (1) would be when we have a variable equal to the return value of a method.
- An example of (2) would be the methods `puts`.
- We only use puts for its side-effects: we see something printed out to the terminal. You would never see something like `x = puts(“string”)` because we care about what puts does, not what it returns (which is `nil` in this case).
