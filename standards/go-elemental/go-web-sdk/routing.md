---
key: routing
name: Routing
type: page
repo: go-web-sdk
---

# Routing

The design of the routing layer: groups, modules, and the router. The code and `doc.go` are
authoritative for the API; this page records the decisions.

## Composed once, at wiring time

Compiling a module renders a group tree into full mux patterns in one pass. Every route
registers under its complete pattern with its middleware chain baked in: group middleware
outermost, ordered root to leaf, then per-route middleware. Nothing recomposes or validates per
request, and nothing rewrites a request path except the one module kind that exists to mount a
foreign handler under a prefix, which uses the standard library's prefix stripping.

Compile-once creates its own hazard: a route registered after compilation would be silently
dead. Compilation therefore seals the group tree, and a later registration panics.

## One canonical path

A group becomes servable one way and mounts one way. Multi-segment prefixes such as `/api/v1`
are first-class: a prefix must begin with `/` and not end with one, and a malformed prefix
panics at construction.

## The probes mount outside the modules

The router exposes its native fallback mux for direct registration, and the health probes mount
there, beyond every module's middleware. They need no exemption from authentication or logging
policy inside a module because a probe request never enters one. Router-level middleware still
wraps the whole dispatch, modules and fallback alike.

Dispatch is longest-prefix match on segment boundaries; `/api/v10` does not match a module
mounted at `/api/v1`. The native mux answers every path no module owns.

## Registration mistakes panic at wiring time

A malformed prefix, a duplicate pattern, a second module at a taken prefix, and a sealed-group
mutation all panic. The
[composition root](../../../principles/composition-root.md) is written
once and runs at boot, so a loud failure there beats a silent one in production; the lifecycle
coordinator takes the same posture toward a late registration.
