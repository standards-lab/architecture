---
key: release-and-ci
name: Releases and CI
type: principle
level: go-elemental
---

# Releases and CI

How Go Elemental repositories are checked, kept current, versioned, and released. Every
repository releases independently ([independent releases](../../../principles/independent-releases.md));
this page states the shared mechanics.

## One check per repository

Each repository has one check, `mise run check`, read-only and deterministic, stopping at the
first failure. For every module in the repository's module list, with the workspace file
disabled (`GOWORK=off`), it runs the Go SDK's gates and then golangci-lint:

- `go build ./...`
- `go vet ./...`
- a `gofmt -l` formatting check
- `go fix -diff ./...`
- `go mod tidy -diff`
- `go test -race ./...`
- `golangci-lint run ./...`

A repository adds what its own code needs: sqlate, blobfs, and go-web-service run the SQL
conventions lint after the loop, and the template and go-web-service vet, fix, and lint with
`-tags integration` so the integration suite compiles and lints too
([tests and documentation](tests-and-docs.md)). The template's check runs inside its
`template/` subtree.

CI runs the same check, so the gate is the one a developer runs. Each repository's CI workflow
has one `check` job that installs the pinned tools with mise and runs `mise run check`, on
every pull request and push to `main`; there is no per-module matrix, because the check loops
over the modules itself. A repository with a suite beyond the unit tier adds a job for it:
go-storage's `acceptance` job runs azureblob against Azurite, and the template's and
go-web-service's `integration` job runs the integration tier on push to `main` and on manual
dispatch. The Go toolchain and golangci-lint versions are pinned in `mise.toml`, which CI and a
developer's machine both read, so the gate moves only by a deliberate bump.

## Currency and upgrade

Beside the check, two development-time tasks keep a repository current:

- `mise run currency` runs the repository's `scripts/currency.sh`, which reports every
  requirement, Go version, tool, and action pin, and where the repository has one, every
  container image tag, that trails its latest release, and exits non-zero when it reports
  any. It reads the network and writes nothing.
- `mise run upgrade` moves every module's `go` directive to the current Go minor, upgrades its
  direct requirements to their latest, tidies, and bumps the local mise tools, rewriting
  `go.mod` and `mise.toml`.

Currency is not a CI gate: no workflow runs it, so a new upstream release never turns a
repository's CI red. Dependabot covers security only: each repository has Dependabot security
updates enabled and no `dependabot.yml`, so no version-update pull requests open.

## Releases

A releasable artifact is released by pushing its tag: `v<semver>` for a module rooted at the
repository, `<path>/v<semver>` for a nested sub-module (`postgres/v0.1.0`, `template/v0.1.0`).
Each artifact keeps its own `CHANGELOG.md` in Keep-a-Changelog form: dated headings
(`## [vX.Y.Z] - YYYY-MM-DD`), a standing `[Unreleased]` section where changes accumulate
between cuts, and link-reference definitions resolving each bracketed heading to its compare or
tag URL. There is no umbrella version spanning a base module and its sub-modules.

Each repository's release workflow has one `release` job, triggered by a pushed tag. It derives
the module's path prefix and changelog from the tag, extracts the matching changelog section,
and creates the GitHub release; runs for the same tag are serialized.

Release preparation lands on `main` through a pull request, like any other change: the
changelog date, metadata edits, and the README brought current with the release's changes. A
ruleset on `main` requires the pull request in every repository except go-storage and blobfs.
The tag is pushed only after `main`'s CI run passes, the integration job included where the
repository has one, so a release never points at a commit that failed CI.

A tag whose release failed may be deleted and re-pushed at the same version once the fix is on
`main`. A released tag is never re-cut: once the module proxy has fetched a version, the
checksum database pins that commit permanently, and moving the tag leaves consumers with a
checksum mismatch they cannot resolve.

No release branch is retained; the tag is the durable artifact. Every other branch is deleted
when it merges.

## Coordinating a change across modules

Where a repository contains a base module and provider sub-modules, a committed root `go.work`
resolves them together during local development, so a change spanning them is built and tested
before anything is tagged. Pinned `require` versions are the committed steady state; a `replace`
directive is a transient bridge while a provider builds against unreleased base changes, and it
is removed once the base is tagged. The release ripple runs bottom-up: tag the base, bump the
provider's `require`, note it in the provider's changelog, tag the provider.

The tiers ripple the same way: a go-core change releases first and is taken up by coordinated
releases in the repositories above it, each pinning the versions it validated against.

The repositories are public: modules resolve through the public Go proxy and checksum database,
and CI needs no private-module configuration.

## What ships in a module zip

A module zip includes every committed file below its `go.mod`, `context/`, `CLAUDE.md`, and
`.claude/` among them. Go provides no supported way to exclude them, and they cost nothing: the
toolchain compiles only imported `.go` files, so they ship as committed. The template is the
deliberate exception: its module boundary at `template/` exists so the management layer never
ships.

## Tasks

Each repository defines its developer tasks in `mise.toml`: `check`, `currency`, and `upgrade`,
and beside them conveniences such as `test`, `vet`, `fmt`, `tidy`, and `lint`, each wrapping a
plain Go command, plus `integration` or `acceptance` where the repository has such a suite and
tasks that start and stop its compose stack. The repository works without mise; the tasks are a
convenience.
