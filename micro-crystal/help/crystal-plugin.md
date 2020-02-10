# Crystal plugin

This crystal-lang plugin is similar and based off of the go plugin available for micro.

There are a few features of this plugin that makes developing / debugging in micro using crystal really easy.

* `> crystal format` formats the file
* `> crystal [version, --version, -v]` lists the current crystal version
* `> crystal build` builds the current file and compiles into an executable
* `> crystal run` runs the current file and prints the first line of output.
* `> crystal eval` evaluates the current line (where your cursor is)

Options:
* `crystalfmt`, default: `On`
If set to `true`, `crystal format` is run on each save.

This plugin also sets the local crystal default tab size to 2 for convenience.
