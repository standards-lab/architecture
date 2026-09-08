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
[composition root](../../../principles/composition-root.md) is
`internal/app`, the last of four layers constructed in order: `internal/infrastructure`,
`internal/domain`, `internal/reactors`, and `internal/app` itself, whose `App` structure
assembles the service's five build points — route registration, the middleware stack, the
domain and reactor composition roots, and the infrastructure constructor — into the running
process. `cmd/server` is the entrypoint alone, importing only `internal/app`, per the
[import direction](../principles/topology-and-naming.md) every Go Elemental application follows.

- **The entrypoint** (`cmd/server`) owns the signal-derived root context and the exit code,
  through a testable run function: configuration load, `app.New`, run. The pre-infrastructure
  sequence comes from go-core's `process` package — `SignalContext` for the root context,
  `Fail` for failure reporting before a logger exists, and the exit codes the reporters
  return. It never changes as the service grows.
- **The application layer** (`internal/app`) separates cold start from hot start. `New`
  creates the lifecycle coordinator, constructs the infrastructure, the domain over it, and the
  reactors over both, assembles the router from the registered routes and the middleware stack,
  mounts the probes, and declares the server as the coordinator's root-stage service, with no
  I/O; `Run` is the hot start plus shutdown, delegated to go-core's coordinator. The server
  occupies the root stage — started after every infrastructure stage, drained first — so
  in-flight requests complete before the infrastructure beneath them closes.
- **Route registration** (`internal/app/routes.go`) declares the modules the router mounts:
  the one `/api` group, shipped initialized and empty. An application mounts its
  domain-service route groups into it, each constructor drawing its dependencies from
  `Domain` and each handler handed its policy from the config root at the construction
  site — the file is the build point, and the empty group serves no route in the baseline.
- **The middleware stack** (`internal/app/middleware.go`) declares the router-level middleware,
  outermost first, drawing its dependencies from `Infrastructure`: the baseline's one
  middleware, request logging, is a cross-cutting infrastructure concern. Middleware that needs
  a domain service is domain logic, and belongs on a route or a reactor instead.
- **The domain composition root** (`internal/domain`) composes the application's domain
  services over `Infrastructure`. Domain services own no resource and never run, so `New` takes
  no lifecycle coordinator: there is nothing to register. The baseline ships it empty; a
  generated service adds its services' constructors here.
- **The reactor composition root** (`internal/reactors`) composes the application's
  event-driven entry points: components that watch a source of occurrences and dispatch each
  one to a domain service call, the inbound counterpart to a route. Each reactor owns a
  transport connection and runs for the process lifetime, so `New` registers it on the
  coordinator, the same as an infrastructure service. The baseline ships it empty.
- **The infrastructure constructor** (`internal/infrastructure`) builds the `Infrastructure`
  struct: one concrete field per service, constructed in dependency order, each service with a
  lifecycle declared on the coordinator where it is constructed — its stage, startup,
  shutdown, and readiness check in one `Add` call. Construction opens nothing; connectivity
  belongs to a service's Start hook. A field either exists or the build fails, so a wiring
  mistake surfaces at compile time, and roles sharing a type, such as a write pool and a read
  pool, are distinct fields. The struct stops at the composition layer: `internal/app`,
  `internal/domain`, and `internal/reactors` pass it downward as a constructor parameter, and a
  domain service's own constructor receives the primitives it needs instead, never the struct
  itself.
- **The configuration root** (`internal/config`) composes the library configuration blocks with
  the service's own settings and loads them through the layered files under one environment
  prefix. Its `configtest` package builds the hermetically valid configuration the suites use —
  the single place the tests learn what the root config requires, where a subsystem's new
  required field is set once.

The readiness probe reads the lifecycle coordinator and every service's named check, queried
fresh on every request: not ready until startup completes, not ready again once draining
begins, and a service the coordinator gains after the probe first mounts still appears on the
next one.

## Principles

- **Minimal and stable.** The template scaffolds the initial baseline architecture rather than
  a framework to track. Service integrations stay out: infrastructure libraries define them,
  and the reference architecture documents how one is integrated. What the template owns is the
  composition pattern: the App primitive, the build points, the `Infrastructure` struct that
  receives each new infrastructure service, and the empty `Domain` and `Reactors` composition
  roots a generated service fills in.
- **Engine-free.** The baseline declares no data engine and depends on no provider. A generated
  service selects its providers in its own composition root, and that root, never the template,
  is where a provider is imported.
- **Generatable.** Generation copies the module and rewrites its path. Everything in the subtree
  must survive that rewrite: the module path is the only identity, and the copy is a running
  service from the first build.
- **Distributed as a module.** The template is a real, versioned module resolved through the
  public Go proxy, so generation works anywhere Go does, with no dependency on a hosting
  platform's template feature and symmetric with the scaffolding tools of other ecosystems.
