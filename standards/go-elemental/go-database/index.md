---
key: go-database
name: go-database
type: module
tier: infrastructure
repo: https://github.com/standards-lab/go-database
standard: go-elemental
---

# go-database

The SQL infrastructure library of [Go Elemental](../index.md): the database service in two tiers,
built as four layers. A reader who opens it sees the organization's SQL data-access conventions
and nothing else, and a consumer who depends on it pulls in exactly one service. The approach is
plain SQL over `database/sql` with a raw driver in the provider; no ORM, per the standard's
[dependency line](../principles/dependencies.md).

The repository is one base module, `github.com/standards-lab/go-database`, defining the standard
tier, with the `postgres` provider as a nested sub-module that pins its driver. The base module
depends on the standard library and go-core.

## Packages and modules

The base module's packages are the library's layers, dependencies pointing one way; see
[The layer ontology](layers.md).

- **database** — the service layer: the wrapper over a provider-constructed pool, meeting
  go-core's lifecycle contracts for startup, shutdown, and readiness; the `Dialect` interface
  providers implement; the `Session` and `Tx` seam that carries the dialect and owns commit
  classification; the configuration block that joins the layered load; and the error taxonomy —
  connectivity, the constraint classes, version mismatch — in dual-wrapped form. See
  [Service tiers in SQL](tiers.md) and [The dialect interface](dialect.md).
- **ast** — the statement layer: standard SQL as values. Expressions, predicates, and table
  references compose `Select` and `Compound` (the sealed query expressions) and the write
  statements `Insert`, `Update`, and `Delete`, each rendered through the dialect into SQL text
  and bound arguments.
- **operation** — the contract layer: CQRS-shaped constructors lowering to rendered statements.
  A `Projection` serves the list and single-row queries under a field-name contract; the
  command shapes carry the identity-returning insert and the optimistic-concurrency guarded
  update and delete.
- **exec** — the execution layer, the only layer touching `database/sql` at runtime: the query
  runners over `Session`, the command runners over `Tx`, and the mapping of driver errors and
  guard outcomes onto the service layer's taxonomy.
- **seed** — reference-data loading: a runner over the consumer's seed file system, a typed load
  function per table, one transaction per step, the decode format selected by extension.
- **postgres** — the PostgreSQL provider: constructs the pool over pgx's `database/sql` adapter
  and supplies the postgres dialect, including constraint classification and the `RETURNING`
  capability. See [Providers](providers.md).

The code and each package's `doc.go` are authoritative for the API; these pages document the
design.
