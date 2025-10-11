package types

// note that starting to count from a number that it's not 0 will cause the
// zero-initialization to fail (due to a lack of a valid 0-value)
E_Type :: enum {
	ZERO, // 0
	ONE,
	TWO,
	FOUR = 4, // 4, the count starts from this number
	FIVE, // 5
}

// by default an enum uses an 'int', it's possible to change it
ER_type :: enum u8 {
	ZERO = 0,
	VAL  = 12,
}

main :: proc() {
	en: E_Type // zero-initiazlied -> ZERO
	en = .TWO

	// enforcement of all cases!
	switch en {
	case .ZERO:
	case .ONE:
	case .TWO:
	case .FOUR:
	case .FIVE:
	}

	// but it can be optional (though it's not useful, best to just add a 'case'
	// that does nothing
	#partial switch en {
	case .TWO:
	}
}

// In C enums are just 'int's, in Odin they are their own distinct type, so to
// compare an enum with an 'int' it's necessary to convert the enum to an 'int'
// first: int(enum) == 5

