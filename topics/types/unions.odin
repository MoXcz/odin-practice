package types

import "core:fmt"

// 'U_Type' can be of any of the variants, but not two of them at the same time
// and unlike C, they cannot be casted under the same memory representation
U_Type :: union {
	f32,
	int,
	Rect,
}

// zero-initialization will not be 'nil' -> first variant
I_Type :: union #no_nil {
	f32,
	int,
	Rect,
}

Rect :: struct {
	width:  f32,
	height: f32,
}

main :: proc() {
	un: U_Type = f32(3.14)
	// no problem with this, it can be any of the types
	un = int(2)
	// 8 bytes (from either 'int' or 'Rect') + 8 bytes for the tag (keep track of
	// current variant)
	fmt.println(size_of(un))

	// switch statement similar to enums
	switch variant in un {
	case int:
	case f32:
	case Rect:
	}

	// use 'v' as an addressable (make the variant modifiable)
	#partial switch &v in un {
	case int:
	}

	// though for the case above it would be best to just 'ask'
	f32_un, ok := un.(f32) // check if 'un' is of type 'f32'
	if ok {} 	// it's false, as 'un' is currently an 'int'

	// Go also has something similar, though not with unions
	if _, ok := un.(int); ok {} 	// this is great!

	// '&' in this case makes 'val' into a pointer
	if val, ok := &un.(int); ok {
		val^ = 3 // dereference operator, not '*'!
	}

	uninit: U_Type // initialized to 'nil'
	init: I_Type // initialized to 'f32', the first variant

	// the above happens due to how the tag works, as it has an extra value:
	// 0 -> nil
	// ...
	// the '#no_nil' keyword above removes this variant
}

