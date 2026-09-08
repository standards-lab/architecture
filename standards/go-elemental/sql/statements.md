---
key: statements
name: Statements
type: page
---

# Statements

A statement is a `.sql` file that performs one operation of a domain. It differs from a
pattern in ownership and use: a pattern is shared SQL that statements include, and a statement
is a domain's own SQL, compiled into an inventory and bound to the typed value that runs it.
Every line of SQL a domain executes is a statement or a pattern a statement includes; nothing
is assembled from strings in the host language.

## Where a domain keeps its statements

Each domain keeps a `statements/` directory beside its Go source, embedded in the binary, one
file per operation. One file in the domain imports the library: it compiles the directory
against the catalog the composition root built, registers the inventory under the domain's
name with the admin service, and binds each statement to its typed value once. The domain's
operations are methods on that store, and no other file in the domain sees the library.

A statement is named for its operation, never for its SQL verb. The file, the store method,
the service method, and the route share one name, so `transfer.sql` is the transfer command
wherever it appears. A command's validation belongs to the domain's entity; existence and
uniqueness belong to the store, as the constraint violations the engine reports.

## What a compiled statement binds to

A statement is bound once, in the store's constructor, to the value that runs it. Each value
takes a session per call, so it runs against the pool or inside a transaction alike, and every
error passes through the session's error mapping.

| Value | What it runs |
|-------|--------------|
| An exec | A command that returns only the rows affected. |
| A row reader | A query scanned into a type, returning one row, every row, or an iterator over rows. |
| A projection | A projection base composed into the collection read, the count under the same filters, and the single-row read under one equality predicate. |
| A guard | A guarded command run with the version the caller read, returning the new version, and distinguishing a missing row from a version mismatch when the command changed nothing. |

An entity's struct tags are its scan and binding contract: columns match fields by name, and a
struct's fields bind as arguments by their column names. A domain writes neither scan
functions nor argument literals for its entities. A statement headed `transaction: required`
refuses to run outside a transaction.

## How the collection read is composed

A projection base declares its key and its fields ([the grammar](grammar.md)), and at request
time the library composes the collection read from its own patterns: the base as a derived
table, the filter predicates on the declared fields, the sort terms with the key appended as
the tie-breaker, and the paging clause. Request values never enter as text. Each is bound
through a cast to its field's declared type, so a value the engine cannot read as that type is
a rejected request rather than a server error. A request that names an unknown field or
operator is rejected before any SQL is composed. The composed text depends only on the
request's signature, the directives with their values removed, so the driver's
prepared-statement cache serves repeated requests.

The web SDK's [paginated reads](../go-web-sdk/reads.md) parse a request's query string into
the page, sort, and filter list the domain translates into these directives. The translation
is the application's, by the downward-dependency rule: the web SDK never imports the SQL
library.

## When statements are verified

At startup, after the schema is migrated, each domain prepares every statement in its
inventory and probes each projection's field contract against the live schema. A statement the
schema no longer satisfies, a field the base no longer outputs, or a declared type the engine
does not know fails the process with the statement named, in the domain's lifecycle stage,
before the server binds. The admin service runs the same verification on demand.
