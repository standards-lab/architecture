---
key: go-elemental
name: Go Elemental
type: standard
architecture: elemental-architecture
status: active
---

# Go Elemental

The Go implementation of the [Elemental Architecture](../../architecture.md). Go Elemental
implements the architecture on the Go standard library, and its goal is to demonstrate what the
platform provides by itself: a complete reference architecture with the smallest deliberate
dependency surface, expressing the architecture's supply-chain purpose in its strictest form.

## The dependency line

Every Go Elemental module follows one dependency line: bottom-up, no provider in a base, kept
light. The [Dependencies](principles/dependencies.md) principle states it per tier, along with
when a capability is written in-house and when a library is sourced.

The declared stack of the standard's reference architecture selects one provider per service.

## Principles

The conventions every Go Elemental repository shares, enhancing the
[architecture principles](../../principles/README.md). A member repository may enhance one
further, stating the enhancement beside its link to the principle.

- [Dependencies](principles/dependencies.md) states the dependency line applied to each
  repository tier, when a library is sourced and where its weight is isolated, and how peers
  compose.
- [System tools](principles/system-tools.md) states the third sourcing choice, a mature system
  tool run through an adapter: the adapter as the boundary, a tool as a process run directly or
  in a container pinned by digest, the tool found and version-checked at startup, and its
  license staying with the tool.
- [Baseline-standard ownership](principles/baseline-standards.md) states that a library takes
  an external standard as its baseline and never hardens organizational convention or policy
  into its contract, and that a consumer introduces a type only when it is needed.
- [Construction and execution](principles/construction-and-execution.md) states how many
  inputs a function takes, how it takes optional ones, and when an API becomes a struct with a
  method.
- [Topology and naming](principles/topology-and-naming.md) states how repositories, modules,
  packages, and release tags are named, the module layout of each tier, and the composition
  root's layout.
- [Lifecycle and context ownership](principles/lifecycle-and-context.md) states the process
  lifecycle every web service follows, which package owns the signal context, how a value takes
  part in the lifecycle, and the wiring rule.
- [Domain package files](principles/domain-files.md) states the file each part of a domain
  package lives in, how a CLI splits a domain's API by dependency profile, and how a CLI domain's
  commands are shaped.
- [CLI applications](principles/cli-applications.md) states the conventions particular to
  a command-line tool: the composition root's layer files, a command building only the nodes it
  declares, exit codes and command words, and opt-in scenarios.
- [Timeouts and deadlines](principles/timeouts.md) states how a service bounds a request that
  moves a large body through a store: tight server timeouts with size-derived transfer
  deadlines, the store's per-try and idle bounds, and which party a timeout is charged to.
- [Times in UTC](principles/utc-times.md) states that every time a library returns is in
  `time.UTC`, the columns and read path that keep it so, log record times, how tests prove it,
  and where a caller converts.
- [Tests and documentation](principles/tests-and-docs.md) states the black-box unit tier and
  where its helpers and a composition root's fixtures live, the integration and acceptance suites
  and where each runs, the harness rules, and `doc.go` ownership of API documentation.
- [Releases and CI](principles/release-and-ci.md) states the one check every repository runs,
  currency and upgrade beside it, artifact-keyed tags, changelog discipline, and how a release
  lands.
- [DSL-driven services](principles/dsl-driven-services.md) states how a service whose
  expressive content is a language of its own is integrated, and the conventions the
  standard's authored SQL declares.
- [Database extensions](principles/database-extensions.md) states that an extension's features
  are native tier, that the image is an extension's one version source, how the application
  declares extensions and the migrator reconciles them, and the modules an extension's layers
  live in.

## Member repositories

By tier of the [repository topology](../../principles/repository-topology.md). Each
repository documents itself: its README states its place in the standard and the principles it
enhances, and its package documentation states its API.

| Tier | Repository | Purpose |
|------|------------|---------|
| Core SDK | [go-core](https://github.com/standards-lab/go-core) | The common primitives every application type uses. |
| Infrastructure libraries | [go-ai](https://github.com/standards-lab/go-ai) | The model endpoint client. |
| Infrastructure libraries | [go-database](https://github.com/standards-lab/go-database) | The SQL infrastructure library. |
| Infrastructure libraries | [go-messaging](https://github.com/standards-lab/go-messaging) | The messaging infrastructure library. |
| Infrastructure libraries | [go-observability](https://github.com/standards-lab/go-observability) | The observability infrastructure library. |
| Infrastructure libraries | [go-storage](https://github.com/standards-lab/go-storage) | The object storage infrastructure library. |
| Application SDKs | [go-web-sdk](https://github.com/standards-lab/go-web-sdk) | The SDK for web services. |
| Application SDKs | [go-cli-sdk](https://github.com/standards-lab/go-cli-sdk) | The SDK for command-line tools. |
| Templates | [go-web-sdk-template](https://github.com/standards-lab/go-web-sdk-template) | Scaffolds an initial web service. |
| Templates | [go-cli-sdk-template](https://github.com/standards-lab/go-cli-sdk-template) | Scaffolds an initial CLI. |
| Reference architectures | [go-web-service](https://github.com/standards-lab/go-web-service) | The holistic web service reference. |

Four libraries stand [adjacent](../../principles/repository-topology.md#adjacent-libraries) to
the standard rather than in it: standalone libraries any Go project can adopt on its own, each
with its guide in its own repository.

- [sqlate](https://github.com/standards-lab/sqlate): the SQL templating library.
- [blobfs](https://github.com/standards-lab/blobfs): a file tree in SQL over any object store.
- [docproc](https://github.com/standards-lab/docproc): document extraction for models.
- [docinfer](https://github.com/standards-lab/docinfer): inference over extracted documents.
