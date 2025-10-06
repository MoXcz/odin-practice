package topics

import "core:fmt"

main :: proc() {
	// variables are zero-initialized (improvement over C!)
	number: int
	// non-initialized variable, just like in C
	non_initialized_number: int = ---
	// Go syntax goodness! (unless it comes from somewhere else...)
	initialized_number := 5
	cast_float := f32(12) // 'f32' is not a procedure

	// constants (compiled-only values)
	CONSTANT_NUMBER :: 5
	// explicit type, otherwise it's an Untyped Float, which is a way of saying
	// that the value can be 'interpreted' as any kind of float, as long as it
	// fits the type
	CONSTANT_F32: f32 : 12

	// the benefit of 'Untyped' types is that they enable the complete removal of
	// things like '0.5f', which is caused due to the default float types being
	// 'double' and not 'float'

	// though, the 'cstring' type was made to do interop shenanigans
	fmt.println(len("Not null-terminated string!"))
}

