---
key: tiers
name: Service tiers in SQL
type: page
repo: go-database
---

# Service tiers in SQL

How the library applies the organizational [service tiers](../../../principles/service-tiers.md)
principle to SQL: the two tiers it offers, and how native use is confined in a consumer.

## The two tiers

The **standard tier** is exactly the technology's common standard, ISO/IEC 9075 SQL. The
`database` package is that tier: the wrapper, the configuration block, the sentinels, and the
`Dialect` interface. It stays compliant with the standard and does not grow past it; a feature
beyond the standard is native, however many engines share it.

The **native tier** is the engine's own API: the wrapper returns the underlying pool, which a
consumer drives through the driver directly. The library never asks a consumer to forgo an
engine's features for a common interface.

## The native tier at configuration and error level

The configuration block's typed fields are the standard tier; its free-form options map is the
native tier at configuration level, passing engine-specific connection keys through to the
provider untouched.

Errors are dual-wrapped — the base sentinel wrapping the driver's error — so `errors.Is`
classifies against the sentinel while `errors.As` reaches the native error; the native detail is
never lost behind the standard classification. The standard library's no-rows value is never
mapped; it flows to the caller unchanged.

## The import boundary

Only a consumer's composition root, its binaries, and packages that declare native use import a
provider; every other package works against the standard tier and stays provider-free. The
boundary is a consumer-side rule: this library names its dependencies, never its consumers. A
lint step in the consumer allows the provider import only in the declared packages, so a port to
another engine is a list of packages rather than a search.
