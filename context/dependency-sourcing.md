# Dependency sourcing

This note states when the organization builds a capability itself, when it sources one, and how
a sourced dependency stays within a repository's dependency line. The rule applies at every
layer. The note landed from the coordinator for a page here.

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

An industry-standard library shows these markers, in rough order of weight:

1. **It uses standard-library types at the boundary** (`http.Handler`, `context.Context`,
   `error`), so it can be removed without touching callers.
2. **It has few or no transitive dependencies.**
3. **The projects that define the ecosystem adopt it**, or the language team references it.
4. **It has a stable major version with a long tail**, and a changelog that is mostly fixes.
5. **It solves a specification, not a preference.** When its job is correctness against an
   external document, such as CORS, OIDC, or OpenTelemetry, its corner cases are the product.
   Convenience libraries for binding, rendering, or validation are preferences, and preferences
   stay in-house.

A library that clears the markers enters as a pinned `go.mod` entry, never reimplemented and
never copied into the tree. Vendoring by hand means tracking every upstream fix manually, the risk this
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
- **Sourced weight is isolated by module.** It lives in a provider module of an infrastructure
  library or a capability sub-module of an application SDK, and the base module never imports
  it.
- **Placement follows the layers.** A capability that collaborates with an infrastructure
  service lives in that service's library, over standard-library types, never in an
  application SDK.

The page would assume that `standards/go-elemental/principles/dependencies.md` keeps the
dependency line itself, and would carry the sourcing decision that line refers to.
