---
key: webtest
name: The integration toolkit
type: page
repo: go-web-sdk
---

# The integration toolkit

The `webtest` package is the integration toolkit for a service built on the `web` package: the
client a black-box suite drives the running service through, reading responses and RFC 9457
problems the way the package writes them, and the liveness observation a harness waits on. It
is the HTTP half of the standard's integration toolkit
([tests and documentation](../principles/tests-and-docs.md)). A harness launches the binary
with go-core's [`processtest`](../go-core/process.md) package and observes it here.

## What the client provides

- The client issues requests against one service and returns each response whole, so a test
  asserts on status, headers, and body with no transport in view. It holds one connection, per
  the harness rule that a transport must not leave a request-less connection for the server's
  graceful shutdown to wait on.
- A response asserts its status, decodes its body into a value, or asserts a problem document
  at a status and returns it. A generic decode combines the status assertion and the read for
  the common case.
- A header value carries the version precondition a guarded command takes, so a suite writes
  the `If-Match` header the way the [request helpers](requests.md) read it.

## What the harness observes

The liveness observation reports whether a service answers its liveness probe. It is the
condition a harness passes to the process toolkit's await, so readiness is observed through
the API on a port the harness chose and the log is never parsed.

## What the unit tier uses

The probe helper serves one request through a handler into a recorder, for a handler test
that needs no server. It is the toolkit's one unit-tier member, and it is what lets a harness
over the toolkit prove itself hermetically.
