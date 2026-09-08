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
question of ownership: the standard tier is defined by the external standard (ISO SQL, OAuth
2.0 and OIDC, OpenTelemetry's conventions), and nothing above it that is merely *ours* — a
column name, an identifier format, a naming convention — may harden into the library's
contract. A library fixes mechanisms; the consumer's schema and conventions bind where the
consumer composes it.

The rule extends to policy. A library ships no policy numbers: a default page size, a maximum
request size, a timeout the application should choose. Such a value is application policy,
and a library claiming one would put policy where no consumer can answer for it. The library
takes the value as a parameter, the application's configuration supplies it, and the
composition root hands it to each construction site, so per-resource variation is different
values at different sites.

The worked case is go-database's optimistic-concurrency guard: the mechanism — match by key
and expected version, increment in the same statement — is standard SQL and belongs to the
library; the organization's convention of naming that column `version` binds in the service's
commands and migrations, so the guarded shapes take the column name as input rather than
assuming it. The same rule holds for the libraries to come: go-auth's baseline is OAuth 2.0
and OIDC, go-observability's is OpenTelemetry, and each enables the architecture's use of the
standard without hard-coding the architecture's choices into it.
