package types

import "core:fmt"

// note that '::' denotes a compile-time computation
Rectangle :: struct {
	// padding and structs within structs are also initialized
	// 'using' keyword allows the fiels to be used within the object
	using location: Figure,
	width:          f32,
	height:         f32,
}

Figure :: struct {
	x: f32,
	y: f32,
}

// alias (no extra fields as it so happens with 'Rectangle')
Fig :: Figure

main :: proc() {
	rect := Rectangle {
		// designated initializers (non-mentioned fields are zero-initialized)
		width  = 5,
		height = 6,
	}
	// non-mentioned fields are zero-initialized in assignments as well
	rect = {
		width = 12,
		x     = 0,
	}
	// get the size of a value/type
	fmt.println(size_of(rect))

	// note that in the function signature it specifies a 'Figure', but 'rect' is
	// a 'Rectangle'. The reason this works is because
	get_x(rect)
}

get_x :: proc(e: Figure) {}

