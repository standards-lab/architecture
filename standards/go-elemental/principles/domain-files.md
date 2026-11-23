---
key: domain-files
name: Domain package files
type: principle
level: go-elemental
---

# Domain package files

A Go Elemental domain package holds one [domain](../../../architecture.md#the-elements) and lays it
out as one file per role, so a reader finds each part of any domain in the same file. The Domain
Service is the package's API; the data access beneath it stays unexported.

## One file per role

- `service.go` holds the exported `Service`, the Domain Service, built by `New`, and its
  operations.
- `database.go` holds the unexported `store`, the domain's data access, and its queries.
- `storage.go` holds the store's blob protocol, for a domain whose files sit in an object store.
- `entities.go` holds the shapes the operations take and return.
- `errors.go` holds the errors the domain adds, worded in the domain's terms.

A web service's domain adds `handler.go`, its routes. A CLI's domain adds `commands.go`, which holds
the command functions, their flag structs, and the parsers for the CLI's argument syntax, and
`output.go`, which holds the writers and record layouts the commands print with. A file appears only
when the domain has that role: a domain with no object store has no `storage.go`.

A CLI command package with no `Service` or store keeps `commands.go` and `output.go` and names each other file by the concern it holds.
[cmd/docproc's
`internal/run`](https://github.com/standards-lab/docproc/tree/cmd/docproc/v0.2.2/cmd/docproc/internal/run),
with `collect.go`, `file.go`, `runner.go`, and `stat_*.go`, is an example.

## A CLI splits its API by dependency profile

A CLI may split off a second API type for each set of dependencies a group of its commands needs,
named after the file that holds it, so a command brings up only what it uses. A CLI runs one
command per process, and a command that builds a dependency it never uses fails when that
dependency is unreachable. A web service builds every dependency for the process lifetime, so it
has no reason to split. A domain may have a `Service` holding the database alone and a `Storage`,
in `storage.go`, adding the object store: commands that declare only the Service's node run with
the object store down, and the commands that move objects declare the Storage's node.

## A CLI domain's commands

- **One `Commands` call per domain.** A domain exports one `Commands` function, which returns
  its commands whether it builds one or many, so every mount in the composition root is the same
  one call.
- **Plain command functions of declared nodes.** Each command is built by a function that takes
  the graph nodes it declares, as
  [Composition terms](../../../principles/composition-terms.md#the-terms) admits for a CLI's
  command packages. The command declares them and reads their values when it runs; no handle type
  wraps a node.
- **Input checks before any build.** The argument count is checked first, and every argument and
  flag value, the domain's form rules included, is checked in the command's validation step, so
  bad input builds no dependency.
- **A state change is never silent.** A command that changes state prints one success line.
