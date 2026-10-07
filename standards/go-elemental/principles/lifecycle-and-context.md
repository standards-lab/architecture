---
key: lifecycle-and-context
name: Lifecycle and context ownership
type: principle
level: go-elemental
---

# Lifecycle and context ownership

Every Go Elemental web service follows one process lifecycle, hosted by go-core's `lifecycle`
package, and one context-ownership convention. The lifecycle realizes the Elemental
Architecture's infrastructure-service contract in Go: startup layer by layer, shutdown in reverse,
and named readiness reported to the probes. The page uses the
[composition terms](../../../principles/composition-terms.md): graph, node, system, layer,
subsystem, and coordinator.

## The entrypoint owns the signal context

The application's entrypoint, the minimal binary above the [composition
root](../../../principles/composition-root.md), traps signals, derives the root context, and owns
the exit code; a web service's entrypoint also loads the configuration, which its composition root
never does. The web service's entrypoint passes the root context to the composition root's run
call, which hands it to the lifecycle coordinator's blocking run call, the one call that owns the
sequence. go-core's `process` package holds this pre-infrastructure sequence (the signal-derived
root context, failure and usage reporting before a logger exists, and the exit-code convention the
reporters return), so it cannot drift between a program's binaries. A web service's composition
root declares each subsystem to go-core's coordinator as a `lifecycle.Service`, which names the
subsystem, gives its layer as a numbered `Stage`, and carries its startup, shutdown, and readiness
check, while process-level callbacks register as hooks and monitors. Nothing executes before the
run begins, and the coordinator installs no signal handlers of its own.

Not every file of the composition root declares a subsystem. A layer of the architecture with no
resource and nothing that runs, such as the Elemental Architecture's Domain Service composition,
declares none and imports no part of this package: nothing in it starts or shuts down.

## A value takes part through single-method interfaces

A node's value takes part in the lifecycle only through the single-method interfaces it
implements: a `Starter`'s `Start` runs at startup, a `Stopper`'s `Shutdown` runs at shutdown, and a
`Subsystem` embeds both, for a value that does both. A value that implements neither, such as a
configuration value, takes no part, and nothing registers a hook beside the value. The coordinator
reads each subsystem's part from its value, so the part cannot drift from the value, and a test
that substitutes a node's value changes the node's part with it. The method is `Shutdown`, as
`http.Server` and the standard's libraries name it.

The `lifecycle` package of
[spike-cli-architecture](https://github.com/JaimeStill/spike-cli-architecture) realizes the rule.
go-core's coordinator does not follow it yet: a `lifecycle.Service` carries `Start` and `Shutdown`
as function fields, and hooks register beside the subsystems.

## The wiring rule

A defect the composition root wires panics at construction, with the fix named: an
unfinalized configuration, a missing pool, a malformed route prefix, a duplicate mount or
subsystem, a group modified after its module is built, a registration after the coordinator has
run. No runtime condition produces such a defect and no caller can recover from it sensibly, and
the composition root is written once and runs at boot, so a loud failure there beats a silent
one in production. A defect in configuration content, a reserved connection option or an invalid
value, returns an error from the call that reads it, the configuration's finalize step or the
provider's constructor, because configuration is input.

## Cold start, hot start, drain

Cold start constructs every object from configuration with no I/O, so a construction mistake
fails before anything runs. Hot start brings the subsystems up layer by layer, each layer's
subsystems concurrently and the request edge's layer last, so nothing serves before the
infrastructure beneath it is up. A startup failure drains what did start, and readiness never
reports a partially started process. The coordinator drives the drain and reverses the layers:
the run context is cancelled, the request edge's layer drains first, and every layer and shutdown
hook runs against a fresh timeout-bounded context, so cleanup is not pre-cancelled and needs no
cancellation guard of its own.

A subsystem declares runtime failure through a monitored channel: the first non-nil error ends
the run.

## Readiness reflects the live state of the process

The coordinator is ready once startup completes, and not ready again the moment draining
begins, so a readiness probe reports a draining process as unavailable before its teardown
runs. A subsystem exposes its own readiness through its named readiness check, and that state
is live: a subsystem that degrades fails the probe under its own name until it restores, and a
process that begins draining stays not ready until it exits. Leaf components take a plain
`context.Context`, keeping them usable without the coordinator.
