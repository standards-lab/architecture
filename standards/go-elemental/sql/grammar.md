---
key: grammar
name: The grammar
type: page
---

# The grammar

A `.sql` file is a header of declarations followed by a body. The library reads the header,
and the engine receives the body alone. The grammar is small enough that the body needs no
lexer: one reserved delimiter marks every construct the library interprets. This page states
each construct; the [sqlate concepts guide](https://github.com/standards-lab/sqlate/blob/main/docs/concepts.md)
shows each one by example.

## The declaration header

A header line is `--| key: value`. The header is the leading run of blank lines, plain `--`
comment lines, and declaration lines, and it ends at the first line that is none of those. A
plain comment in the header is prose and is skipped.

| Declaration | What it declares |
|-------------|------------------|
| `tier: standard` or `tier: native` | The file's tier. Required on every statement and pattern file. |
| `native: <engine>, <feature>. Ports: <how other engines express it>` | The engine feature a native file uses and its port. Required when the tier is native. |
| `transaction: required` or `transaction: none` | Whether the statement refuses to run outside a transaction, or, in a migration, whether it runs outside one. |
| `key: <column>` | The identity column of a projection base, and the sort tie-breaker. |
| `field: <name> <sql type>` | One column a request may filter or sort by, with the SQL type a request value is cast to. One line per field. |

The `key` and `field` declarations make a file a projection base, the query a collection read
wraps. The field list is an allow list: a request that names any other field is rejected
before any SQL is composed, and each value is cast to its field's declared type before it
reaches the engine.

## Parameters

| Form | What the library renders |
|------|--------------------------|
| `{{name}}` | The engine's placeholder for the argument bound by that name, numbered in order of appearance. |
| `{{name:type}}` | The placeholder wrapped in `CAST(... AS type)`, so the engine parses the value as the declared type and rejects one it cannot read. |
| `{{name...}}` | One placeholder per element of a non-empty slice, so an `IN` list binds as values and never as text. The typed form `{{name...:type}}` casts each element. |

Arguments bind by name, and a name appears in the text as many times as the statement needs
it.

## Includes

`{{> namespace.name}}` includes a pattern. The library splices the pattern's body into the
statement at compile time, and the pattern's parameters become the including statement's
parameters. A pattern never includes another pattern. The namespaces and the catalog are
documented at [the pattern catalog](patterns.md).

## The reserved delimiter

`{{` means a parameter or an include wherever it appears in a body, inside string literals and
comments included. A `{{` that forms neither is a load error, and the linter reports it at the
line. The reservation is what makes injection safety structural: nothing that looks like a
parameter is ever passed through as text.

## Migrations

A migration is a `.sql` file in the `NNNN_name.up.sql` and `NNNN_name.down.sql` layout. Its
header carries only the optional `transaction: none` declaration, for DDL an engine refuses
inside a transaction; such a file contains exactly one statement.
