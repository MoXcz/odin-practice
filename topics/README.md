# Odin Topics

```sh
odin run .  # compile and run the current directory
odin build. # compile the current directory

# include additinal checks (like throwing an error with unused imports)
odin run . -vet -strict-style
# treat file as a package to compile
odin run file.odin -file
```

Most programs in this repository will be run using `odin run <filename>.odin -file`.

```sh
odin run hellope.odin -file
```

> If you forget about the flag the compiler is nice enough to remind you!
