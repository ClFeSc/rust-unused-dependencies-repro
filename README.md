# Reproduction Example for False-negatives in Unused Crate Dependency Lint in Rust/Cargo 1.100

In Rust/Cargo 1.100, cargo lints were stabilized, including [`unused_dependencies`](https://doc.rust-lang.org/stable/cargo/reference/lints.html#unused_dependencies).
The Rust flag `unused-crate-dependencies` is unused since then.
Since then, dependencies of a crate `A` that were only used by a dependency of `A` but not by `A` directly are no longer warned against.
This can be observed in a workspace with a library crate and a binary crate using that library, as included in this repo.

See also the relevant Rust and Cargo issues: <https://github.com/rust-lang/rust/issues/166151>, <https://github.com/rust-lang/cargo/issues/17768>

## Run the example

You need a containerized executable like `docker` or `podman` to run the examples.
We use `podman` in the examples; replace with `docker` when you use that instead.

We provide a `run.sh` script that runs a specific Rust/Cargo version.
Run

```shell
./run.sh podman 1.99.1
```

and

```shell
./run.sh podman 1.100
```

to compare the output of Rust/Cargo versions 1.99.1 and 1.100.

## What you will observe

### Rust/Cargo 1.99.1

The call to `cargo run binary` succeeds as it does not check for unused dependencies.

The subsequent call with `RUSTFLAGS="-Dunused-crate-dependencies"` fails, as expected:

```
   Compiling binary v0.0.0 (/workspace/binary)
error: extern crate `rand` is unused in crate `binary`
  |
  = help: remove the dependency or add `use rand as _;` to the crate root
  = note: requested on the command line with `-D unused-crate-dependencies`

error: could not compile `binary` (bin "binary") due to 1 previous error
```

### Rust/Cargo 1.100

The calls to `cargo run binary` succeed both with and without `RUSTFLAGS="-Dunused-crate-dependencies"`.

We then explicitly add `bitflags` to `binary` and run `cargo run binary` again (without `RUSTFLAGS="-Dunused-crate-dependencies"`).
This now fails as expected:

```
warning: unused dependency `bitflags`
 --> binary/Cargo.toml:6:1
  |
6 | bitflags = "2.13.2"
  | ^^^^^^^^^^^^^^^^^^^
  |
  = note: `cargo::unused_dependencies` is set to `warn` by default
help: consider removing the dependency on `bitflags`
warning: `binary` (manifest) generated 1 warning
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.12s
error: warnings are denied by `build.warnings` configuration
```
