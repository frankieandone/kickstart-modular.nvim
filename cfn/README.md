# $HOME/dotfilesx/cfn/README.md

This directory contains C code that is meant to be compiled into binaries
in the `./build` directory. Reference these binaries from shell scripts
to run them as autoloaded functions e.g. `hello.c` is compiled into `hello`
and can be run as `./hello` or autoloaded as hello in `$HOME/dotfilesx/fn/hello`.

Instructions to compile the C code:

```shell
cd $HOME/dotfilesx/cfn
gcc -o build/hello hello.c
touch $HOME/dotfilesx/fn/hello
```

```shell
#$HOME/dotfilesx/fn/hello
hello() {
    $HOME/dotfilesx/cfn/build/hello
}
```

Result:
You can now run `hello` from anywhere in your shell.
