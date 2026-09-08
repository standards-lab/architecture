---
key: providers
name: Providers
type: page
repo: go-database
---

# Providers

A provider constructs the connection pool for one engine over that engine's driver and returns
the wrapper the `database` package defines. That constructor is the whole contract between a
provider and the base module: the provider composes the connection string from the finalized
configuration block, parses it eagerly so a malformed configuration is a construction error
rather than a first-query surprise, and performs no I/O. The `postgres` sub-module is the
shipped provider.

A provider supplies no dialect. The dialect is the sqlate library's
([the dialect interface](../sql/dialect.md)), implemented by the engine's sqlate sub-module,
and the composition root wraps the pool with it. The provider's only concern is the pool.

## How a consumer selects a provider

A consumer imports its provider once, in its composition root, and calls the typed
constructor. There is no runtime registry, no registration call, and no import side effect;
importing a package never registers anything. Adding a provider is one new import in the
composition root, with no change to the base module.

## How a provider covers an engine

A provider covers an engine wherever it runs. The `postgres` provider serves a local container
and a managed PostgreSQL service alike, and the difference between them is configuration: the
connection identity, the credentials, and the options keys the configuration passes through.
This is the provider-and-platform rule of the
[service tiers](../../../principles/service-tiers.md) principle.

## What changes when the engine changes

SQL is schema-bound. The consumer owns a schema and domain SQL written for its engine, so
changing the engine is a port, never a configuration change. The port rewrites the migrations
and the statements the tier declarations list ([the SQL artifact](../sql/index.md)), the
import in the composition root, and the dialect the composition root wraps the pool with. Code
written against the base module does not change.

A provider for another engine is defined where it is owned and maintained: as a nested
sub-module of this repository, like `postgres`, or as its own library. Building one is what
proves the provider contract for more than one implementation.
