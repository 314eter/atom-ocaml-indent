# ocaml-indent

_Use [ocp-indent] to indent your OCaml code in Atom._

[ocp-indent]: https://www.typerex.org/ocp-indent.html

## Usage

Each line is indented when a newline is inserted. Manual indenting can be done with the following commands.

| Command                  | Description                                 | Keybinding (Linux)    | Keybinding (OS X)    |
| ------------------------ | ------------------------------------------- | --------------------- | -------------------- |
| `ocaml-indent:selection` | Indent lines containing selection or cursor | <kbd>ctrl-alt-i</kbd> | <kbd>cmd-alt-i</kbd> |
| `ocaml-indent:file`      | Indent file                                 |                       |                      |

## Installation

This package requires [language-ocaml] and [ocp-indent]. For autocompletion, linting and other features,  [ocaml-merlin] is recommended.

```sh
apm install language-ocaml ocaml-merlin
opam install ocp-indent
```

[language-ocaml]: https://atom.io/packages/language-ocaml
[ocp-indent]: https://www.typerex.org/ocp-indent.html
[ocaml-merlin]: https://atom.io/packages/ocaml-merlin
