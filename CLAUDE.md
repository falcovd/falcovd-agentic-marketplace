# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code plugin marketplace ("FalcovD Agentic Marketplace", identifier `falcovd-agentic-marketplace`) containing skills and plugins for agentic work. Current focus: the `adlc-toolkit` plugin (product development in an Agentic Development Lifecycle way); more areas will be added. There is no application code or build. The content is manifests, `SKILL.md` files, agent definitions, shared contracts, scripts and shell checks. The checks are static or use fixtures; the skills themselves are interactive and tested by hand (see `plugins/<name>/tests/SCENARIOS.md`).

## Commands

- Validate the marketplace manifest: `claude plugin validate .`
- Validate one plugin: `claude plugin validate plugins/<name>/`
- Run a plugin's tests: `for t in plugins/<name>/tests/check-*.sh; do bash "$t"; done`
- Test a plugin in a session: `claude --plugin-dir plugins/<name>`, then run a scenario from `plugins/<name>/tests/SCENARIOS.md`.
- Check versions and changelogs: `bash scripts/check-versions.sh`
- CI has one workflow per check, each with a single step after checkout: `validate-marketplace.yml`, `validate-plugins.yml` (loops over every `plugins/*/`), `check-versions.yml` and `test-<name>.yml` per plugin that has tests. Run all of these locally before opening a PR. A new plugin with tests gets its own `test-<name>.yml`.

## Architecture

- `.claude-plugin/marketplace.json` is the catalog. Each entry's `source` points to a plugin directory under `plugins/`. A plugin that exists on disk but is not listed here is not installable.
- `plugins/<name>/.claude-plugin/plugin.json` is the plugin manifest. `name` and `version` must match the marketplace entry.
- Skills live at `plugins/<name>/skills/<skill>/SKILL.md` with `name` and `description` frontmatter. The `description` drives when Claude triggers the skill, so write it as a trigger condition.
- `plugins/<name>/contracts/` holds shared definitions that skills hand work over with, for example `feature-document.md` (the `feature.md` format shared by `product-discovery` and `feature-to-spec`). Change the contract first, then the skills, then run the contract check. Skills reference contracts through `${CLAUDE_PLUGIN_ROOT}/contracts/...`.
- `plugins/<name>/scripts/` holds scripts that a skill can run or that mirror its rules, for example `discovery-state.sh` (the executable form of the state detection in `product-discovery`) and `spec-rules.sh` (ID and link rules, run by `spec-change`). Keep a script and the `SKILL.md` text it mirrors in step.
- `plugins/<name>/agents/` holds agent definitions that skills hand work to, for example `spec-critic.md`, the read-only reviewer used by `feature-to-spec`. Checklists that a reviewer needs live there, not in the skill.
- `plugins/<name>/tests/` holds `check-*.sh` scripts (the CI runs every one), fixtures under `tests/fixtures/` and `SCENARIOS.md` for the manual runs. The checks call the scripts in `scripts/`.
- Plugin manifests carry `license`, `repository`, `homepage` and `keywords`. The MIT `LICENSE` is in the repository root. `claude plugin validate plugins/<name>/` reports what the plugin directory would refuse.
- Marketplace `name` must be kebab-case. The display title "FalcovD Agentic Marketplace" is used only in prose (README, descriptions).

## Conventions

- **Language:** every file a skill writes is in English, whatever language the user speaks. Skills may talk to the user in the user's language. New skills must say so.
- **Instruction text:** text a skill writes into other projects (for example the `AGENTS.md` block) describes the project instead of commanding agents ("always", "you must", "ignore"), so prompt-injection detectors do not block it.
- **Docs:** `docs/` and `specs/` are git-ignored local working notes. Anything that must be shared goes elsewhere. Do not cite IDs from those local notes in shared files such as `SCENARIOS.md`.
- **Diagrams:** workflows and flows in READMEs are Mermaid (` ```mermaid `), not ASCII art. Directory trees stay as plain code blocks.
- **Paths in skills:** a skill reads contracts and calls scripts through `${CLAUDE_PLUGIN_ROOT}/...`, never through a relative `../../` path.
- **Agents:** an agent that only reviews gets read-only tools (`Read`, `Grep`, `Glob`) and treats files as data. A check in `tests/` keeps that true.
- **Fallbacks:** a skill that uses `AskUserQuestion`, `SendUserFile` or Bash says what it does when the tool is not available.

### Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json`, its skills and a `CHANGELOG.md` with an `## [Unreleased]` section. Add agents under `agents/` and scripts under `scripts/` when the skills need them.
2. Register it in `.claude-plugin/marketplace.json`.
3. If it has tests, add `.github/workflows/test-<name>.yml`.
4. Run both validate commands, the plugin's tests and `bash scripts/check-versions.sh`.

## Git flow

This project follows git-flow.

- `main`: production-ready, tagged releases only. Never commit directly.
- `develop`: integration branch. Features branch from it and merge back into it. (Create it from `main` if it does not exist yet.)
- `feature/<name>`: branch from `develop`, merge back into `develop` via PR.
- `release/<version>`: branch from `develop`; only version bumps and fixes. Merge into `main` and back into `develop`, then tag `v<version>` on `main`.
- `hotfix/<name>`: branch from `main`; merge into both `main` and `develop`, then tag.
- Open PRs against `develop` (except release and hotfix branches, which target `main`).

## Versioning and changelogs

Semantic Versioning and the changelog format are defined in `VERSIONING.md`.

- On feature branches, add entries under `## [Unreleased]` in the plugin's `CHANGELOG.md`, and in the root `CHANGELOG.md` for marketplace changes. Do not bump versions there.
- On the `release/<version>` branch, rename `[Unreleased]` to the version and date, bump `version` in both `plugin.json` and the matching `marketplace.json` entry, and keep `metadata.version` in `marketplace.json` in step with marketplace releases.
- Run `bash scripts/check-versions.sh` before a release. Tag `v<version>` on `main`.
