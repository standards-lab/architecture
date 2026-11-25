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

A dependency is anything whose version the build depends on. The principle covers every
surface on which a component chooses such a version, so no chosen version is exempt:

- the language toolchain;
- the direct module dependencies;
- the actions a CI workflow runs;
- the developer tools the task runner and CI invoke;
- the container images a compose file or a CI workflow starts, each pinned once: a compose
  service's pin is the `FROM` line of the Dockerfile it builds from, which currency reads;
- each source a Dockerfile builds into its image, such as a database extension, pinned once, by
  one build argument, which currency reads;
- the container image a library names as its default in its source, pinned by tag and digest
  together, which currency reports and an upgrade moves together, such as docproc's
  [`picture.LibreOfficeImage`](https://pkg.go.dev/github.com/standards-lab/docproc@v0.4.2/picture#LibreOfficeImage)
  and [`audio.FFmpegImage`](https://pkg.go.dev/github.com/standards-lab/docproc@v0.4.2/audio#FFmpegImage).

A container image is pinned by an exact tag, and its latest is the highest semantic version
among the tags that carry the pinned tag's variant suffix, the part after its version: a pin of
`18.6-alpine` is current against the newest `-alpine` release, not the newest tag of any variant.
A build counter that follows the variant, such as linuxserver's `-ls<N>`, is not part of the
variant suffix: it sorts after the version, so a pin of `9.0.2-cli-ls89` is current against the
newest `-cli-ls<N>` tag, by version first and build second. A tag counts only when it has at least
one dot, so a bare build number never sorts above every release.

A source a Dockerfile builds is pinned by the release tag it fetches, and its latest is the highest
semantic version among the source repository's tags. The tags are read rather than the published
releases, because a project may tag a release without publishing one.

A developer tool pinned for one task alone is covered too. A currency check reads every
environment's tool configuration, not only the default. A tool CI never needs stays pinned and
current, and CI skips installing it, as mise's `MISE_DISABLE_TOOLS` does for the 7-Zip pin
[docproc's workflows](https://github.com/standards-lab/docproc/blob/v0.4.2/docs/ci.md) never run.

A version in a file the tool manager doesn't read, such as a `global.json`'s .NET SDK version, is
copied by the upgrade from the tool manager's pin of the same tool, so it never moves on its own.

Indirect dependencies are left to the ecosystem's resolver. A component pins and bumps the
dependencies it names, and the resolver (`go mod tidy`, in Go) settles what those require;
the currency report names only what the component chose. A released binary's lock file, such as a
Cargo.lock, is the exception: the lock is exactly what the binary links, so the currency report
names its indirect dependencies too, and the upgrade moves them.

A linter pinned at `latest` makes the gate irreproducible; pinned and left alone it falls behind
the language it checks. The resolution is an explicit version, bumped when upstream releases.

## When an upgrade is applied

An upstream release is an immediate priority and never interrupts a running session. The
session finishes its step, and the upgrade becomes its own small step, usually the next one. A
patch or minor bump across the organization is one cheap step. A major version may need a
planned session of its own.

## How an upgrade runs

An upgrade moves every covered version that trails, a CI workflow's action pins included. It moves
the tool manager's pins first, so the language's modules then move under the toolchain just pinned:
in Go, the mise pins before the Go modules, since a `go` directive raised past the old toolchain
would send the go command to fetch another.

## A held pin

A pin held for a stated reason sits in a named hold list, one `<item> <pin>: <reason>` line each,
the item named as the currency report names it. In a `mise.toml`, the list is `HOLDS`, in its
`[env]`. The upgrade skips a held pin, and the currency report shows it as held, with its reason,
rather than trailing. The hold names the pin it holds, so moving the pin ends the hold.
[docproc's development page](https://github.com/standards-lab/docproc/blob/v0.4.2/docs/development.md#the-root-misetoml)
is an example.

## Why a release installs the day it ships

A package manager's release-age wait is set to zero, so it installs the latest release the
currency report names; a nonzero wait refuses a release published that day, and the bump fails.
Reading each release's notes before its bump lands is the review that replaces the wait. The
trade is deliberate: the wait keeps out a compromised publish that the registry pulls within
hours, and reading the notes doesn't.

## How the principle depends on the minimal footprint

This principle and the [minimal, deliberate dependency footprint](minimal-footprint.md) justify
each other. A handful of deliberately sourced dependencies can be kept current in the week
upstream releases; fifty cannot. The small footprint makes currency tractable, and currency is
what the footprint is kept small for.
