---
key: go-elemental
name: Go Elemental
type: standard
architecture: elemental-architecture
status: active
---

# Go Elemental

The Go implementation of the
[Elemental Architecture](../../architecture.md). Go Elemental
implements the architecture on the Go standard library, and its goal is to demonstrate what the
platform provides by itself: a complete reference architecture with the smallest deliberate
dependency surface, expressing the architecture's supply-chain purpose in its strictest form.

## The dependency line

The standard library first, and at most packages as idiomatic and stable as the standard library
itself (`golang.org/x/…`, `google/uuid`, and the like). No frameworks; raw drivers and plain SQL
over ORMs; a web-platform-native client. Vendor libraries are isolated in provider sub-modules
that pin their own SDKs. A module may enhance the line; go-core admits the standard
library alone.

The declared stack of the standard's reference architecture selects one provider per service;
for SQL that provider is Postgres.

## Principles

The conventions every Go Elemental repository shares, enhancing the
[architecture principles](../../principles/README.md):

- [Dependencies](principles/dependencies.md) — the dependency line applied to each repository
  tier, and where vendor libraries are isolated.
- [Topology and naming](principles/topology-and-naming.md) — how repositories, modules,
  packages, and release tags are named, and the module layout of each tier.
- [Lifecycle and context ownership](principles/lifecycle-and-context.md) — the process
  lifecycle every application follows and which package owns the signal context.
- [Tests and documentation](principles/tests-and-docs.md) — co-located black-box tests, hermetic
  by construction, and `doc.go` ownership of API documentation.
- [Releases and CI](principles/release-and-ci.md) — artifact-keyed tags, changelog discipline,
  prerelease purging, and the CI checks every repository runs.

## Member repositories

By tier of the [repository topology](../../principles/repository-topology.md):

| Tier | Repository | Purpose |
|------|------------|---------|
| Core SDK | [go-core](go-core/index.md) | The common primitives useful across all Go Elemental application types |
| Infrastructure libraries | [go-database](go-database/index.md) | The SQL service in two tiers, with providers as sub-modules |
| Application SDKs | [go-web-sdk](go-web-sdk/index.md) | The SDK for building Go Elemental web service applications |
| Templates | [go-web-sdk-template](go-web-sdk-template/index.md) | Scaffolds an initial Go Elemental web service application |
| Reference architectures | go-web-service | A holistic Go Elemental web service reference architecture (planned) |

Additional infrastructure libraries — auth, storage, observability, messaging, AI — will be
created as the reference architecture integrates each technology.

## Derived standards

A .NET re-expression, `dotnet-minimal`, is anticipated: the same goals and structure expressed
in .NET, declaring `derives: go-elemental` when it exists. A derived standard tracks the declared
stack and one provider per service; it never mirrors a provider matrix.
