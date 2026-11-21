---
key: baseline-standards
name: Baseline-standard ownership
type: principle
level: go-elemental
---

# Baseline-standard ownership

An infrastructure-enabling library that aligns with an external standard takes that standard
as its baseline and enables features for the architecture without embedding the architecture in
it. The organization's conventions are codified only in the layers the organization owns — the
services, the template, the reference — at the call sites that compose the library.

The rule sharpens the [service-tiers](../../../principles/service-tiers.md) discipline with a
question of ownership: the standard tier is defined by the external standard (ISO SQL, the HTTP
RFCs, OpenTelemetry's conventions), and nothing above it that is merely ours — a column name, an
identifier format, a naming convention — may harden into the library's contract. A library
fixes mechanisms; the consumer's schema and conventions bind where the consumer composes it.

The rule extends to policy. A library ships no policy the application must own: no default
page size and no maximum request size. Such a value is application policy, and a library
claiming one would put policy where no consumer can answer for it. The library takes the value
as a parameter, the application's configuration supplies it, and the composition root hands it
to each construction site, so per-resource variation is different values at different sites.
Where a library's configuration block defaults an operational bound, such as a timeout or a
pool size, the default is a starting point the application's configuration overrides.

An optimistic-concurrency guard shows the split. The mechanism (match by key and expected
version, advance the version in the same statement, and tell a missing row from a version
mismatch) is standard SQL and belongs to the library. The convention that names the version
column binds in the service's commands and migrations, so the guard takes the column's name from
its caller rather than assuming it. Likewise a library that parses a paginated read takes the
default and maximum page sizes from its caller, and the service's configuration supplies them.

## A type is introduced only when it is needed

A consumer uses a library's types as the library defines them, and introduces a type or a layer of
its own only when it adds something the library's lacks. A pass-through wrapper, a type whose
methods only forward to the value it holds, adds a name to learn and a layer to keep current, and
nothing else.
