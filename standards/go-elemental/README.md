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
itself (`golang.org/x/…`, `google/uuid`, and the like). No frameworks. Raw drivers and plain SQL
over ORMs. A web-platform-native client. Vendor libraries are isolated in provider sub-modules
that pin their own SDKs. A module may enhance the line; go-core admits the standard
library alone.

The declared stack of the standard's reference architecture selects one provider per service;
for SQL that provider is Postgres.

## Principles

The conventions every Go Elemental repository shares, enhancing the
[architecture principles](../../principles/README.md). A member repository may enhance one
further, stating the enhancement beside its link to the principle.

- [Dependencies](principles/dependencies.md) states the dependency line applied to each
  repository tier, where vendor libraries are isolated, and how peers compose.
- [Baseline-standard ownership](principles/baseline-standards.md) states that a library takes
  an external standard as its baseline and never hardens organizational convention or policy
  into its contract.
- [Topology and naming](principles/topology-and-naming.md) states how repositories, modules,
  packages, and release tags are named, the module layout of each tier, and the composition
  root's layout.
- [Lifecycle and context ownership](principles/lifecycle-and-context.md) states the process
  lifecycle every application follows, which package owns the signal context, and the wiring
  rule.
- [Tests and documentation](principles/tests-and-docs.md) states the unit tier and the
  integration tier, the toolkit convention, and `doc.go` ownership of API documentation.
- [Releases and CI](principles/release-and-ci.md) states artifact-keyed tags, changelog
  discipline, prerelease purging, and the CI checks every repository runs.
- [DSL-driven services](principles/dsl-driven-services.md) states how a service whose
  expressive content is a language of its own is integrated, and the conventions the
  standard's authored SQL declares.

## Member repositories

By tier of the [repository topology](../../principles/repository-topology.md). Each
repository documents itself: its README states its place in the standard and the principles it
enhances, and its package documentation states its API.

| Tier | Repository | Purpose |
|------|------------|---------|
| Core SDK | [go-core](https://github.com/standards-lab/go-core) | The common primitives every Go Elemental application type uses: layered configuration, the process lifecycle, logging, and the process sequence with its integration toolkit. |
| Infrastructure libraries | [go-database](https://github.com/standards-lab/go-database) | The SQL infrastructure service: the connection pool with its configuration, lifecycle, and readiness, the database admin service, and the PostgreSQL provider as a sub-module. |
| Application SDKs | [go-web-sdk](https://github.com/standards-lab/go-web-sdk) | The SDK for Go Elemental web services: the server, routing, problem responses, paginated reads, the probes, middleware, and the integration toolkit. |
| Templates | [go-web-sdk-template](https://github.com/standards-lab/go-web-sdk-template) | Scaffolds an initial Go Elemental web service, engine-free, with the composition root as one file per layer and the integration tier in place. |
| Reference architectures | [go-web-service](https://github.com/standards-lab/go-web-service) | The holistic Go Elemental web service reference, grown in documented layers on the declared stack; versionless until its 1.0. |

Adjacent to the standard rather than a member of it,
[sqlate](https://github.com/standards-lab/sqlate) is the SQL templating library the standard's
libraries consume: authored `.sql` files made dynamic and composable, with the PostgreSQL
dialect and the conventions linter as sub-modules. Any Go project can adopt it on its own, and
its guide lives with it.

Additional infrastructure libraries, for auth, storage, observability, messaging, and AI, are
created as the reference architecture integrates each technology.

## Derived standards

A .NET re-expression, `dotnet-elemental`, is anticipated: the same goals and structure
expressed in .NET, declaring `derives: go-elemental` when it exists. A derived standard tracks
the declared stack and one provider per service; it never mirrors a provider matrix.
