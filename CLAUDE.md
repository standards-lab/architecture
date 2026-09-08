# docs

The Standards Lab organization's documentation landing zone: the canonical home for the
Elemental Architecture, its standards, its principles, and the documented details of every
module repository in the effort. Managed with the marathon workflow; start from
`context/README.md`.

## The workspace docs tier

This repository is the single human-facing docs tier for the `~/architecture` workspace. Member
repositories author no `docs/` directory of their own: their settled design knowledge is
documented here, and their `context/` and `README.md` link to the pages that document them. A
repository that tightens a documented principle states that enhancement beside its link, in the
repository — a lower level enhances the principle it derives from and never loosens it.

The pages describe what exists. Marathon's decay rule does not apply to them — a page restating
the code is doing its job — but a page the code has moved out from under is a defect, fixed in
the change that moved the code or in the next session here.

Code on a page is illustrative only: it links to a direct example, or it encodes a generic
representation of the pattern that stands on its own; it never depends on the current source of
an external project.

## Structure

The hierarchy runs from universal to specific, and each directory level documents one level of
it:

- `README.md` — orientation: the blueprint, the vocabulary, the map of everything here, and the
  front-matter schema; a README is every directory's index.
- `architecture.md` — the Elemental Architecture, the one definitive architecture the blueprint
  builds out.
- `principles/` — the architecture's principles, the highest level of resolution.
- `standards/<key>/` — each standard's definition, its principles, and its modules'
  documented details.
- `harness/` — principles for the agentic infrastructure the organization builds with, outside
  the software hierarchy above.

Every page opens with YAML front matter; the schema is documented in `README.md`.
