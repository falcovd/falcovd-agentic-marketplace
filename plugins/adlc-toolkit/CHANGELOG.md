# Changelog

All notable changes to `adlc-toolkit` are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the plugin follows [Semantic Versioning](../../VERSIONING.md).

## [Unreleased]

### Added
- `adlc-status` skill: a read-only overview of where each feature stands in the chain. Per discovery topic and spec folder it reports the stage, the last approved step, what is waiting for a person and the next skill to run. It reuses the state detection of `product-discovery` and writes no file.
- `check-adlc-status.sh` with a reference script (`adlc-status.sh`) and fixtures for every stage and every outcome recommendation. `discovery-state.sh` takes an optional topic argument.
- `spec-to-plan` skill: gives the user a ready-to-copy prompt to continue with `superpowers:writing-plans`, built from `spec.md` and, if it exists, `.adlc-project/PROJECT.md`. The prompt lists the constraints, the open technical questions and the IDs, asks that every plan task names the IDs it delivers, and is self-contained so another developer can use it. It writes no file.
- Prompt template `skills/spec-to-plan/templates/plan-prompt.md` with `check-spec-to-plan.sh`, a reference script (`plan-prompt.sh`) and fixtures.
- `spec-change` skill: handles a change to an approved spec during implementation. It proposes and checks the change set, reports the impact on plan, tests and verification, and after approval updates `spec.md` with a Change History entry and records the decision in `decisions.md`.
- Optional `## Change History` section and a change record format (`SC-n`) in the spec contract, with `check-spec-change.sh`, a reference rules script (`spec-rules.sh`) and fixtures for added, changed and removed criteria.
- `outcome-review` skill: compares the goals of `feature.md` with what was measured after release, per goal, and writes a versioned `outcome-review-vN.md` with sources, limits, an overall verdict and a recommendation (close, adjust, new discovery or wait).
- Shared contract for the outcome review in `contracts/outcome-document.md`, with `check-outcome-contract.sh`, a reference status script and fixtures for met, partially met, missed, not measurable and too early goals.
- `verify-against-spec` skill: checks an implemented project against `spec.md`, per acceptance criterion, and writes a versioned `verification-vN.md` with `file:line` evidence, a verdict per user story and the limits.
- Shared contract for the verification report in `contracts/verification-document.md`, with `check-verification-contract.sh`, a reference status script and fixtures for covered, uncovered, deviating and not verifiable criteria.
- Shared contract for `spec.md` in `contracts/spec-document.md`: fixed headings, ID formats (`US-n`, `FR-n`, `NFR-n`, `AC-n.m`) and linking rules.
- `check-spec-contract.sh`: reads the headings from the contract and fails when `feature-to-spec` no longer names one of them.

### Changed
- The spec contract now says that a retired item is removed from its section and listed in the Change History, and that a new ID is the highest number ever used plus 1. The ten required headings are unchanged.
- `feature-to-spec` reads the spec contract before writing `spec.md` and may not deviate from it except by changing the contract first.

## [0.2.0] - 2026-10-30

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

[Unreleased]: https://github.com/falcovd/falcovd-agentic-marketplace/compare/v0.2.0...develop
[0.2.0]: https://github.com/falcovd/falcovd-agentic-marketplace/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/falcovd/falcovd-agentic-marketplace/releases/tag/v0.1.0
