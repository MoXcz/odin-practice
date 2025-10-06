package topics
// similarly to Go, Odin packages are compiled into a single binary based (usually)
// on some sort of directory denotation. This means that:
// > odin run .
// will compile and run the current directory into a single executable, searching
// for a single 'main' procedure to execute

import "core:fmt"

// 'proc' -> procedure. Also, sometimes called a function
// Formally, a function has not side-effects that is, they are pure and thus
// they produce a single output for every input with no external modifications.
// Thus, the word 'procedure' is used within this context to denote that those
// side-effects do occur and they are expected to happen
main :: proc() {
	fmt.println("Hellope!")
}

