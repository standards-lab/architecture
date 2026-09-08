---
key: go-web-sdk
name: go-web-sdk
type: module
tier: sdk
repo: https://github.com/standards-lab/go-web-sdk
standard: go-elemental
---

# go-web-sdk

The Application SDK for [Go Elemental](../index.md) web services: what every web service otherwise
hand-writes around the standard library's `net/http`, supplied once. Its standard tier is HTTP's
common standard itself, RFC 9110 for the protocol and RFC 9457 for problem responses, built
directly on the standard library's `net/http` transport. The SDK therefore has no providers and
no native tier: nothing changes on a provider swap because there is nothing to swap.

The repository is a single Go module, `github.com/standards-lab/go-web-sdk`, depending on the
standard library and go-core. The `web` package occupies the module root as one cohesive
package. `middleware` is currently the only sub-package and provides an encapsulated space for
middleware instances to be defined ([topology and naming](../principles/topology-and-naming.md)).

## Design

- [The server](server.md) — the server bootstrap: bind on the calling goroutine, serve in the
  background, integrate with the lifecycle coordinator.
- [Routing](routing.md) — groups, modules, and the router; composed once at wiring time.
- [Problem responses](problems.md) — the SDK defines no problem types; the error-to-problem
  mapping keeps status policy consumer-declared.
- [Paginated reads](reads.md) — one parse splitting paging from filters, and the success
  envelope; no storage detail, no SDK-owned policy numbers.
- [Health](health.md) — the probes report, they do not check; readiness reflects the live state
  of the process, from startup through degradation to drain.
- [Middleware](middleware.md) — why HTTP middleware is defined in this SDK, with the
  `Middleware` type in `web` and the instances in `middleware`.

The code and each package's `doc.go` are authoritative for the API; these pages document the
design.
