---
key: elements
name: The elements in the template
type: page
repo: go-web-sdk-template
---

# The elements in the template

How the template realizes the [Elemental Architecture](../../../architecture.md)'s elements.
The architecture is defined once, at the organization level; this page maps its elements onto
the scaffolded baseline and adds nothing to the definition.

- **Application** is what a generated service is: the deployable unit, here a web service. Its
  [composition root](../../../principles/composition-root.md) is the `internal/app` package,
  and `cmd/server` is the entrypoint alone.
- **Application layer** is `internal/app`. It owns the process lifecycle, constructs each
  layer in its own file, assembles the router from the mounts, and runs the process, all
  inside its constructor and its run method, so the layer files stay declarative.
- **Reactor** is the reactor layer file, composed over the infrastructure and the domain and
  registered on the coordinator alongside the transport. The baseline ships it empty; a
  generated service that reacts to an external occurrence adds a field and constructs it
  there.
- **Infrastructure Services** are the fields of the `Infrastructure` struct, constructed in
  the infrastructure layer file with their lifecycles registered on the staged coordinator.
  The baseline's one field is the logger; a database pool, an object store, or an auth client
  is one more field with its lifecycle registration. An administrative service over an
  infrastructure service is constructed in the admin layer file and served under the `/admin`
  mount.
- **Domain Service** arrives with a generated service rather than the template. The domain
  layer file constructs it over the infrastructure and mounts its routes under `/api`; its
  module is what a route or a Reactor calls.
- **Entity** arrives with the domain services; the template reserves no vocabulary below it.
