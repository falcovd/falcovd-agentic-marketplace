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

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` and add skills under `plugins/<name>/skills/<skill>/SKILL.md`.
2. Register it in `.claude-plugin/marketplace.json`.
3. Validate with `claude plugin validate .`.
