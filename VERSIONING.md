# Versioning policy

Marketplace and plugins use [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`). Users rely on these plugins to guide how they work, so a version number must say what changed for them. Every release has a changelog entry.

## What counts as a change for users

For a plugin made of skills, the public interface is:

- the skill names and the commands they are invoked with;
- the files a skill reads and writes, and their format (for example `feature.md` as defined in `contracts/`);
- the questions, approvals and breakpoints a skill puts a person through.

## Bumping

| Bump | When | Examples |
|---|---|---|
| MAJOR | A change that breaks existing users or projects | A skill is renamed or removed. A contract or output format changes so that earlier files no longer work. A phase is removed from a flow. |
| MINOR | New capability that keeps everything working | A new skill. A new optional step, setting or section. |
| PATCH | Fixes that change no interface | Wording fixes, clearer instructions, bug fixes, test and CI changes that touch no skill behaviour. |

While the major version is `0`, breaking changes bump MINOR instead of MAJOR, and the changelog marks them **Breaking**. `1.0.0` is the first version we promise stability for.

## Rules

- The plugin version lives in two places that must match: `plugins/<name>/.claude-plugin/plugin.json` and the plugin's entry in `.claude-plugin/marketplace.json`.
- `metadata.version` in `marketplace.json` is the marketplace's own version. Bump it for catalog changes and in step with releases that add, remove or rename a plugin.
- Each plugin has a `CHANGELOG.md` and the marketplace has a root `CHANGELOG.md`, both in [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format. Entries go under `## [Unreleased]` while work is on a feature branch. Use the headings Added, Changed, Deprecated, Removed, Fixed, Security.
- Do not bump versions on feature branches. Bump them on the `release/<version>` branch (see the git flow in `CLAUDE.md`): rename `[Unreleased]` to the version and date, set the versions in both manifests, then merge into `main` and tag `v<version>`.
- Never edit a released changelog entry except to fix a factual error. Never reuse or move a tag.

`scripts/check-versions.sh` checks that the versions are valid, that the two places match and that the current version of the marketplace and of each plugin has a changelog entry. It runs in CI.
