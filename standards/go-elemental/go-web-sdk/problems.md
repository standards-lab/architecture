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

## The error-returning handler

`HandlerFunc` is the handler shape that reports failure by returning an error, and `Handle`
adapts one into an `http.Handler` under an `ErrorWriter`: a returned error is written as a
problem, so a handler's body reads as its success path and every rejection is one return
statement. The standard library's signature stays the primary contract. A group and the
router take `http.Handler`, nothing requires the adapter, and a group registers an
error-returning handler under the writer set on that group, one writer per group rather than
per route ([routing](routing.md)).

The adapter never writes a second response. A handler that committed a response and then
returned an error is reported through the writer's logger, and nothing more is written. The
adapter learns whether a response was committed from its own response-writer wrapper, which
records the first header write and treats a body write with no header before it as an
implicit 200.

## The error-to-problem mapping

`ErrorWriter` turns a handler's returned error into a problem response through a composed
matcher list. The SDK's own vocabulary is built in: a `QueryError` is a 400, a
`PreconditionError` is a 428 when the header is missing and a 400 otherwise, and a `BodyError`
is a 413 when the body is over its limit and a 400 otherwise. Every other status comes from a
consumer-supplied `StatusMatcher`, consulted in order with first match winning and 500 the
fallback. Status mapping is application policy, since whether a foreign-key violation is a 409
or a 400 is the service's to say, and the matcher list is what keeps the SDK and the
infrastructure libraries peers: the SDK imports no infrastructure library's error types, and a
new infrastructure library costs the SDK nothing, because its errors are one more matcher at
the consumer's composition root.

The detail member carries the error text only on a status in the writer's detail set. The
built-in set is 400, 413, and 428, the statuses that are request-shaped by construction, so no
internal error's text reaches the wire. A consumer adds statuses for a surface whose clients
need the reason, such as an operator API's 409.

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
