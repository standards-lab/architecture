---
key: admin
name: The admin service
type: page
repo: go-database
---

# The admin service

The `admin` package is the database admin service: schema state, verification, correction,
seeding, named states, and diagnostics as operations over the sqlate library's functions.
Every operation is a trigger over a library function, and startup and the administrative
surface call the same operations. The service owns the operations and their policy, such as
which set of data applies at startup, and none of the content it administers.

## What the service runs at startup

The service registers on the lifecycle coordinator at stage 1, after the pool at stage 0 and
before the domains verify their statements at stage 2. Its start runs three concerns in
sequence, kept separate because their risks differ:

1. Verify. The migration history must be the embedded set's clean head, and the seeder's
   statements must prepare against the schema. Verification is always on, cheap, and safe.
2. Apply. When verification finds pending migrations, the service applies them under the
   migrator's lock and verifies again. A state the mechanism cannot correct, a dirty row or a
   history the set does not carry, fails startup, and an operator resolves it through the
   verbs.
3. Seed. When a startup set is configured, the service applies it. The application is
   idempotent: a deployment initializes its data at its first start, and every later start
   leaves it as it is.

The service reports a clean, complete schema as its readiness, so a readiness probe that
aggregates it reflects the schema's state.

## What the verbs do

| Verb | What it does |
|------|--------------|
| Verify | Checks the migration history and the seeder's statements against the schema. |
| Status | Reports the applied migrations and the pending set. |
| Up, Down, Steps, Force | Call the migrator's verb of the same name and return the refreshed status. |
| States | Lists the seeder's declared state names. |
| Seed | Applies a named set, or the configured one, over the schema as it stands. |
| Reset | Reverts every applied migration, applies the whole set, and seeds the named state's set. |
| Catalog, Statements | Read the pattern catalog and the statements registry without I/O. |
| Diagnose | Pings the pool, reads the server's version through the dialect's versioner capability, and reports the pool's counters. |

Down, Force, and Reset are destructive. The administrative surface decides who may call them;
the service does not.

## What a named state is

A named state is a set of data a deployment or a scenario starts from, declared by the
application as data and applied idempotently. The application supplies a seeder that verifies
its statements, lists its state names, and seeds one named set. Structural reference data the
schema needs is a migration, not a set. Reset is the one transition that brings a database to a
named state from any other: an integration harness calls it to start each case from a state it
chose, and a developer task calls it to reset a local database.

## Which capability the service asserts on the dialect

The server-version read is a capability the service declares and an engine's sqlate
sub-module implements, asserted on the session's dialect when diagnostics run. A dialect
without it reports no version and nothing else changes.
