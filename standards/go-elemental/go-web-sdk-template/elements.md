---
key: elements
name: The elements in the template
type: page
repo: go-web-sdk-template
---

# The elements in the template

How the template realizes the
[Elemental Architecture](../../../architecture.md)'s elements. The
architecture is defined once, at the organization level; this page maps its elements onto the
scaffolded baseline and adds nothing to the definition.

- **Application** — what a generated service is: the deployable unit, here a web service. Its
  [composition root](../../../principles/composition-root.md) is
  `internal/app`, where the `App` structure orchestrates the root composition from the
  service's build points; `cmd/server` is the entrypoint alone.
- **Application layer** — `internal/app`. It owns the process lifecycle, assembles
  infrastructure, the domain, and the reactors into a router, and runs the process — all inside
  `New` and `Run`, so the build points stay declarative.
- **Reactor** — `internal/reactors`, composed over the domain and registered on the coordinator
  alongside the transport. The baseline ships it empty; a generated service that reacts to an
  external occurrence adds a field here and constructs it in `New`.
- **Infrastructure Services** — the fields of `Infrastructure`, constructed by
  `infrastructure.New` with their lifecycles declared on the staged coordinator. The
  baseline's one field is the logger; a database pool, storage, or auth client is one more
  field with its lifecycle declaration.
- **Domain Service** — arrives with a generated service rather than the template.
  `internal/domain` composes it over `Infrastructure`; its module is what a route or a Reactor
  calls, and the baseline's empty `Domain` struct is where a generated service adds it.
- **Entity** — arrives with the domain services; the template reserves no vocabulary below it.
