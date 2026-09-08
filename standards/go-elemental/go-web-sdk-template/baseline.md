---
key: baseline
name: The baseline
type: page
repo: go-web-sdk-template
---

# The baseline

The architecture the template scaffolds, and the principles that keep it minimal.

## Architecture

A single Go module built on go-core and go-web-sdk at pinned releases. The
[composition root](../../../principles/composition-root.md) is the `internal/app` package,
laid out as one file per layer of the architecture, so the package's file list is the
architecture's layer list. `cmd/server` is the entrypoint alone, importing only `internal/app`,
per the [import direction](../principles/topology-and-naming.md) every Go Elemental
application follows.

- **The entrypoint** (`cmd/server`) owns the signal-derived root context and the exit code,
  through a testable run function: configuration load, the application's constructor, run. The
  pre-infrastructure sequence comes from go-core's [`process` package](../go-core/process.md).
  It never changes as the service grows.
- **The application layer** (`internal/app`) separates cold start from hot start. `New`
  creates the lifecycle coordinator, constructs each layer in order, assembles the router from
  the mounts and the middleware stack, mounts the probes, and declares the server as the
  coordinator's root-stage service, with no I/O. `Run` is the hot start plus shutdown,
  delegated to go-core's coordinator, and returns the process exit code. The server occupies
  the root stage, started after every infrastructure stage and drained first, so in-flight
  requests complete before the infrastructure beneath them closes.
- **The infrastructure layer** (`infrastructure.go`) builds the `Infrastructure` struct: one
  concrete field per service, constructed in dependency order, each service registering its
  stage, startup, shutdown, and readiness check on the coordinator where it is constructed.
  Construction opens nothing; connectivity belongs to a service's start hook. A field either
  exists or the build fails, so a wiring mistake surfaces at compile time, and roles sharing a
  type, such as a write pool and a read pool, are distinct fields. The baseline's one field is
  the logger.
- **The admin layer** (`admin.go`) constructs the administrative services over the
  infrastructure and owns their `/admin` mount. An admin service owns a lifecycle stage, so
  the constructor takes the coordinator. The baseline ships the layer empty and the mount
  initialized, serving on the API listener; the mount's own listener, authenticated and
  unreachable from the public API's network path, is planned work of the reference service.
- **The domain layer** (`domain.go`) constructs the domain services over the infrastructure
  and owns their `/api` mount. Domain services own no resource and never run, so the
  constructor takes no coordinator. Each handler is handed its policy at the construction
  site: the read limits from the configuration root, for one. The baseline ships the layer
  empty and the mount initialized.
- **The reactor layer** (`reactors.go`) constructs the event-driven entry points over the
  infrastructure and the domain: components that watch a source of occurrences and dispatch
  each one to a domain service call, the inbound counterpart to a route. Each reactor owns a
  transport connection and runs for the process lifetime, so it registers on the coordinator
  the same as an infrastructure service. The baseline ships it empty.
- **The mounts and the middleware stack** (`routes.go`, `middleware.go`). The routes file is
  the list of mounts, the admin group and the API group, and stays two lines as the layers
  fill in. The middleware file declares the router-level middleware, outermost first, drawing
  its dependencies from the infrastructure: the baseline's one middleware is request logging.
  Middleware that needs a domain service is domain logic and belongs on a route or a reactor.
- **The configuration root** (`internal/config`) composes the library configuration blocks,
  the log and the server, with the service's own settings: the read policy, the default and
  maximum page size handed to each handler as the web SDK's limits, and the shutdown timeout.
  It loads them through the layered files under one environment prefix. Its `configtest`
  package builds the hermetically valid configuration the suites use, the single place a
  subsystem's new required field is set once.

The readiness probe reads the lifecycle coordinator and every service's named check, queried
fresh on every request: not ready until startup completes, not ready again once draining
begins, and a service the coordinator gains after the probe first mounts still appears on the
next one.

Routes and reactors are the two ways a domain service enters the running process: a route is
driven by a caller, a reactor by an occurrence the process receives or discovers. Both take the
domain layer; neither is a domain service itself.

## Principles

- **Minimal and stable.** The template scaffolds the initial baseline architecture rather than
  a framework to track. Service integrations stay out: infrastructure libraries define them,
  and the reference architecture documents how one is integrated. What the template owns is the
  composition pattern: the application type, the layer files, the `Infrastructure` struct that
  receives each new infrastructure service, and the empty admin, domain, and reactor layers a
  generated service fills in.
- **Engine-free.** The baseline declares no data engine and depends on no provider. A generated
  service selects its providers in its own composition root, and that root, never the template,
  is where a provider is imported. Database infrastructure, the pool, the admin service, and
  the authored SQL layout, is a reference-architecture pattern the
  [reference service](../go-web-service/database.md) documents, never template scaffolding.
- **Generatable.** Generation copies the module and rewrites its path. Everything in the subtree
  must survive that rewrite: the module path is the only identity, and the copy is a running
  service from the first build.
- **Distributed as a module.** The template is a real, versioned module resolved through the
  public Go proxy, so generation works anywhere Go does, with no dependency on a hosting
  platform's template feature and symmetric with the scaffolding tools of other ecosystems.
