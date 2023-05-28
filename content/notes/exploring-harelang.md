+++
title = "Hare Programming Tutorial: My Notes"
date = 2023-05-28
[taxonomies]
tags = ["language-hopping", "systems-language", "low-level", "harelang", "notes"]
+++

## Hare's components

- HareC, the bootstrap compiler
- Hare
  - Stdlib
  - Builder

## Tutorials

### Introduction

#### Hello World

- `main` is the _entry point_ of programs in hare. Similar to Rust.
- `use` to import modules such as `fmt`
- `!` is an error assertion operator. Discouraged to use.

code sample in the tutorial

```hare
use fmt;

export fn main() void = {
  fmt::println("Hello World!")!;
};
```

- Removing `!` causes an error since the _programmer is desired to handle this_ as
described in [Error handling](#error-handling).

#### Hare basics

##### Functions and parameters

- `functions` may accept a list of parameters by placing them
inside `()` tokens when declaring a function.
  - `greet` function here accepts `user` of type `str`.

Use `haredoc` to check **documentation** such as `io::error`. Very useful for learning
available `stdlib`.

##### Variables and COnstants

- `let` to define a non-constant variable.
- `const` to define a variable as a constant.

Constants, like most programming languages, _can't be modified_. However, you can
_re-bind_ it by creating a variable with the same name like so:

```hare
	const source = os::open("main.ha")!;
	const source = io::drain(source)!;
	const source = strings::fromutf8(source)!;
	const source = strings::split(source, "\n");
```

As seen from above, you may also want to change its type.

##### Hare's types

###### Numeric Types

- `int` ⇒ signed integer
- `uint` ⇒ unsigned integer
- `u8` ⇒ unsigned 8-bit integer
- `f32` ⇒ 32-bit floating point number

Numeric types can be _inferred_ from a suffix from the first letter of the type
along with the number of bits e.g. `i`, `u8`.

Declaring a variable with an signed integer of `10` can be done with `a = 10i`.

Other types:

- `str` is the string type.
- `struct` the struct type. Example:

```hare
c: struct { x:int, y:int };
```

Array types are invoked by putting a type after the bracket e.g. `[]str`, `[]u8`.

Declaring an array as a variable should have a definite length.

```hare
a; [4]int = [1, 2, 3, 4]
```

###### Struct and tuple types

You declare a struct with `struct`. There are two ways to create structs

- as a type with `type`

```hare
type coords = struct { x: int, y: int };
```

- as an anonymous struct type

```hare
let foo = struct {
  x: int = 20,
  y: int = 30,
};
```

Tuples are like structs but it does not have name fields. This is similar with other
languages such as [Julia](https://docs.julialang.org/en/v1/manual/functions/#Tuples)
and other languages.

```hare
let sometuple: (int, str, int) = (0, "string", 1);
```

They can be accessed by their _ordinal position_ starting from **0** like most C
and C-inspired languages. Julia and Lua are some exceptions.

###### Arrays and slices

Arrays contain a fixed number of ordered values at compile-time.
Slices store an arbitrary number of ordered values of a uniform type at runtime.

```hare

use fmt;

export fn main() void = {
	let arr: [_]int = [1, 2, 3, 4, 5];
	assert(len(arr) == 5); // len is built-in
	assert(arr[2] == 3);   // 0-indexed
	arr[2] = 8;            // assignment
	assert(arr[2] == 8);
	
	let fill: [1024]int = [1,2,3,4,5,6,7, 100...]; // fill reaminder with 100

  printvals(fill[..4]);
	printvals(fill[2..10]);
};

fn printvals(in: []int) void = {
	fmt::printfln("input: {} integers", len(in))!;
	for (let i = 0z; i < len(in); i += 1) {
		fmt::printfln("in[{}]: {}", i, in[i])!;
	};
	fmt::println()!;
};


```

Arrays must be initialized when declared. Large arrays can be too large, using
the "splat" operator `...` can let you assign all remaining values to the last
value. The last value will be repeated as the value for all the remaining values
of the array. Hence, `fill[2..10]` will have three 100s.


#### Error handling

TODO.



