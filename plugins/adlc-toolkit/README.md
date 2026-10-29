# adlc-toolkit

Skills that assist product development in an ADLC (Agentic Development Lifecycle) way: work flows from a feature requirement to a reviewed spec, a plan, an implementation, verification and deployment, with AI agents doing the work and people deciding.

## Install

```
/plugin marketplace add falcovd/falcovd-agentic-marketplace
/plugin install adlc-toolkit@falcovd-agentic-marketplace
```

## ADLC workflow

The toolkit covers the stages marked with a skill. The other stages are open: they have no skill here yet, and some have a recommended plugin.

```
[Discovery] -> [Feature requirements] -> [Technical plan] -> [Implementing plan] -> [Verify and testing] -> [Deploy]
```

| Stage | Skill or tool | Status |
| --- | --- | --- |
| Discovery | `/adlc-toolkit:product-discovery` | Available |
| Feature requirements | `/adlc-toolkit:feature-to-spec` | Available |
| Technical plan | n/a. Recommended: the superpowers plugin (`superpowers:writing-plans`) | Not in this toolkit |
| Implementing plan | n/a. Recommended: the superpowers plugin (`superpowers:executing-plans` or `superpowers:subagent-driven-development`) | Not in this toolkit |
| Verify and testing | n/a | Not planned |
| Deploy | n/a | Not planned |

Verify and testing and Deploy are not planned, because everyone tests and deploys in a different way. Use the approach that fits your project.

Before the first stage, prepare the project once with `/adlc-toolkit:init-adlc-project`. It gives every later stage the project's tech stack, coding standards and architecture.

```
/adlc-toolkit:init-adlc-project   (once per project, re-run to update)
        |
        v
[Discovery] -> /adlc-toolkit:product-discovery -> feature.md
        |
        v
[Feature requirements] -> /adlc-toolkit:feature-to-spec -> spec
        |
        v
[Technical plan] -> [Implementing plan] -> [Verify and testing] -> [Deploy]
```

### Recommended: superpowers plugin

The technical plan and implementing plan stages work well with the superpowers plugin. Install it separately:

```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

Then use `superpowers:writing-plans` to turn the spec into a plan, and `superpowers:executing-plans` or `superpowers:subagent-driven-development` to implement it.

## Skills

### `product-discovery`

Run: `/adlc-toolkit:product-discovery`

The discovery track, the step before `feature-to-spec`. Takes a vague problem to a validated feature document.

- Frames the problem and writes a problem statement with falsification criteria set in advance.
- Gathers data evidence from connected sources, then pauses so you can interview real users.
- Re-invoke it after the interviews: it judges all evidence against the criteria and, if the problem holds up, writes `feature.md`.
- Output goes to `discovery/<topic>/`. `feature.md` is the input for `feature-to-spec`.

### `init-adlc-project`

Run: `/adlc-toolkit:init-adlc-project`

Captures a project's technical context in `.adlc-project/PROJECT.md` and adds a marked block to the root `AGENTS.md`. The block tells agents to read the files in `.adlc-project/` at the start of a session.

- Covers Tech Stack, Coding Standards and System Architecture. UX Guide and API Conventions are optional.
- Detects what it can from the code, confirms it with you, and asks for everything else. It never assumes.
- Notes the source of each fact. You can answer "TBD" and fill it in on a later run.
- Works on existing projects, new projects and repositories with several packages.
- Writes nothing until you approve the result. Never writes secrets or personal data. Never commits: review and commit the files yourself.
- Re-running it is the way to update the context.

### `feature-to-spec`

Run: `/adlc-toolkit:feature-to-spec`

Guides a product owner from a feature idea or document to an approved PRD and a spec (what and why, no technical solution).

- Critique rounds by a reviewer with a clean context, and explicit approval at each phase.
- Open product questions are asked, not parked in the document.
- Output: `feature.md`, `prd.md`, `spec.md` and `decisions.md`, all in English.

The spec is the input for the technical plan.

## Development

Static checks for `init-adlc-project` run in CI and locally:

```bash
bash plugins/adlc-toolkit/tests/check-init-adlc-project.sh
```

Manual scenarios for the skill's interactive behaviour are in `plugins/adlc-toolkit/tests/SCENARIOS.md`.
