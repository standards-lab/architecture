---
key: elemental-architecture
name: Elemental Architecture
type: architecture
status: active
---

# Elemental Architecture

An organizational application architecture: the compositional elements a program is built from
and the rules that bind them, independent of language. What the elements are and how they
relate is defined here; how each element is implemented emerges at its first consumer and is
documented in the repository that builds it.

The architecture's purpose is optimizing supply-chain boundaries, and a minimal, deliberate
dependency surface is one of its core principles — not a posture its standards choose
privately. The boundary works in two dimensions: it mitigates what a dependency admits into the
architecture, and it establishes the clean maintenance boundaries that keep capabilities
flexible, scalable, and maintainable for the long haul — a handful of deliberately sourced
dependencies can be held pinned and current; fifty cannot. The
[minimal-footprint principle](principles/minimal-footprint.md) states this purpose in
principle form; an implementing standard draws its own dependency line as an enhancement of
it, tightening and never loosening. A framework-heavy standard in the same language would not
be a competing implementation of Elemental — it would not implement Elemental at all.

The architecture keeps two inheritances: the separations of domain-driven design and the
query/command operation model of CQRS. It deliberately drops the vocabulary DDD accumulated
around them (aggregates, value objects, repositories, command buses), because that vocabulary
existed to keep monolithic applications coherent. In a system of many narrowly scoped services,
each application is small enough that the five elements below describe its entire design.
"Feature" was considered as a further element and rejected: every candidate feature is one
domain, a Domain Service and the Entities it composes, so the term would only relabel what the
elements already describe. Features stay informal prose.

## The elements

Top to bottom:

- **Application**: the deployable unit of a binary software project. The **application layer**
  owns the infrastructure services and the process lifecycle, assembles the transport, and runs
  the process. Its [composition root](principles/composition-root.md) is the package where the application
  assembles its dependencies; it only declares the composition, and execution belongs to the
  application layer. Application types (a web service, a CLI, a game) share this architecture;
  they differ in composition-root initialization sequence, runtime cycle, and deployment
  platform. A web service is an application whose form is a containerized public API.
- **Reactor**: an entry point driven by an occurrence from outside the application rather than a
  caller (a subscription, a poll interval, a schedule). It owns the transport connection the
  occurrence arrives on, calls a Domain Service, and runs for the process lifetime: the inbound
  counterpart to the application layer's transport, which a caller drives instead. A Reactor is
  not a Domain Service; it dispatches to one.
- **Infrastructure Services**: the process-level services an application is composed on, such as
  the logger, the database, storage, and auth. Their APIs are defined outside the application,
  and they are distinct from domain services. They follow a uniform lifecycle contract: ordered
  startup, reverse-order drain, readiness checks feeding the probes. Each is constructed and
  registered once, declaratively, in the composition root.
- **Domain Service**: the public interface the application presents over a domain. A
  **domain** is a composition of one or more Entities around a **root Entity**, the Entity the
  domain's other Entities depend on and the one whose identity the domain's records carry. An
  Entity that depends on the root and nothing else is the root's metadata. An Entity that
  depends on the root and reaches beyond the domain is where the domain connects to other
  domains and systems. The Domain Service exposes what may be done to the domain as two
  operation kinds: a **Query** is an immutable operation that reads the system's current
  state; a **Command** is a mutable operation that requests a change to it. A Domain Service
  serves one domain, and its module is the unit a route or a Reactor calls. The simplest
  domain is one root Entity alone.
- **Entity**: the elemental component. An Entity is a data structure, table-backed or not; it
  defines its intrinsic capability, and the Domain Service decides what of that capability is
  exposed.

**Events** are the architecture's single cross-system mechanism, and they are not a layer in the
element stack: an event tells a system outside the domain that a mutation committed. The
architecture defines emission only; delivery guarantees belong to the messaging system that
receives the event. This is the [service tiers](principles/service-tiers.md) pattern
applied to eventing. Events are never used inside the application: an internal cascade is a
transactional command cascade through entity operations. The same is true on the inbound side: a
Reactor consuming an event from another system is not an exception to it. The event stops being
one at the process boundary; what crosses is the occurrence that triggers a Domain Service call,
the same as any other Reactor source.

## The rules

- **An element's primitives keep the language's idiomatic terms.** The architecture invents no
  term where an idiomatic one exists. An Entity structure is composed of fields, methods, and
  helper functions; its persistence model is a table whose schema reflects the entity's
  persisted metadata, and a row is an instance of entity data. A Domain Service exposes methods
  (the idiomatic Go term for an owned operation on a type) that a web service maps to API
  endpoints. Another language describes the same components in its own idiom.
- **The domain's root Entity is the consistency boundary.** Commands are transactional and
  cascade through entity operations atomically. An operation spanning entities belongs to the
  Domain Service of the domain whose root owns the transaction, which composes the other
  entities' operations within it, its own Entities and another domain's alike.
- **Dependencies flow downward through the elements.** The application layer depends on
  everything it assembles; a Reactor depends on the infrastructure connection it owns and the
  Domain Service it calls; domain services depend on their Entity and the infrastructure services
  they use; entities depend on nothing above themselves. This is the organizational
  [downward-dependency principle](principles/downward-dependencies.md), ordered by the
  elements.
- **A proven pattern sinks to the lowest level at which it is generic.** A pattern is proven in
  application code first, then graduates: to the application SDK when it is specific to the
  application type, to the core SDK when it is generic across application types. The template
  repositories are the SDKs' proving ground by design.
- **Implementation is defined at its own level.** This page defines what the elements are and
  how they relate. How an element is realized in a language, standard, or repository is design
  at that level, proven at its first consumer.

## Principles

The architecture's principles are cataloged at [`principles/`](principles/README.md); every
standard and module beneath the architecture satisfies them, and a lower level may tighten one
and never loosen it:

- [Resolution matches purpose](principles/resolution.md) — interface with a technology at the
  resolution the purpose requires.
- [Dependencies flow downward only](principles/downward-dependencies.md) — a repository depends
  on lower tiers and names its dependencies, never its dependents.
- [A minimal, deliberate dependency footprint](principles/minimal-footprint.md) — every
  dependency is deliberate, and each standard draws its own line.
- [Service tiers](principles/service-tiers.md) — the standard and native tiers of every
  infrastructure service, and the swap-cost classes.
- [Independent, artifact-keyed releases](principles/independent-releases.md) — every releasable
  artifact has its own tag namespace.
- [Repository topology](principles/repository-topology.md) — the five repository tiers and the
  dependency rule between them.
- [The composition root](principles/composition-root.md) — the one package where an application
  assembles and declares its composition.

## A note on "Domain Service"

"Domain Service" deliberately narrows a term domain-driven design uses more broadly: here it is
always the public interface over one domain, rooted in one Entity. Engineers onboarding from a
DDD background should read the definition above rather than assuming the inherited, broader
one.

## Implementing standards

A standard declares the architecture it implements in its definition.
[Go Elemental](standards/go-elemental/README.md) is the first implementing standard; its
[web service template](standards/go-elemental/go-web-sdk-template/index.md) is the first
code expression of the elements.
