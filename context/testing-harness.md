# Integration harness rules

Landed from the coordinator for a page here. The rules an integration harness follows, learned
from the stalls the reference service's first suite hit. go-core's `processtest` and go-web-sdk's
`webtest` implement them.

The harness runs the service as its binary and drives it only through production surfaces:
configuration by environment variables, the API and the admin surface for state, the network
through a loopback relay for faults, and signals and the exit code for lifecycle. Nothing in the
runtime exists for the tests' sake.

- A stall is a finding, never a sleep. Every wait is a bounded poll on an observable condition.
- A race-instrumented service drops the race runtime's exit sleep (`atexit_sleep_ms=0`).
- One client per process, one connection per client, so graceful shutdown never waits on an idle
  second connection.
- Cleanup interrupts first and kills only a process that does not exit.
- Readiness is observed through the API on a port the harness chose; the log is never parsed.
- State control goes through the operator's surface; a case starts from a state it made.
- Faults are injected at the network, indistinguishable from an outage.
- Every process's output is captured and attached to a failure.
- The harness proves itself on the unit tier, against loopback stand-ins.
- Per-call timing is a first-class diagnostic.

Likely home: `standards/go-elemental/principles/tests-and-docs.md`, which states the two tiers.
