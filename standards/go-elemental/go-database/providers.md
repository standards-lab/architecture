---
key: providers
name: Providers
type: page
repo: go-database
---

# Providers

A provider implements the standard the `database` package establishes, for one engine. It
constructs the connection pool over that engine's driver, supplies the engine's `Dialect`, and
passes both to the base constructor, which returns the wrapper a consumer uses. That constructor
call is the whole contract between a provider and the base. `postgres` is the first provider.

## Selected by direct typed construction

Each provider exposes a provider constant and a typed constructor. A consumer selects its
provider in its composition root with a typed switch over the constant and a direct import of
the chosen provider. There is no runtime registry, no registration call, and no import side
effect; importing a package never registers anything. Adding a provider is one new import and
one new switch case in the composition root, with no change to the base module.

## One provider per engine

A provider covers an engine wherever it runs. The `postgres` provider serves a local container
and a managed PostgreSQL service alike; the difference between them is configuration: the
connection string, the credentials, and the options keys. This is the provider/platform rule of
the [service tiers](../../../principles/service-tiers.md) principle.

## Changing the engine

SQL is a schema-bound technology: the consumer owns a schema and domain SQL written for its
engine, so changing the engine changes infrastructure, never only configuration. The schema,
migrations, seed SQL, and domain SQL are rewritten for the new engine, along with the import and
switch case in the composition root. Code written against the base module does not change.

## A provider for another engine

A provider for another engine is defined where it is owned and maintained: as a nested
sub-module of this repository, like `postgres`, or as its own library. Either way it implements
the same contract, and building it is what proves the base's provider contracts — the dialect
interface, the constructor contract, the error mapping — for more than one implementation.
