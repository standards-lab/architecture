# Dependency sourcing

Landed from the coordinator for a page here. The rule applies at every layer: when the
organization builds a capability itself, when it sources one, and how a sourced dependency stays
within a repository's dependency line.

## The rule

Hand-roll a capability that is generic to its layer and has no specification or security
surface, where the failure shows in a unit test you would think to write. Source an
industry-standard library, as a declared dependency, for a capability whose correctness depends
on a specification with known corner cases, a threat model, or cryptography, or whose importance
makes an in-house version the greater risk. Never carry a dependency for what the standard
library provides.

The test for "trivial" is not line count. A request-ID middleware fails loudly; a CORS middleware
fails by letting the wrong origin through with right-looking headers.

## What makes a library standard

In rough order of weight:

1. **Standard-library types at the boundary** (`http.Handler`, `context.Context`, `error`), so it
   can be removed without touching callers.
2. **Few or no transitive dependencies.**
3. **Adopted by the projects that define the ecosystem**, or referenced by the language team.
4. **A stable major version with a long tail**, and a changelog that is mostly fixes.
5. **It solves a specification, not a preference.** When its job is correctness against an
   external document, such as CORS, OIDC, or OpenTelemetry, its corner cases are the product.
   Convenience libraries for binding, rendering, or validation are preferences, and preferences
   stay in-house.

A library that clears the markers is a pinned `go.mod` entry, never reimplemented and never
copied into the tree. Vendoring by hand means tracking every upstream fix manually, the risk this
rule exists to avoid.

## The dependency line

A repository that admits sourced dependencies states its line explicitly beside its
architecture link: which categories it admits (specification, threat model, cryptography) and
under which markers, the way go-core states its stricter line. An import no stated line covers
is a defect.

## Obligations

- **Hand-rolled code is owned for the life of the standard.** Each release of the owning
  repository re-checks it against the language's release notes.
- **Sourced code is pinned and re-evaluated.** Each upgrade re-checks the transitive graph, and
  a dependency that grows a framework underneath it is reconsidered.
- **Sourced weight is isolated by module**: the provider in an infrastructure library, a
  capability sub-module in an application SDK. The base module never imports it.
- **Placement follows the layers**: a capability that collaborates with an infrastructure
  service lives in that service's library, over standard-library types, never in an
  application SDK.

Assumes `standards/go-elemental/principles/dependencies.md` keeps the dependency line itself;
this page would carry the sourcing decision the line refers to.
