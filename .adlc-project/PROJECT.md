# Project Context

## Tech Stack

- Languages: Markdown (skills, docs), JSON (manifests), Bash (checks), YAML (CI) (source: CLAUDE.md, check-init-adlc-project.sh, validate.yml)
- Frameworks: Claude Code plugin and marketplace system (source: marketplace.json, plugin.json)
- Databases: None (source: CLAUDE.md)
- Infrastructure: GitHub Actions on ubuntu runners (Node 22 for the Claude Code CLI); marketplace distributed from GitHub (source: validate.yml)

## Coding Standards

- Formatting: No formatter enforced; match the style of surrounding files (source: user)
- Linting: `claude plugin validate` on the marketplace and every plugin; static bash checks on skill files (source: validate.yml)
- Naming: kebab-case for marketplace, plugin and skill names; skill folder name matches the skill `name` (source: CLAUDE.md)
- Testing strategy: Static bash checks in CI, plus manual scenarios run against fixtures (source: check-init-adlc-project.sh)

## System Architecture

- Architecture style: Static catalog of plugins; each plugin is a self-contained directory of skills under `plugins/`, registered in `marketplace.json` (source: CLAUDE.md)
- API design: None; the interface is Claude Code slash commands such as `/adlc-toolkit:init-adlc-project` (source: user)
- State management: None; stateless, content is files in git (source: user)
