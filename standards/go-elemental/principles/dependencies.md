---
key: dependencies
name: Dependencies
type: principle
level: go-elemental
---

# Dependencies

Go Elemental's dependency line: the standard library first, and at most packages as idiomatic and
stable as the standard library itself (`golang.org/x/…`, `google/uuid`, and the like). No
frameworks. A vendor SDK, a database driver, or any other dependency whose weight or correctness
surface the rest of a module should not carry enters only through a sub-module that pins it — a
provider in an infrastructure library, a capability module in an application SDK — so importing a
base module compiles none of it.

This line bounds dependency weight. Which packages may import a provider at all is the separate
import-boundary rule of the [service tiers](../../../principles/service-tiers.md) principle.

## The line per tier

- **Core SDK** — go-core enhances the line to the standard library alone. It is the bottom of
  the dependency graph; importing one of its packages pulls nothing beyond the standard
  library.
- **Infrastructure libraries** — a base module depends on the standard library and go-core.
  Each provider is a module of its own whose `go.mod` pins its driver, so a consumer that needs
  only the standard tier never pulls a driver.
- **Application SDKs** — the base module depends on the standard library and go-core. An
  application SDK has no providers: its standard tier is the technology's common standard over
  the transport the platform already provides. It may still source a library whose correctness
  depends on a specification or a threat model; that library is pinned in a capability
  sub-module of its own, never the base module, so a consumer that does not need the capability
  compiles none of it.
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
infrastructure library costs the SDK nothing and its errors are one more matcher.

HTTP middleware composes the same way. A library with no HTTP concern supplies a collaborator,
such as a logger, and the transport's middleware uses it. A library whose concern is
HTTP-shaped, such as tracing or token verification, exposes its middleware as a
`func(http.Handler) http.Handler` built from `net/http` types alone. That type is structurally
the web SDK's `web.Middleware`, so the middleware composes into any service built on the SDK
while the library never imports the SDK. go-observability's `NewMiddleware` is the worked case.
The arrangement works because every layer builds on the standards and the standard library,
which every layer above depends on too. A lower layer plugs into a higher one through those
shared types without depending on it.

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
