# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code plugin marketplace ("FalcovD Agentic Marketplace", identifier `falcovd-agentic-marketplace`) containing skills and plugins for agentic work. Current focus: the `adlc-toolkit` plugin (product development in an Agentic Development Lifecycle way); more areas will be added. There is no application code, build, or test suite. The content is manifests and `SKILL.md` files.

## Commands

- Validate the marketplace manifest: `claude plugin validate .`
- Validate one plugin: `claude plugin validate plugins/<name>/`
- Run a plugin's tests: `for t in plugins/<name>/tests/check-*.sh; do bash "$t"; done`
- CI has one workflow per check, each with a single step after checkout: `validate-marketplace.yml`, `validate-plugins.yml` (loops over every `plugins/*/`) and `test-<name>.yml` per plugin that has tests. Run these locally before opening a PR. A new plugin with tests gets its own `test-<name>.yml`.

## Architecture

- `.claude-plugin/marketplace.json` is the catalog. Each entry's `source` points to a plugin directory under `plugins/`. A plugin that exists on disk but is not listed here is not installable.
- `plugins/<name>/.claude-plugin/plugin.json` is the plugin manifest. `name` and `version` must match the marketplace entry.
- Skills live at `plugins/<name>/skills/<skill>/SKILL.md` with `name` and `description` frontmatter. The `description` drives when Claude triggers the skill, so write it as a trigger condition.
- Marketplace `name` must be kebab-case. The display title "FalcovD Agentic Marketplace" is used only in prose (README, descriptions).

### Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` and its skills.
2. Register it in `.claude-plugin/marketplace.json`.
3. Run both validate commands.

## Git flow

This project follows git-flow.

- `main`: production-ready, tagged releases only. Never commit directly.
- `develop`: integration branch. Features branch from it and merge back into it. (Create it from `main` if it does not exist yet.)
- `feature/<name>`: branch from `develop`, merge back into `develop` via PR.
- `release/<version>`: branch from `develop`; only version bumps and fixes. Merge into `main` and back into `develop`, then tag `v<version>` on `main`.
- `hotfix/<name>`: branch from `main`; merge into both `main` and `develop`, then tag.
- Open PRs against `develop` (except release and hotfix branches, which target `main`).
- Versioning follows SemVer and every change is recorded in a changelog: see `VERSIONING.md`. Add entries under `## [Unreleased]` in the plugin's `CHANGELOG.md` (and the root `CHANGELOG.md` for marketplace changes) on feature branches. Run `bash scripts/check-versions.sh` before a release.
- Bump `version` in both `plugin.json` and the matching `marketplace.json` entry when a plugin changes in a release, and keep `metadata.version` in `marketplace.json` in step with marketplace releases.
