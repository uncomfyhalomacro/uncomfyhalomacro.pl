+++
title = "Crystal Programming Book"
description = "my notes on crystal lang"
date = 2023-03-19
updated = 2023-04-13
[taxonomies]
tags = ["crystal", "llvm", "ruby", "programming"]
+++

# Crystal Notes

## Crystal Programming Book

Exploring the Crystal Programming Language


## Brief History

- Crystal was created in 2011
- Manas Technology Solutions created the language (https://manas.tech)
- Authors
  - Ary Borenszweig
  - Brian Cardiff
  - Juan Wajnerman
- Has over 500 Contributors and growing
- Production Ready
- Source code is found at https://github.com/crystal-lang/crystal


## Features

- Static Typing
- Ruby-esque syntax
- Compiles into machine code
- Leverages LLVM
- Expressive as Ruby
- Concurrency
- Low-level; can call C libraries or assembly
- Project Manager called Shards
- Multi-dispatch like Julia (There maybe some differences that I don't know)

The book was written when Crystal was at version 1.2.2, this note was written
at version 1.7.3.


Although the language is much inspired by Ruby, it's definitely a new language.


## Fast

Crystal is fast using **ahead-of-time compilation**. 

Crystal's compiler is **built upon LLVM**.


# Crystal's Code and Syntax

## Sample code

```crystal
def get_name
  print "What's your name? "
  read_line
end

puts "Hello, " + get_name + "!"
```

## Sample code (continued)

Running crystal is as easy by invoking either `run` to run it directly, or `build` to build it as a binary.

```
$ crystal run hello_name.cr
What's your name? Soc
Hello, Soc!

$ crystal build hello_name.cr

$ ./hello_name
What's your name? Soc
Hello, Soc!
```

# Values and expressions

## Primitive data types

- Integers
- Booleans
- Floats

## Variable assignment

```crystal
score = 38
distance = 104
score = 41

p score

# Multi assignments
emma, josh = 16, 19
p josh
p emma

# Swap the values
josh, emma = emma, josh
p josh
p emma
```

## Variable assignments (continued)

```crystal
# Constants are declared with uppercase letters
# They usually are in all caps.
LARGE_CONSTANT = 1000
PI = 3.14

# Constants can't be reassigned
# This line of code below will errors
# with "Error: can't reassign to constant"
LARGE_CONSTANT += 1
```

## Operators

- `+` addition
- `-` subtraction
- `*` multiplication
- `/` division
- `//` floor division
- `%` remainder integer division
- `num.ceil` ceiling function
- `num.floor` floor function
- `num.round` round to the nearest integer
- `num.abs` absolute value


### Other types not mentioned

- `BigInt` arbitrarily large integer
- `BigFloat` arbitrarily large floating point numbers
- `BigDecimal` precise arbitrarily numbers in base 10. _Useful for currencies_
- `BigRational` expresses numbers as a numerator and denominator


### Primitive constants

- `True`
- `False`
- `Nil`

### Strings and chars

Strings are surrounded by double quotes (") and chars are surrounded by single quotes (')

```crystal
iamstring = "Hello Crystal!"
iamchar = 'X'
iwillerror = 'xd'  # This will error since it's not double quoted.
kana = 'あ'   # Crystal accepts valid unicode.
```

> Strings in crystal are immutable after they are created

### Strings and chars (continued)

String methods or operations you can do with crystal are listed in pp. 46 of the book.

Examples:

- `str.size` the number of characters of a string
- `str.starts_with?(str)`, `str.ends_with?(str)`, `str.includes?(str)`, and `str.in?(str)`
- `str.split`

Most of these methods are commonly found in dynamic high-level langauges, *although of a different name*, e.g. Julia

### Ranges

Crystal also has a very useful feature - operators for data type `Range`.

```crystal
1..5         # => 1, 2, 3, 4, and 5. 
1...5        # => 1, 2, 3, and 4. 
1.0...4.0    # => Includes 3.9 and 3.999999, but not 4.
'a'..'z'     # => All the letters of the alphabet "aa".."zz"   # => All combinations of two letters 
```

> Omitting the starts and ends gives you an open-ended range, even the idea of a pseudo-_infinite_ range with just `..`.

#### Range operators

There are some range operators: 
- `range.includes?`, `range.covers?`, and `value.in? range`
- `range.each` - useful for do-end blocks
- `range.sample` - picks a random number on the interval
- `range.sum` - gets the sum of the range of values (or chars*, probably)

### Enums and Symbols

```crystal
# Enum
enum UserKind
  Guest
  Regular
  Admin
end

# Symbol
user_kind = :regular
```

> Tip: Comparing symbols is more efficient than comparing strings.


# Control Flow and Conditionals (TODO)


## `if` and `unless`

Truthy values are those that are not `nil` nor `false`.

```crystal
if guess == secret_number
  puts "You guessed it correctly!"
else
  puts "Sorry, the number was #{secret_number}."
end
```

```crystal
unless guess.in? 1..5
  puts "Please input a number between 1 and 5."
end
```