---
key: problems
name: Problem responses
type: page
repo: go-web-sdk
---

# Problem responses

The design of the RFC 9457 problem writers. The code and `doc.go` are authoritative for the API;
this page records the reasoning.

## The SDK defines no problem types

RFC 9457's `type` member is the problem's identity: the member a client branches on, with
`title` advisory and `status` an advisory copy of the status line. A type URI therefore names an
application's vocabulary, and an SDK that mints one claims semantics it does not own. Every
problem the SDK emits is `about:blank`, which the RFC defines as "no semantics beyond the HTTP
status code", and a consumer brings its own URIs through the problem writers' extension points.

## The error-to-problem mapping

`ErrorWriter` turns a handler's returned error into a problem response through a composed
matcher list. The SDK maps only its own vocabulary — a `QueryError` is a 400, built in; every
other status comes from a consumer-supplied `StatusMatcher`, consulted in order with first
match winning and 500 the fallback. Status mapping is application policy (whether a
foreign-key violation is a 409 or a 400 is the service's to say), and the matcher list is what
keeps the SDK and the infrastructure libraries peers: the SDK imports no infrastructure
library's error types, and a new infrastructure library costs the SDK nothing — its errors are
one more matcher at the consumer's composition root.

The detail member carries the error text only on a 400, where it is request-shaped and
client-actionable; every other status sends the bare title, so no internal error's text
reaches the wire.

## The readiness extension member

The readiness probe attaches a `checks` extension member (RFC 9457's term) to an `about:blank`
problem, though the RFC means extension members to be defined by the problem type. The trade-off
is accepted: if a consumer needs readiness failures under its own vocabulary, the answer is a
type hook on the readiness aggregate rather than an SDK-owned URI, deferred until a consumer
asks for it.

## Defaults keep the document consistent with the status line

A zero status defaults to 500. An empty title defaults to the status phrase, which is what the
RFC asks of an `about:blank` problem and what keeps a hand-typed title from drifting from the
status code it accompanies; for a code outside the standard table the title is omitted rather
than invented. Extension members may add or override any member except `status`, which is
re-seeded after the copy so the body always matches the status line.
