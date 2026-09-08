---
key: middleware
name: Middleware
type: page
repo: go-web-sdk
---

# Middleware

The design of the middleware layer. The code and the packages' `doc.go` files are authoritative
for the API; this page records the reasoning.

## The type in web, the implementations in middleware

The middleware type is the signature the Go ecosystem already uses, a function from handler to
handler. A chain composes a set of them in argument order, the first argument seeing the
request first. Both live in `web` because the routing layer consumes them: a group's stack, a
route's wrappers, and the router's dispatch chain are all values of that type.

The implementations live in the `middleware` package. Middleware is the SDK's growth area
(CORS, a recovery handler, a request ID are all foreseeable), so the implementations get a
package to grow in without enlarging `web`; `middleware` imports `web`, never the reverse. The
split follows growth rather than topic
([topology and naming](../principles/topology-and-naming.md)).

## Middleware belongs to the transport

A transport-agnostic library does not define HTTP middleware. The request logger lives here and
writes through a standard `*slog.Logger` rather than living in a logging package and returning
an HTTP type; the same rule places every future enforcement point in this module or its
consumers. The alternative inverts the dependency direction: a worker that wants a logger would
compile `net/http` to get one. The record a request logger emits is HTTP vocabulary in any
case. The library supplies the collaborator; the transport supplies the middleware that
consumes it.

## The request logger

One record per request, at info level: method, path, status, duration, remote address. A
successful probe request logs at debug, because an orchestrator requests the probes every few
seconds forever and that heartbeat would otherwise dominate production logs; a failing probe
stays at info, since readiness flapping is exactly what an operator greps for. A panicking
handler logs its record at error with the panic value attached, then the panic continues to the
standard library's recovery. Beyond the probe carve-out the middleware does not judge status
codes: whether a 5xx was the application's own failure belongs to error mapping.

## The response-writer wrappers

Wrapping the response writer is where request loggers accumulate defects, and each wrapper in
the SDK is written against two known ones: swallowing a second header write instead of
delegating it, which hides the standard library's superfluous-header warning, and omitting the
unwrap method, which silently costs a handler flushing and hijacking. Every wrapper records
the first status, always delegates, unwraps so the standard response controller reaches
through it, and delegates the zero-copy read-from path so a handler serving files keeps it.

The SDK has two wrappers, because they answer two questions. The request logger's wrapper
needs only the status: it seeds the recorded status with 200, which covers a handler that
writes a body with no explicit header write, and intercepts the header write alone. The
[error-returning handler adapter](problems.md)'s wrapper needs to know whether a response was
committed at all, so it intercepts the body write and the read-from path as well, recording an
implicit 200 when either runs before a header write.
