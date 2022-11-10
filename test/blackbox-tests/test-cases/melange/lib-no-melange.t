Test what happens when melange.emit stanza depends on non-Melange libraries

  $ cat > dune-project <<EOF
  > (lang dune 3.6)
  > (using melange 0.1)
  > EOF

  $ cat > dune <<EOF
  > (melange.emit
  >  (target output)
  >  (libraries foo)
  >  (module_system commonjs))
  > EOF

  $ cat > main.ml <<EOF
  > let t = Foo_Bar.t
  > EOF

  $ mkdir lib

  $ cat > lib/dune <<EOF
  > (library
  >  (name foo)
  >  (wrapped false))
  > EOF

  $ cat > lib/Foo_Bar.ml <<EOF
  > let t = "Hello World"
  > EOF

  $ dune build output/melange__Main.js
  File "dune", line 3, characters 12-15:
  3 |  (libraries foo)
                  ^^^
  Error: The library "foo" was added as a dependency of a melange.emit stanza,
  but this library is not compatible with melange. To fix this, add (modes
  melange) to the library stanza.
  [1]

Now we check a similar error but for executables

  $ cat > dune <<EOF
  > (executable
  >  (name main)
  >  (libraries foo)
  >  (modes native byte_complete))
  > EOF

  $ cat > lib/dune <<EOF
  > (library
  >  (name foo)
  >  (modes melange)
  >  (wrapped false))
  > EOF

  $ dune build ./main.exe
  File "main.ml", line 1, characters 8-17:
  1 | let t = Foo_Bar.t
              ^^^^^^^^^
  Error: Unbound module Foo_Bar
  [1]
