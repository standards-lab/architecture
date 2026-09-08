---
key: dialect
name: The dialect interface
type: page
repo: sqlate
---

# The dialect interface

The dialect is what the library needs from an engine, and an engine sub-module implements it.
The interface has three members: the engine's name, the placeholder the engine renders for the
nth bind parameter, and the classification of a driver error into the library's error types.
A consumer opens its own pool with the engine's driver and wraps it with the dialect once, in
the composition root; the session carries the dialect from there, and no runner needs it at
request time.

## What the interface classifies

The error mapping is where an engine's driver errors become the library's sentinels, so a
consumer matches them with `errors.Is` without importing a provider and reaches the driver
error with `errors.As` through every wrap. A data exception, a value the engine cannot read
as the declared type, maps to the invalid-value sentinel: the engine-side half of request
validation. A constraint violation maps to a constraint error carrying the class sentinel
(unique, foreign key, check, not null), the driver error, and the violated constraint's name.
The no-rows value passes through unchanged. Every session method maps the errors it sees, and
the session exposes the mapper for errors that arise after a call returns, from scanning rows.

## Which capabilities an engine adds

Beyond the interface, an engine sub-module implements capabilities that a protocol asserts on
the dialect when it needs them:

- A locker takes a session-scoped exclusive lock by name on a pinned connection. The migration
  protocol takes it to serialize migrations across processes, and a domain takes it for a
  concurrent-starter protocol of its own. Locks are named, never numbered.
- A versioner reads the engine's version, the statement an administrative layer runs to report
  it. It is a capability rather than an interface member because every engine spells the read
  differently and the session never needs it.

## How divergence is handled

Engine divergence lives in the authored SQL, not in the dialect. A file that uses an engine's
own form declares its tier native and names the port ([the grammar](grammar.md)); a library
pattern an engine spells differently is overlaid by the engine's sub-module
([the pattern catalog](patterns.md)). The sub-module also exports the engine's native forms
to the linter, the spellings a standard-tier file must not use, so the discipline is checked
in CI.

The PostgreSQL sub-module is the shipped implementation; its package documentation states the
error classes, the lock, and the version read.
