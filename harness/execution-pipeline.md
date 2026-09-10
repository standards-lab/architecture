---
key: execution-pipeline
name: A standardized execution pipeline
type: principle
level: harness
---

# A standardized execution pipeline

A workflow skill with several commands runs every command through one pipeline: a fixed sequence
of stages defined once, in an execution spec, with each command supplying only the content of its
stages. The pipeline owns the mechanics that must not vary per command — how the session locates
its project, when planning is settled with the developer, how the session concludes — and a
command's playbook stays a thin layer of stage content.

Extensions integrate at the pipeline, not at the commands. The pipeline names universal hook
points, each firing just before the moment it names; an extension declares which points it acts
at, and every command inherits the firing for free. Adding a command never means updating the
extensions, and adding an extension never means editing a command.

## Worked example

marathon's five-stage pipeline (locate, start, settle, execute, conclude) is
[`mechanics/pipeline.md`](https://github.com/standards-lab/claude-plugins/blob/main/plugins/marathon/skills/marathon/mechanics/pipeline.md);
its five universal hooks (`on-start`, `on-execute`, `on-commit`, `on-reset`, `on-close`) fire per
[`mechanics/hooks.md`](https://github.com/standards-lab/claude-plugins/blob/main/plugins/marathon/skills/marathon/mechanics/hooks.md).
The marathon-roadmap extension connects to three of the five and is never named by a command.
