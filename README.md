# FalcovD Agentic Marketplace

A Claude Code plugin marketplace with skills and plugins that make agentic work easier. The first focus is product development in an Agentic Development Lifecycle (ADLC) way. More areas will follow.

## Install

In any Claude Code installation:

```
/plugin marketplace add falcovd/falcovd-agentic-marketplace
/plugin install adlc-toolkit@falcovd-agentic-marketplace
```

Adjust the GitHub path to wherever this repo is hosted. A local clone also works: `/plugin marketplace add /path/to/falcovd-agentic-marketplace`.

## Plugins

| Plugin | Purpose |
| --- | --- |
| `adlc-toolkit` | Assist product development in an Agentic Development Lifecycle (ADLC) way |

### adlc-toolkit

| Skill | Invoke | What it does |
| --- | --- | --- |
| `init-adlc-project` | `/adlc-toolkit:init-adlc-project` | Captures a project's tech stack, coding standards and architecture in `.adlc-project/PROJECT.md`, and adds a block to the root `AGENTS.md` that points agents to it. It detects what the code reveals, confirms it with you, and asks for the rest. It never commits. Run it again to update. |
| `product-discovery` | `/adlc-toolkit:product-discovery` | The discovery track, the step before `feature-to-spec`. Takes a vague problem to a validated feature document (`feature.md`): problem statement with falsification criteria, data evidence, a pause for your user interviews, and a verdict, with confidence thresholds you set per run. Re-invoke it after the interviews to continue. |
| `feature-to-spec` | `/adlc-toolkit:feature-to-spec` | Guides a product owner from a feature idea to a reviewed PRD and spec (what and why), with critique rounds and explicit approval at each step. It reads the `feature.md` that `product-discovery` writes. |

All files the skills write are in English, whatever language you speak. The format shared between skills is defined in `plugins/adlc-toolkit/contracts/`. See the [toolkit README](plugins/adlc-toolkit/README.md) for details.

More skills will be added to the toolkit.

## Repository layout

```
.claude-plugin/marketplace.json     marketplace catalog
plugins/<plugin>/
  .claude-plugin/plugin.json        plugin manifest
  skills/<skill>/SKILL.md           one folder per skill
  contracts/                        formats shared between skills
  tests/                            checks, fixtures and manual scenarios
  CHANGELOG.md                      version history of the plugin
scripts/check-versions.sh           checks versions and changelogs
.github/workflows/                  one workflow per check
CHANGELOG.md, VERSIONING.md         marketplace history and versioning policy
```

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json`, add skills under `plugins/<name>/skills/<skill>/SKILL.md` and start a `CHANGELOG.md`.
2. Register it in `.claude-plugin/marketplace.json`.
3. If it has tests, add a `test-<name>.yml` workflow.
4. Validate with `claude plugin validate .` and `claude plugin validate plugins/<name>/`, run its tests and run `bash scripts/check-versions.sh`.

## Contributing

The project follows git-flow: branch from `develop` as `feature/<name>` and open a PR against `develop`. Releases go through `release/<version>` and `main`. The details are in [CLAUDE.md](CLAUDE.md).

## Versions and changes

Plugins and the marketplace follow [Semantic Versioning](VERSIONING.md). Every release is recorded in a changelog: [marketplace](CHANGELOG.md) and [adlc-toolkit](plugins/adlc-toolkit/CHANGELOG.md).
