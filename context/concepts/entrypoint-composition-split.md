# Splitting the entrypoint from the composition root

`principles/composition-root.md` currently states one concept —
"composition root" — that owns two responsibilities: process entry and exit (traps signals,
derives the root context, owns the exit code) and declaring the composition (wiring
dependencies, nothing else executing). The Go Elemental realization already separates these
in practice, in the template and the reference service: `cmd/server` is the minimal entrypoint
that traps the signal and derives the context, and passes it to `internal/app`, the
encapsulated composition root that does the actual wiring and never executes past declaring
it (`standards/go-elemental/principles/topology-and-naming.md`'s "Application-layer import
direction").

The idea, raised while reviewing that addition: generalize the split to the architecture level.
Every application's entrypoint is minimal — process-level concerns only, nothing else. Every
application has one composition root beneath it, encapsulated so nothing above the entrypoint
reaches into it directly and nothing below it reaches back up. What sits below the composition
root — the application's actual domain and infrastructure packages — stays the author's
decision, same as today.

Unsettled: whether "composition root" keeps its name and gains a formally separate "entrypoint"
neighbor, or the definition splits some other way; how much of `composition-root.md`'s existing
text (particularly "It owns process entry and exit") moves under the new distinction versus stays
where it is; and whether the Application element in `architecture.md` needs rewording to
introduce the split, since it currently states the composition root as the one
thing that "only declares the composition."

This is bigger than an additive principle like Reactor: it reshapes how the architecture defines
itself, not just what it enumerates, so it gets its own session rather than folding into
whatever is in progress when this is picked up.
