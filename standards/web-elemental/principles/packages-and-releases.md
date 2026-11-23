---
key: packages-and-releases
name: Packages and releases
type: principle
level: web-elemental
---

# Packages and releases

How Web Elemental repositories are packaged, released, and pinned. This page builds on
[independent releases](../../../principles/independent-releases.md),
[rolling currency](../../../principles/rolling-currency.md), and the
[five kinds of comment](../../../principles/comments.md), and states what the standard adds to
them.

## Releases

Each repository is one package, and its releases follow four rules:

- A release is a plain annotated `vX.Y.Z` tag on a pack commit whose one parent is main's merge
  commit.
- The tag is cut by hand on a green check, from `package.json`'s version with its `CHANGELOG.md`
  section, and is never changed or re-cut.
- A release workflow, dispatched by hand with the pushed tag and never on a push, only verifies
  and publishes it.
- The build output (`dist/`) lives only in the tag's tree, the pack, never on a branch.

A member that ships a Go binary, such as webappgen, keeps Go Elemental's
[release rule](../../go-elemental/principles/release-and-ci.md#releases).

## How a layer resolves another

A layer resolves another only through its release tag, as a consumer does: never a link, path
alias, source condition, or project reference.

## Pins

Pins are exact, and a peer range admits its latest release. pnpm's `minimumReleaseAge: 0` is the
standard's narrowing of rolling currency's
[Why a release installs the day it ships](../../../principles/rolling-currency.md#why-a-release-installs-the-day-it-ships).
