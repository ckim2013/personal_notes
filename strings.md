## Strings
#### Introductions
- Each characters in a string can be found if we know the index to ask for.
- Zero based index system is how ruby operates.
- The method slice is the same as the bracket method.
- For the slice method, you can pass it two arguments, the first being the starting index and the second being the total number of characters.
`“string”.slice(0, 3)` is NOT the same as `“string”[0..3]` but IS the same as `“string”[0...3]`. You can also use ranges with slice instead of arguments which will serve the same way as the bracket method. You can also use arguments (like 2 arguments) in brackets which will serve the same way as the slice method!
- For the `include?` and index methods, the characters in the argument have to be in the exact order as seen in the receiver or else the methods will return nil. For the delete and count methods, the characters in the argument do not have to be in the same order as seen in the receiver, although delete will delete EVERY instance of each character in the argument.
- The only things the backslash `\` escapes, are the apostrophe and the backslash itself.
- Before puts tries to write out an object, it uses `to_s` to get the string version of that object. The s in puts stands for string; puts really means put string. However, you can’t do `puts 20 “hello”`. The s in gets also stands for string.
- One way to make a multi-line string without having to worry about delimiters is to use a *here document*.
```ruby
x = <<123_ANYTHING_I_WANT_tosay
Hello world!
This is a here document! Even indents work.
123_ANYTHING_I_WANT_tosay
```

- For interpolation, you can actually put in method names within `"#{}"`. Whatever the method returns will go inside the hash-bracket.

#### Regular Expressions and String Manipulation
- A *regular expression* is essentially a search query. It is a string that describes a pattern for matching elements in other strings.

##### Substitutions
  - Example being `puts 'foobar'.sub('bar', 'foo')` which returns `'foofoo'`. The `sub` method substitutes the **FIRST** instance of the first parameter with the second parameter. `gsub` does multiple substitutions at once, example being `puts "this is a test".gsub('i', '')` returning `"ths s a test"`. `gsub` substituted all occurrences of `'i'` with an empty `''` string. BUT THIS IS ALL SIMPLE. TIME TO GET COMPLEX.
  - More complex example can be seen below. This time the regular expression matches the two characters that are anchored to the end of any lines within the string.
      - If you want to anchor to the absolute start or end of a string, use can use `\A` and `\z` respectively, wherease `^` and `$` anchor to the starts and ends of lines within a string.

  ```ruby
  x = 'This is a test'
  puts x.sub(/^../), 'Hello')
  # This puts out 'Hellois a test'
  ```
  Hellois a test

#### Iteration with a Regular Expression
  - Use the method `scan` if you want to iterate through a string and have access to each section of it separately.
  ```ruby
  'xyz'.scan(/./) {|letter| puts letter}
  ```
  This puts out each letter in the string. `scan` scans through the string looking for anything that matches the regular expression passed to it which in this case, we have supplied a regular expression `/./` that looks for a single character at a time. Each letter is fed to the block, assigned to a `letter` and printed to the screen.
  - Here is a more elaborate example of `scan`. This time we are scanning for two characters at a time.
  ```ruby
  'This is a test'.scan(/../) { |x| puts x }
  ```
  Th <br/>
  is <br/>
  i  <br/>
  s  <br/>
  a  <br/>
  te <br/>
  st <br/>

  - But we can do better by matching only letters and digits, like seen below. `\w` means "any alphanumeric character of an underscore".
  ```ruby
  'This is a test'.scan(/\w\w/) { |x| puts x }
  ```
  Th <br/>
  is <br/>
  is  <br/>
  te <br/>
  st <br/>

  - ****Basic Special Characters and Symbols Within Regular Expressions****


  | Character   | Meaning                                     |
  | ------------|:-------------------------------------------:|
  | `^`         | Anchor for the beginning of a line          |
  | `$`         | Anchor for the end of a line                |
  | `\A`        | Anchor for the start of a string            |
  | `\z`        | Anchor for the end of a string              |
  | `.`         | Any character                               |
  | `\w`        | Any letter, digit, or underscore            |
  | `\W`        | Anything that `\w` doesn't match            |
  | `\d`        | Any digit                                   |
  | `\D`        | Anything that `\d` doesn't match (non-digit)|
  | `\s`        | Whitespace (spaces, tabs, newlines, etc.)   |
  | `\S`        | Non-whitespace (any visible character)      |

  - Example below! `\d` matches any digit and the + that follows `\d` makes `\d` match as many digits in a row as possible. Without the +, the computer will print out individual numbers at a time.

  ```ruby
  'The car costs $1000 and the cat costs $10'.scan(/\d+/) do |x|
    puts x
  end
  ```
  1000 <br/>
  10 <br/>

  - ****Regular Expression Character and Sub-Expression Modifiers****


  | Modifier    | Description                                                                                  |
  | ------------|:--------------------------------------------------------------------------------------------:|
  | `*`         | Match zero or more occurrences of the preceding character, and match as many as possible     |
  | `+`         | Match one or more occurrences of the preceding character, and match as many as possible      |
  | `*?`        | Match zero or more occurrences of the preceding character, and match as ***few*** as possible|
  | `+?`        | Match one or more occurrences of the preceding character, and match as ***few*** as possible |
  | `?`         | Match either one or none of the preceding character.                                         |
  | `{x}`       | Match x occurrences of the preceding character.                                              |
  | `{x,y}`     | Match at least x occurrences and at most y occurrences.                                      |

  - *Character classes* allow you to match against a specific set of characters. One example of this can be seen below (Ex 1). `[aeiou]` means "match any of a, e, i, o, or u". You can also specify ranges of characters inside of the square brackets (Ex 2).
  ```ruby
  # Ex 1
  'This is a test'.scan(/[aeiou]/) { |x| puts x }
  ```
  i <br/>
  i <br/>
  a <br/>
  e <br/>

  ```ruby
  # Ex 2
  "This is a test".scan(/[a-m]/) { |x| puts x }
  ```
  h <br/>
  i <br/>
  i <br/>
  a <br/>
  e <br/>

#### Matching
