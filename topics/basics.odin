package topics

import "core:fmt"

sum :: proc(x: int, y: int) -> int {
	return x + y
}

main :: proc() {
	xs: [10]int // fixed-size arrays
	ls := [3]int{1, 2, 3} // initiazlied array

	// call procedures with arguments
	result := sum(2, 2)

	// equivalent
	if result == 4 do sum(result, 2)
	if result == 4 {sum(result, 2)}

	// more Go goodness (though I do like the 'while' keyword)
	for {
		fmt.println("Infinite loop")
		break
	}

	for i in 0 ..= 10 {} 	// ranges
	for x in xs {} 	// range over an array
	#reverse for x in xs {} 	// range over an array in reverse


	// labels for loops
	outer: for {
		for i in 0 ..= 10 {
			break outer // stop the labelled outer for loop
			// continue outer; this also works
		}
	}

}

