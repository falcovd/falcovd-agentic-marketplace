# Changelog

Changes to the marketplace itself (catalog, CI, repository conventions). Each plugin keeps its own changelog next to its manifest, for example [`plugins/adlc-toolkit/CHANGELOG.md`](plugins/adlc-toolkit/CHANGELOG.md). Versions follow [Semantic Versioning](VERSIONING.md).

## [Unreleased]

## [0.2.0] - 2026-10-30

### Changed
- CI is split into one workflow per check: `validate-marketplace`, `validate-plugins` and `test-<plugin>`.

### Added
- Changelogs, a versioning policy and a check that versions and changelogs stay in step.
- README and CLAUDE.md describe the contracts, tests, CI, versioning and conventions.

## [0.1.0] - 2026-10-29

### Added
- Marketplace catalog with the `adlc-toolkit` plugin.

[Unreleased]: https://github.com/falcovd/falcovd-agentic-marketplace/compare/v0.2.0...develop
[0.2.0]: https://github.com/falcovd/falcovd-agentic-marketplace/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/falcovd/falcovd-agentic-marketplace/releases/tag/v0.1.0
