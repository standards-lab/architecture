---
key: rolling-currency
name: Rolling currency
type: principle
level: architecture
---

# Rolling currency

Every component keeps its dependency set pinned and current. Every version is explicit, so every
commit is reproducible and a gate moves only by a deliberate bump. Every version is also the
latest release, so the bumps arrive promptly. The principle requires both: an explicit version
that is left alone falls behind the releases it must track, and a floating version makes the
build irreproducible.

The posture is that of a rolling release rather than a stable distribution, adopted
deliberately. Staleness is technical debt by definition rather than by accident. When a new
release of a language, a dependency, or a tool is cut, applying the upgrade becomes the next
scheduled step.

## Which versions the principle covers

A dependency is anything whose version the build depends on. The principle covers every such
surface, so no surface is exempt:

- the language toolchain;
- the direct module dependencies;
- the actions a CI workflow runs;
- the developer tools the task runner and CI invoke.

The organization's linter is the worked example. Pinned at `latest`, it made the lint gate
irreproducible. Pinned at a fixed version and left alone, it would have fallen behind the
language release it checks. The resolution is an explicit version, bumped when upstream
releases.

## When an upgrade is applied

An upstream release is an immediate priority and never interrupts a running session. The
session finishes its step, and the upgrade becomes its own small step, usually the next one. A
patch or minor bump across the organization is one cheap step. A major version may need a
planned session of its own.

## How the principle depends on the minimal footprint

This principle and the [minimal, deliberate dependency footprint](minimal-footprint.md) justify
each other. A handful of deliberately sourced dependencies can be kept current in the week
upstream releases; fifty cannot. The small footprint makes currency tractable, and currency is
what the footprint is kept small for.
