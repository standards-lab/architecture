---
key: patterns
name: The pattern catalog
type: page
---

# The pattern catalog

A pattern is a `.sql` file that shares SQL every statement would otherwise repeat. It is
published under a namespace, and a statement includes it with `{{> namespace.name}}`. The
catalog is the set of registered sources, read and validated once where the program starts,
and every statement compiles against it.

## Who publishes patterns

- The library publishes its own patterns under the namespace `sql`: the collection read and
  its count, the filter predicates, ordering, paging, the single-row read, and the
  optimistic-concurrency guard's two halves.
- An application publishes its patterns under a namespace it chooses, from a directory of
  `.sql` files embedded in the binary. The reference service publishes its identity pattern,
  the `RETURNING` clause every command ends with, under `app`.
- An engine sub-module publishes an overlay: a file with the same name and the same parameters
  as a library pattern, respelling the one pattern the engine writes differently. An overlay
  can only respell what the source defines. PostgreSQL accepts every library pattern as
  written, so its sub-module supplies no overlay.

Two sources cannot share a namespace; where they would, one is registered under an alias. A
domain never publishes patterns: a pattern is shared SQL, the application's or the library's.

## Where the catalog is built

The composition root builds the catalog once and passes it to each domain, which compiles its
statement directory against it. The linter's configuration names the same sources, so the
linter resolves includes exactly as the runtime does.

## When a pattern is admitted

A new library pattern is admitted when at least one domain has needed it and its SQL shape is
stated. It earns a Go function only when it carries a protocol the SQL alone cannot guarantee.
The guard is the worked example: its predicate and its update clause are two patterns, and the
library's guard runner is the function that runs the guarded statement with the version the
caller read and, when no row matched, runs a version read to distinguish a missing row from a
version mismatch.

## Which patterns are the domain's

Content patterns are the domain's, never the library's. A status filter, a search predicate,
and a hierarchy query over a recursive table are authored beside the domain's statements, in
the domain's own vocabulary. The library's patterns carry protocol only: binding, paging,
ordering, the collection read, the guard. A pattern that names a domain's columns is a domain
statement, whatever it is called.
