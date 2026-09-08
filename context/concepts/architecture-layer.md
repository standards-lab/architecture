# The architecture layer

Settled 2026-09-08, at the `v1.alignment.docs` session, when the pass found that every module
page it rewrote restated a package comment or a README and that the pages it replaced had been
invalidated by one or two releases each. The rule below is the architect's; the marathon skill
codifies it (`references/context-engineering.md`, unreleased on the `dsl-docs-pass` branch of
claude-plugins), and the coordinator's `context/design/architecture-layer.md` is the workspace's
design record. This note is the follow-on session's work list, and it is deleted when that
session closes.

## The rule

This repository is the workspace's architecture: the Elemental Architecture, its principles,
each standard's principles, the harness principles, and a catalog of the repositories that
implement them. It holds only what has generalized past one repository. Anything a reader can
infer from a repository's source does not belong here; anything that serves as a general
guideline or development principle does. Knowledge arrives by the promotion sequence, a concept,
then a design note, then a page here, and a page that restates a repository's implementation is
a defect.

A repository's implementation is documented in the repository: its README, its package
documentation, and its source, with an optional `docs/` directory the README indexes as the
accessibility layer over them, the way sqlate's README indexes its guide. Those directories are
written as a task at v1 completion (`goals.v1.tasks.repository-docs`), so the documentation of
each layer is not revised while the roadmap churns it.

## The follow-on's work list

The next session in this repository, a `start` under `v1.alignment.docs`, does the following,
in this order:

1. Rename the repository to `architecture`: on GitHub, in the local checkout
   (`~/architecture/architecture`), in the coordinator's `references.toml`, `references.md`,
   and `references.local.toml`, in the order map of the coordinator's `marathon.toml`, and as
   the coordinator's `[workspace] architecture` key in place of `docs`.
2. Make the tree GitHub-navigable: every `index.md` becomes the `README.md` of its directory,
   and the root `README.md` absorbs today's `index.md` as the entry page, keeping the hierarchy
   table, the vocabulary, the front-matter schema, and the conventions. `architecture.md`
   stays at the root.
3. Remove the module directories under `standards/go-elemental/` (`go-core/`, `go-database/`,
   `go-web-sdk/`, `go-web-sdk-template/`), and with them the Modules level of the hierarchy
   table and the `module` and `page` types of the schema. Before deleting, read each page for
   content that is principle rather than implementation and promote it into the standard's
   principle pages; the reverted pages of this session are on the `dsl-docs-pass` branch's
   history for the same read.
4. Reduce the standard's README to a catalog of its members: tier, repository link, and a
   one-sentence purpose, with sqlate named as adjacent. The root README's Standards section
   lists the standards and links each; it never goes deeper than the catalog.
5. Restate `CLAUDE.md` under the rule: the repository is the workspace's architecture, a
   `context` project run by `start` and `plan`; a page restating a repository is a defect; the
   promotion sequence is how a page arrives.
6. Repoint every Go member's README Standard section from its module page to the standard's
   README and the principles it enhances, one cross-repository step across go-core, sqlate,
   go-database, go-web-sdk, go-web-sdk-template, and go-web-service. The profiles and the
   orientation brief follow.
7. Amend `references/` links across the workspace's context that name `docs/blob/main/...`
   pages, once the rename lands.

The `harness/README.md` keeps its "conventions not yet paged" section; workspace coordination
and the extension system remain marathon's own until they prove out beyond it.

## Assumptions

- Assumes GitHub's repository rename redirects the old URL, so a link that names the old
  repository resolves until step 7 repoints it.
- Assumes the standard's principle pages can absorb what is principle in the module pages
  without a new page type; if a convention needs its own page, it is a principle page.
