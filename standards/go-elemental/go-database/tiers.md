---
key: tiers
name: Service tiers in SQL
type: page
repo: go-database
---

# Service tiers in SQL

How the SQL service applies the organizational [service tiers](../../../principles/service-tiers.md)
principle: the two tiers it offers, and how native use is confined in a consumer.

## The two tiers

The standard tier is exactly the technology's common standard, ISO/IEC 9075 SQL. In authored
SQL it is a file that declares `tier: standard` and uses standard forms only, checked by the
linter against the engine's declared native forms ([the SQL artifact](../sql/index.md)). In
this library it is the `database` package: the wrapper, the configuration block's typed
fields, and the service sentinels.

The native tier is the engine's own API. In authored SQL it is a file that declares
`tier: native`, names the engine feature it uses, and states the port. In this library it is
the underlying pool the wrapper exposes, which a consumer drives through the driver directly,
and the configuration block's free-form options map, which passes engine-specific connection
keys through to the provider untouched. The library never asks a consumer to forgo an engine's
features for a common interface.

## How errors carry both tiers

Every error is dual-wrapped, the sentinel wrapping the driver's error, so `errors.Is`
classifies against the sentinel while `errors.As` reaches the native error. The library's own
sentinels classify its service conditions, not ready and connection failed. The errors a
statement raises, the constraint classes and the invalid-value class among them, are classified
by sqlate's dialect inside the session and are sqlate's sentinels. The standard library's
no-rows value is never mapped and flows to the caller unchanged.

## Where the import boundary is checked

Only a consumer's composition root, its binaries, and the packages that declare native use
import a provider; every other package works against the standard tier and stays
provider-free. The boundary is a consumer-side rule, since this library names its dependencies
and never its consumers. A lint step in the consumer allows the provider import only in the
declared packages, and the tier declarations list the native statements, so a port to another
engine is a list rather than a search.
