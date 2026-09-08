---
key: sql
name: The SQL artifact
type: index
---

# The SQL artifact

SQL is Go Elemental's first [DSL-driven service](../principles/dsl-driven-services.md), and the
standard's SQL is an authored artifact: every statement is a `.sql` file, written in a grammar
the standard defines, versioned in the repository that runs it, and reviewed as SQL. The
[sqlate library](sqlate.md) is the grammar's first host. It compiles the files, composes them,
and binds them to typed Go values, and it stands adjacent to the standard so any Go project can
adopt it.

The pages of this directory document the artifact:

- [The grammar](grammar.md) states what a `.sql` file may contain: the declaration header, the
  parameter and include syntax, and the tier declaration.
- [Statements](statements.md) states what a domain's statement is, where a domain keeps its
  statements, what a compiled statement binds to, and how the collection read is composed.
- [The pattern catalog](patterns.md) states how shared SQL is published, namespaced, and
  included, and which patterns are the library's and which are the domain's.
- [The dialect interface](dialect.md) states what the library needs from an engine and how an
  engine sub-module supplies it.
- [sqlate](sqlate.md) states what the library is, how it is laid out, and where its guide is.

## How a file's tier declares the port list

Every file declares its tier in its header. A standard file uses ISO/IEC 9075 forms only and
runs on any engine. A native file names the engine feature it uses and how another engine
expresses the same effect. The native files of a repository are its complete port list: a
search for `--| tier: native` finds every statement a port to another engine would edit. The
compiler reads the declaration, the database admin service reports it, and the conventions
linter enforces it in CI, refusing a standard file that uses a form the engine declares native.

This is the [service tiers](../../../principles/service-tiers.md) principle applied inside
authored SQL. The SQL service is schema-bound: a second engine is a port, never a switch, and
the tier declarations are what make the port a list rather than a search.

## When the artifact is verified

A statement is validated three times, each at the earliest moment its scope allows
([validation-first layering](../../../principles/validation-first.md)):

1. When the file loads, the header is parsed and the reserved delimiter is checked, so a
   malformed declaration or a stray `{{` fails before any SQL exists.
2. When the directory compiles against the pattern catalog, every include resolves and a native
   pattern is refused inside a standard statement.
3. At startup, the process prepares every statement in a domain's inventory against the live,
   migrated schema, so a renamed column fails the process before it serves a request.

## Where the artifact is applied

- The [database infrastructure library](../go-database/index.md) wraps the pool the library's
  session runs over and provides the admin service that migrates, verifies, and seeds the
  schema over the library's functions.
- The [reference web service](../go-web-service/database.md) authors every domain statement in
  this grammar and documents the port list the tier declarations produce.
- The [web service template](../go-web-sdk-template/index.md) ships engine-free; the authored
  SQL layout is a reference-architecture pattern the service documents, not template
  scaffolding.

## What the grammar does not yet do

The grammar is language independent, and sqlate hosts it in Go. Two capabilities beyond the
grammar are direction rather than convention: typing a file's fields from the migration set
instead of declaring them, and compiling a file to a dialect instead of declaring its tier.
Neither is part of the standard.
