---
key: overview
name: Standards Lab
type: index
---

# Standards Lab

Standards Lab is the blueprint for formalizing an effective, modern, agentic software
architecture strategy; the vision is stated in the
[organization profile](https://github.com/standards-lab). This repository is the
organization's architecture: the canonical home for the Elemental Architecture, its
principles, the standards that implement it, and a catalog of the repositories that implement
the standards. The blueprint is informative, not prescriptive: its arrangement may serve any
discipline that benefits from an agentic development workflow, and how an external effort
structures its own architectures and standards is its own to decide. This is a worked example,
not a schema.

Standardization here is emergent rather than decreed. A convention becomes a standard only
after working code has proven it: each module in the organization is a worked example that
others follow, and a pattern proven in one module is promoted upward, into the libraries
beneath it, then into its standard, and ultimately into the architecture's principles, as it
demonstrates that it generalizes.

## The hierarchy

Everything documented here sits at one of three levels of resolution, and each directory level
documents one. Each level below belongs to the level above.

| Level | Location | What it defines |
|-------|----------|-----------------|
| Architecture | [`architecture.md`](architecture.md) | The Elemental Architecture: the compositional elements a program is built from and the rules that bind them, independent of language, with its [principles](principles/README.md) |
| Standards | [`standards/<key>/`](standards/README.md) | Each standard: a technology-specific implementation of the architecture, declaring its own dependency line and the principles its modules share |
| Modules | The repositories | The worked examples, in three classes: library (the core SDK, application SDKs, and infrastructure libraries), template, and app; each standard's README catalogs its members |
| Harness | [`harness/`](harness/README.md) | Principles for the agentic infrastructure the organization builds with; outside the hierarchy |

Three terms bind the levels. An **architecture** defines a domain's compositional elements and
the rules that bind them, independent of any technology. A **standard** implements an
architecture on a specific technology and declares the principles its modules share. A
**principle** is a singular convention attached to any level of the hierarchy. The narrowing
rule joins them: a lower level may enhance, meaning tighten, a principle it derives from, and
never loosen it. A module's principles satisfy its standard's; a standard's satisfy the
architecture's.

## Standards

- [Go Elemental](standards/go-elemental/README.md) is the Go implementation of the Elemental
  Architecture: a complete reference architecture on the Go standard library, with the smallest
  deliberate dependency surface. Its README catalogs its member repositories by tier.

## Harness

The harness stands outside the hierarchy: it governs the agentic infrastructure the
organization builds its modules with, not the software they contain. Its principles are
cataloged at [`harness/`](harness/README.md), with the harness repositories as the worked
examples.

## Catalog

Implementations that live outside this blueprint, graduated organizations and external
implementations of its architecture, are referenced here rather than documented here. No
entries exist yet; the first arrives when the Elemental Architecture completes and graduates
to its own organization.

## What belongs here

This repository holds what has generalized past one repository: a principle, a definition, a
convention. Nothing a reader can infer from a repository's source belongs here. A repository's
implementation is documented in the repository, in its README, its package documentation, and
its source, and a page here that restates a repository's implementation is a defect. A page
arrives by promotion: a concept in the repository that owns it, a design note once it settles,
and a page here once the design has generalized.

## Page metadata

Every page opens with YAML front matter, which GitHub renders as a table above the page. A
directory's index is its `README.md`. Common fields:

```yaml
key:  go-elemental        # stable identifier; matches the page's path segment
name: Go Elemental        # prose name
type: standard            # index | principle | architecture | standard
```

Per-type fields:

- `type: principle` — `level`: `architecture`, `harness`, or the key of the standard the
  principle attaches to.
- `type: architecture` — `status`: `draft` | `active` | `superseded`.
- `type: standard` — `architecture`: the key of the architecture the standard implements;
  `status` as above; `derives`: the key of the standard it re-expresses, when it does.

## Conventions

- Pages are plain markdown with relative links, readable on GitHub as-is and toolchain-neutral
  for a documentation site.
- Code on a page is illustrative only: it links to a direct example, or it encodes a generic
  representation of the pattern that stands on its own.
- A page describes what exists; planned work is marked as planned.

## License

[Apache License 2.0](LICENSE).
