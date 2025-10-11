package types

import "core:fmt"
Maybe :: union($T: typeid) {
	T,
}

U_Raw :: struct #raw_union {
	number: int,
	pos:    f32,
}

main :: proc() {
	// the value is 'maybe' in there: nil or int
	time: Maybe(int)
	if val, ok := time.?; ok {} 	// if there's a value, use it
	// 'time.?' works similarly to 'time.(int)', but because there's only one
	// variant, the complier is smart enough to know that it can only be an 'int'
	// time = time.? <- this crashes
	time = 5 // unless there's a value

	// a 'raw union' removes the tag of the union (which makes Unions in Odin to
	// be 'tagged unions'
	raw: U_Raw
	// this is in essence a C Union, which means that the program does not keep
	// track of which variant the variable is currently in
	raw.number = 2
	fmt.println(raw.number)
	fmt.println(raw.pos) // interprets 'int' as an 'f32' (just like in C)

	circle := Figs {
		variant = Circ{radius = 12.0},
	}
}


// there are some alternatives to a 'mega struct' that can be achieved using
// 'struct variants', that is, having an union that keeps track of the current
// variant of a main struct with shared characteristics:
Figs :: struct {
	area:      f32,
	perimeter: f32,
	variant:   Fig_Variant,
}

Circ :: struct {
	radius: f32,
}

Rect :: struct {
	width:  f32,
	height: f32,
}


// depending on whether the current figure is a rectangle or a circle, it
// will have either radius, or a width and height
Fig_Variant :: union {
	Rect,
	Circ,
}

