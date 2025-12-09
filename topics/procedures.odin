package topics

import "base:runtime"
import "core:fmt"
import "core:math"
import "core:os"
import rl "vendor:raylib"

// multiple return values just like in Go
calc :: proc(x: int, y: int) -> (int, int) {return x, y}

// this signals that when the proc is called, it's required to handle the results
@(require_results)
div :: proc(x: int, y: int) -> (int, bool) {
	if y == 0 do return 0, false
	return (x / y), true
}

main :: proc() {
	// default value for 'parameters'
	log :: proc(msg: string, label: string = "Info") {
		fmt.printf("%s: %s\n", label, msg)
	}
	// note that the scope of nested procs is limited to the global scope and the
	// scope of the proc, it cannot access values declared in the 'main' proc
	// unless, the variable is declared as 'static'
	@(static) str: string

	log("hi") // called with 'arguments'

	if res, ok := div(2, 3); !ok {
		log("error dividing value")
	}

	fmt.println(length([2]f32{2, 3}))

	open_and_dump_file("../game-dev/cat/level.json")
}

// explicit overloading. Contrary to C++ implicit overloading, the overloaded
// proc just 'combines' individual procs under a single signature
length :: proc {
	length_float2,
	length_float3,
}

length_float2 :: proc(v: [2]f32) -> f32 {
	return math.sqrt(v.x * v.x + v.y * v.y)
}

length_float3 :: proc(v: [3]f32) -> f32 {
	return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
}

@(init)
start :: proc "contextless" () {
	context = runtime.default_context()
	fmt.println("Program started")
}

@(init)
end :: proc "contextless" () {
	context = runtime.default_context()
	fmt.println("Program ended")
}

// https://odin-lang.org/news/read-a-file-line-by-line/#buffered-io-approach
open_and_dump_file :: proc(file_name: string) {
	f, ferr := os.open(file_name)

	if ferr != os.ERROR_NONE {
		fmt.println("could not open file")
	}

	defer os.close(f) // defer to the end of the scope, not proc as it so happens with Go

	contents, err := os.read_entire_file_from_handle_or_err(f)
	fmt.println(string(contents))
}


/*
  Note that the reason the parenthesis are need (both in Odin and in Go) is
  to remove the ambiguities that 'int, int' could create, as that would mean
  that the parser would have to guess if a function returns a single parameter
  or more than 1.
int <- is there a comma? Is there a right brace?
  It's just baggage that the compiler should not care about

  Other interesintg things about procs:
  - Parameters are immutable (just like in Zig, use pointers to 'mutate' a
    parameter
  - Return values can be named (and just like in Go it's generally very
    useless
  - Parameters with a size >48 bytes will automatically be passed as an
    immutable reference, avoiding a copy automatically (and passing pointer)
*/

