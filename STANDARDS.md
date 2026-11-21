# architecture standards

The judgement calls the standards-reviewer applies to the architecture layer, beyond what `scripts/check.sh` enforces: each relative link resolves, each page carries the front matter its type requires, and `lint-context` and `lint-references` pass.

- A claim on a page may link one example of the merged code or check that expresses it, pinned at a tag or commit where the claim depends on its content.
- A page never restates a repository's implementation; it links the repository instead.
- `architecture/README.md` "Conventions": held by review; of these, the check enforces only that each relative link resolves.
- `architecture/principles/context-architecture.md`: every page and index, `architecture.md` and the root README included.
- `architecture/principles/comments.md`: the comments in every script and configuration file (TOML, YAML, `.gitignore`, mise).
