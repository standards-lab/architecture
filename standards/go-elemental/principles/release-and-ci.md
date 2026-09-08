---
key: release-and-ci
name: Releases and CI
type: principle
level: go-elemental
---

# Releases and CI

How Go Elemental repositories are versioned, released, built, and tested. Every repository
releases independently ([independent releases](../../../principles/independent-releases.md));
this page states the shared mechanics and the variants each tier adds.

## Releases

A releasable artifact is released by pushing its tag: `v<semver>` for a module rooted at the
repository, `<path>/v<semver>` for a nested sub-module (`postgres/v0.1.0`, `template/v0.1.0`).
Each artifact keeps its own `CHANGELOG.md` in Keep-a-Changelog form: dated headings
(`## [vX.Y.Z] - YYYY-MM-DD`), a standing `[Unreleased]` section where changes accumulate
between cuts — the accumulation point when a coordinated multi-repo change lands over several
sessions — and link-reference definitions resolving each bracketed heading to its compare or
tag URL. The release workflow derives the artifact from the tag and extracts the matching
changelog section into a GitHub release. There is no umbrella version spanning a base module
and its sub-modules.

A prerelease tag (`v0.2.0-dev.1`) is the mechanism for one narrow case: a separate module that
must resolve an API still under development, where a local `go.work` cannot serve — another
repository's CI, chiefly. It is cut only for that need, never as routine between-session
practice, and a minor-or-above release purges the tags it subsumes: its changelog entry states
that it includes every `-dev.N` change, and those tags are removed.

Every repository's first release is `v0.1.0`, its changelog opening with a snapshot of what the
artifact provides at that version.

## Branches and tags

Release preparation commits directly to `main`: the changelog date, the license, metadata
edits, and the README brought current with the release's changes. The changelog, `context/`,
and `doc.go` move with the work itself; the README has no earlier forcing point, so this step
is where it is checked rather than left to rot behind them. The tag is pushed only after
main's CI run passes, the integration job included where the repository has one, so a release
never points at a commit that failed CI.

No release branch is retained. The tag is the durable artifact, and a branch can be recreated
from its tag at any time. A `release/v<major>.<minor>.x` branch is created only when a
maintenance line exists, meaning a patch to an older minor after `main` has moved past it, and
is kept only as long as that line is supported. Every other branch is deleted when it merges.

A published tag is never re-cut. Once the module proxy has fetched a version, the checksum
database pins that commit permanently, so moving the tag leaves consumers with a checksum
mismatch they cannot resolve. A failed release workflow does not affect module resolution,
since `go get` reads the tag rather than the GitHub release; the fix is to repair the workflow
on `main` and create the release for the existing tag.

## Coordinating a change across modules

Where a repository contains a base module and provider sub-modules, a committed root `go.work`
resolves them together during local development, so a change spanning them is built and tested
before anything is tagged. Pinned `require` versions are the committed steady state; a `replace`
directive is a transient bridge while a provider builds against unreleased base changes, and it
is removed once the base is tagged. The release ripple runs bottom-up: tag the base, bump the
provider's `require`, note it in the provider's changelog, tag the provider.

The tiers ripple the same way: a go-core change releases first and is taken up by coordinated
releases in the repositories above it, each pinning the versions it validated against.

## CI

Every repository runs `go vet`, a `gofmt -l` formatting check, `go mod tidy -diff`,
`go test -race`, and golangci-lint on every push. Tool versions are pinned — the Go toolchain
and the golangci-lint version, in CI and in mise alike — so the gate is reproducible and moves
only by a deliberate bump. The variants:

- A single-module repository runs the checks at the repository root.
- A multi-module repository runs a per-module matrix, each entry scoped to its module's
  directory; the matrix, the `go.work` use-list, and the task runner's module list name the
  same modules and are updated together.
- A template repository runs the checks inside its `template/` subtree.

A repository with an integration tier ([tests and documentation](tests-and-docs.md)) runs a
second job, `integration`, on push to `main` and on manual dispatch: it runs the repository's
`integration` task, which boots the compose stack as an isolated project where the service has
one, runs the tagged suite against the built binary, and tears the project down. The job runs
below the per-pull-request rate by design, and a green integration run on `main` is the
condition for cutting a release.

The repositories are public: modules resolve through the public Go proxy and checksum database,
and CI needs no private-module configuration. The service-tiers import boundary is a
consumer-side check and runs in consumers; inside an infrastructure library, the module topology
already prevents the base from importing a provider.

## What ships in a module zip

A module zip includes every committed file below its `go.mod`, `context/`, `CLAUDE.md`, and
`.claude/` among them. Go provides no supported way to exclude them, and they cost nothing: the
toolchain compiles only imported `.go` files, so they ship as committed. The template is the
deliberate exception: its module boundary at `template/` exists so the management layer never
ships.

## Tasks

Each repository defines its developer tasks with mise (`build`, `test`, `vet`, `fmt`, `tidy`,
`lint`, and `integration` where the repository has the tier), each wrapping a plain Go command
and looping over the module list where the repository is multi-module. The repository works
without mise; the tasks are a convenience.
