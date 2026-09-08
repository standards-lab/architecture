---
key: go-database
name: go-database
type: module
tier: infrastructure
repo: https://github.com/standards-lab/go-database
standard: go-elemental
---

# go-database

The SQL infrastructure library of [Go Elemental](../index.md): the connection pool with its
configuration, lifecycle, and readiness, the database admin service over the
[sqlate library](../sql/sqlate.md), and the PostgreSQL provider. A consumer who depends on it
pulls in exactly one service. Statements, sessions, transactions, and the dialect are sqlate's:
this library owns the pool the session runs over and the administration of the schema the
statements run against.

The repository is one base module, `github.com/standards-lab/go-database`, with the `postgres`
provider as a nested sub-module that pins its driver. The base module depends on the standard
library, go-core, and sqlate, per the standard's [dependency line](../principles/dependencies.md).

## The packages

The README lists the packages, and each package's `doc.go` states its API. Their places in the
architecture:

- The `database` package is the SQL infrastructure service: a lifecycle-integrated wrapper
  over a `database/sql` connection pool and the configuration block that sizes it. It meets
  go-core's lifecycle contracts as bare method values, reports live connectivity as its
  readiness, and classifies its two service conditions, not ready and connection failed, in
  dual-wrapped form. See [service tiers in SQL](tiers.md).
- The `admin` package is the database admin service: schema state, verification, correction,
  seeding, named states, and diagnostics as operations over sqlate's functions, run once at
  startup and on demand from an administrative surface. See [the admin service](admin.md).
- The `postgres` sub-module is the PostgreSQL provider: it constructs the pool over pgx's
  `database/sql` adapter and supplies no dialect. See [providers](providers.md).

## How a composition root wires the library

The composition root imports the provider once and constructs the pool from the finalized
configuration block. It wraps the pool's connection with sqlate's session over the dialect the
engine's sqlate sub-module supplies, so the session and the pool share one set of connections.
It registers the pool's start and shutdown as lifecycle hooks, and it constructs the admin
service over the pool, the session, the migrator, and the pattern catalog, registering it at
its lifecycle stage. The provider's native API stays reachable through the pool the wrapper
exposes and the options map the configuration passes through.

## What the library does not own

The library owns the operations and their policy and none of the content it administers. The
migration set, the seeder with its named sets, the pattern catalog, and the statements registry
are the consumer's, passed in at construction. The HTTP half of the admin service, a route
group over its operations, is application code; the [reference service](../go-web-service/database.md)
documents the pattern.
