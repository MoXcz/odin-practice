package pointers

import "core:fmt"
main :: proc() {
	x := 10
	ptr := &x // addres of x
	also_ptr := &ptr^ // the same as ptr
	ptr_ptr := &ptr // address of ptr, which is an adress to x
	cpy_x := ptr_ptr^^ // copy of x

	xs: [5]int = {0, 5, 10, 15, 20}
	x_ptr := &xs[2] // addres to third element of xs
	for &x in xs {
		fmt.println(&x)
	}
}

