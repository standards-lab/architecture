---
key: dependencies
name: Dependencies
type: principle
level: go-elemental
---

# Dependencies

Go Elemental's dependency line: the standard library first, and at most packages as idiomatic and
stable as the standard library itself (`golang.org/x/…`, `google/uuid`, and the like). No
frameworks. Vendor SDKs and database drivers enter only through provider sub-modules that pin
them, so importing a base module compiles no vendor code.

This line bounds dependency weight. Which packages may import a provider at all is the separate
import-boundary rule of the [service tiers](../../../principles/service-tiers.md) principle.

## The line per tier

- **Core SDK** — go-core enhances the line to the standard library alone. It is the bottom of
  the dependency graph; importing one of its packages pulls nothing beyond the standard
  library.
- **Infrastructure libraries** — a base module depends on the standard library and go-core.
  Each provider is a module of its own whose `go.mod` pins its driver, so a consumer that needs
  only the standard tier never pulls a driver.
- **Application SDKs** — the standard library and go-core. An application SDK has no providers:
  its standard tier is the technology's common standard over the transport the platform already
  provides, so there is no vendor library to isolate.
- **Templates** — go-core and the template's one application SDK, at pinned releases, and
  nothing else. A template is engine-free: no data engine declared, no provider imported; a
  generated application selects providers in its own composition root.
- **Reference architectures** — the application SDK, the infrastructure libraries it composes,
  and the providers of its declared stack, each at a pinned release. Provider imports are
  confined to the packages the import boundary declares.

## Peers compose in the application

Application SDKs and infrastructure libraries are peers on the core SDK. An application SDK
never imports an infrastructure library, neither its base module nor a provider, and an
infrastructure library never imports an application SDK's vocabulary into its contract. Their
composition happens in the application: the SDK exposes an extension point, and the
application declares the policy at its composition root. The web SDK's error writing is the
worked case: the SDK defines the error-returning handler and the writer, and the application
supplies the matchers that map the database library's error types to HTTP statuses, so a new
infrastructure library costs the SDK nothing and its errors are one more matcher. The same
direction places HTTP middleware in the transport: a transport-agnostic library supplies the
collaborator, a logger for one, and never returns an HTTP type.

## A provider is selected by construction

A consumer selects a provider in its composition root by importing it and calling its typed
constructor. There is no runtime registry, no registration call, and no import side effect;
importing a package never registers anything. Adding a provider is one new import at the
composition root and no change to the base module.

## Integration is structural where it can be

A library integrates with go-core by implementing its contracts rather than by importing more
of it than it uses. The configuration contract is imported where a module's configuration block
joins the layered load. Lifecycle integration is structural: a module's start, shutdown, and
readiness methods match the coordinator's hook signatures, and the composition root registers
them, so the module itself needs no lifecycle import. Integration is also optional per layer: a
composition-root layer with nothing that starts, stops, or reports readiness, the Elemental
Architecture's Domain Service composition among them, registers nothing and needs no lifecycle
import either.
