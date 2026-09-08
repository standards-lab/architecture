---
key: sqlate
name: sqlate
type: page
repo: sqlate
---

# sqlate

[sqlate](https://github.com/standards-lab/sqlate) is SQL templating for Go: authored `.sql`
files made dynamic and composable, with a PostgreSQL dialect and a conventions linter. The
name combines SQL and template, for the composition the library adds to `.sql` files. Read
aloud it is also "escalate," for what the library does to a file's reach.

The library is adjacent to Go Elemental rather than a member of it. The standard's libraries
consume it, and it is the blueprint for how a domain-specific language gains host-language
support, but its own text names nothing of the architecture, and any Go project can adopt it
on its own. Its user guide therefore lives with the library, and this page documents its place
in the standard and links the guide for usage.

## What the library is a pattern for

SQL is the first language in the standard that needs this much support from the host, because
SQL was not designed for the composition and portability the architecture requires. Not every
DSL will need it; a language designed to compose on its own needs no host-language
manipulation. For the ones that do, sqlate is the pattern: a grammar the files are written in,
a host library that compiles and composes them, a catalog that sources patterns from several
locations under namespaces, engine sub-modules that own an engine's spellings, and a lint that
enforces the conventions.

## How the library is laid out

The base module imports only the standard library, and a sourced dependency enters only
through a sub-module. The README lists the packages, and each package's documentation states
its API:

- The root package is the session layer: the wrapper over a plain `*sql.DB`, transactions,
  the [dialect interface](dialect.md), and the error types every engine returns.
- The `query` package compiles authored statements against [the pattern catalog](patterns.md)
  and binds them to typed values: rows, projections with request directives, and guards.
- The `migrate` package versions a schema over authored SQL under the engine's lock.
- The `sqltest` package is the scripted `database/sql` driver a consumer's hermetic tests run
  over. It can prepare statements, so prepare-based verification is provable on the unit tier.
- The `postgres` sub-module is the PostgreSQL dialect and pins the driver.
- The `sqlint` sub-module is the conventions linter as a package, with the command beside it
  ([a standalone tool beside the library](../../../principles/tool-beside-library.md)).

## Where the guide is

The repository's `docs/` directory is the user guide, ordered by its README: the concepts by
example, a quick start from `go get` to a linted and unit-tested store, every feature package
by package, and a glossary. The package documentation is the reference for each exported name.
