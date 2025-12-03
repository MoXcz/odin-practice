package pointers

import "core:fmt"

// note that unlike C you can differentiate between a pointer variable and the
// dereference operator.

// '^' signifies a variable that points to a memory address (to the left)
increment :: proc(num: ^int) {
	num^ += 1 // dereference (to the right)
}

safe_increment :: proc(num: ^int) {
	if num == nil do return // writing to a 'nil' pointer bad, check before good
	num^ += 1
}

main :: proc() {
	x: int = 2 // int
	p: ^int = &x // pointer to an int

	// address-of operator just like in C
	increment(&x) // 'num' is now 3

	// the 'index' of the virtual memory address (unless for some reason this code
	// is accessing memory directly)
	fmt.printf("%i\n", &x)

	uninit: ^int // initialiezed to 'nil'
	uninit^ = 2 // uh oh, segfault!
}

/* 
though as with most cases, pointers are really only useful when using structs 
of data, as they to be used in areas such as networking with accuumulations of
different values (such as headers, addresses, socket type, etc).

And it just so happens that  they have the tendency to have millions of copies
depending on the program, so using pointer to help alleviate the use of memory.

Also, unlike C, the -> is not needed for dereference (though in this case it
would be '^' wouldn't it? Or maybe '^^'?), just use the good old '.'

Also also (I know, I do know how to use prose very efficently), an 'addressable'
represents an object, that is, its memory address. So, a variable 'x' is
said to be an addressable because it can be called upon via its address.

This is where the L-value and R-value concepts come in:
- L-value: Better to just refer to them as 'addressables', they can be read/written
  to, as they can be represented as an object in memory (that's why it's 'L'-value,
  as 'assignable' things tend to be on the left.
- R-value. Conversely to an 'L'-value, an 'R'-value is typically something that
  cannot be 'assignable', that is' 'addressable', and its thus usually on the
  right (though literals can only be just on the right, so they are just R-values
  in that case)

Also also also, replacing whole 'struct's requires dereference just like with
other variable such as 'int' ('val^ = {}')
*/

