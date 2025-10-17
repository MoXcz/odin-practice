package topics

// default value for 'parameters'
log :: proc(msg: string, label: string = "Info") {}
// multiple return values just like in Go
calc :: proc(x: int, y: int) -> (int, int) {return x, y}

// it's required to handle the results
@(require_results)
div :: proc(x: int, y: int) -> (int, bool) {
	if y == 0 do return 0, false
	return (x / y), true
}

main :: proc() {
	log("hi") // called with some 'arguments'
	div(2, 3) // note that without 'require_results' this is valid
}


/*
  Note that the reason the parenthesis are need (both in Odin and in Go) is
  to remove the ambiguities something like 'int, int' could create, as that would
  mean that the parser would have to guess if a function returns a single parameter
  or more than 1.
int <- is there a comma? Is there a right brace? 
  It's just baggage that the compiler should not care about
*/

