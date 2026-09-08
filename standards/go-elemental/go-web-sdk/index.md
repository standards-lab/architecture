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
standard library and go-core. The README lists the packages, and each package's `doc.go`
states its API. The `web` package occupies the module root as one cohesive package. Two
sub-packages stand beside it ([topology and naming](../principles/topology-and-naming.md)):
`middleware` holds the middleware implementations, with the type and the composer staying in
`web`, and `webtest` is the integration toolkit a service's black-box suite drives it through.

## Design

- [The server](server.md) states the server bootstrap: bind on the calling goroutine, serve in
  the background, and integrate with the lifecycle coordinator.
- [Routing](routing.md) states the groups, the modules, and the router, composed once at
  wiring time, and where an error-returning handler registers.
- [Problem responses](problems.md) states why the SDK defines no problem types, and how the
  error-returning handler adapter and the error writer map an error to a problem while status
  policy stays the consumer's.
- [Request helpers](requests.md) states the two request parses the SDK supplies: the version
  precondition and the strict body decode.
- [Paginated reads](reads.md) states one parse splitting paging from filters, the filter
  grammar, and the success envelope, with no storage detail and no SDK-owned policy numbers.
- [Health](health.md) states that the probes report and do not check, and that readiness
  reflects the live state of the process from startup through degradation to drain.
- [Middleware](middleware.md) states why HTTP middleware is defined in this SDK, with the
  type in `web` and the implementations in `middleware`.
- [The integration toolkit](webtest.md) states what `webtest` provides a black-box suite.

The code and each package's `doc.go` are authoritative for the API; these pages document the
design.
