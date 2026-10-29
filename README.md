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
| `init-adlc-project` | `/adlc-toolkit:init-adlc-project` | Captures a project's tech stack, coding standards and architecture in `.adlc-project/PROJECT.md`, and adds a block to the root `AGENTS.md` that tells agents to read it. It detects what the code reveals, confirms it with you, and asks for the rest. It never commits. Run it again to update. |
| `feature-to-spec` | `/adlc-toolkit:feature-to-spec` | Guides a product owner from a feature idea to a reviewed PRD and spec (what and why), with critique rounds and explicit approval at each step. |

More skills will be added to the toolkit.

## Repository layout

```
.claude-plugin/marketplace.json     marketplace catalog
plugins/<plugin>/
  .claude-plugin/plugin.json        plugin manifest
  skills/<skill>/SKILL.md           one folder per skill
  tests/                            checks for the plugin's skills
```

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` and add skills under `plugins/<name>/skills/<skill>/SKILL.md`.
2. Register it in `.claude-plugin/marketplace.json`.
3. Validate with `claude plugin validate .`.
