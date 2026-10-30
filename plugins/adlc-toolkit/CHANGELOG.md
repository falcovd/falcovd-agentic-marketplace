# Changelog

All notable changes to `adlc-toolkit` are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the plugin follows [Semantic Versioning](../../VERSIONING.md).

## [Unreleased]

### Added
- `product-discovery` skill: takes a vague problem to a validated `feature.md`, with falsification criteria, data evidence, an interview breakpoint and a confidence rubric.
- Confidence thresholds (interviews, source types) are set at the start of a discovery run and stored in `status.md`.
- Shared contract for `feature.md` in `contracts/feature-document.md`, used by `product-discovery` and `feature-to-spec`. Both skills read it before writing or accepting `feature.md` and may not deviate from it except by changing the contract first.
- Tests: `check-feature-contract.sh` and `check-discovery-state.sh`, with fixtures for every `product-discovery` resume point.

### Changed
- All files written by the skills are in English, whatever language the user speaks.
- `product-discovery` Step 0 (state detection) is now a documented decision order with a resume table.
- `init-adlc-project` no longer has literal HTML comment markers or a quoted injection phrase in running text. The markers are defined once in a code block, and an invalid `AGENTS.md` block is described as a validation rule. Behaviour is unchanged.
- The `AGENTS.md` block from `init-adlc-project` is reworded as a description of the project context instead of an instruction to agents.

## [0.1.0] - 2026-10-29

### Added
- `init-adlc-project` skill: captures tech stack, coding standards and architecture in `.adlc-project/PROJECT.md` and adds a block to `AGENTS.md`.
- `feature-to-spec` skill: turns a feature document into a reviewed PRD and spec, with critique rounds and Product Owner approval.

[Unreleased]: https://github.com/falcovd/falcovd-agentic-marketplace/compare/v0.1.0...develop
[0.1.0]: https://github.com/falcovd/falcovd-agentic-marketplace/releases/tag/v0.1.0
