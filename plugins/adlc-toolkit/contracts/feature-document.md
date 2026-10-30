# Contract: feature document (`feature.md`)

The feature document is the handover between discovery and requirements. `product-discovery` writes it. `feature-to-spec` reads it at intake and writes the final version at the end of its flow. Both skills follow this contract. Change the contract first, then the skills, then run `tests/check-feature-contract.sh`.

## Format

One Markdown file, in English. The sections below appear in this order, with these exact `##` headings. A consumer finds a section by its heading.

```markdown
# <Feature name>

## Problem Statement
Who has which problem, and how we know. Link to evidence files; do not copy them.

## Goals
- G-1: <outcome>. Metric: <metric>. Baseline: <value>. Target: <value>. Timeframe: <period>.

## Requirements
- R-1: <outcome or condition, not a solution>. Goal: G-1. Evidence: <link or assumption id>.

## Scope
What is in.

## Out of Scope
What is explicitly not included.

## Open Questions, Assumptions and Risks
- Open questions, assumptions (A-1, ...) and risks.

## Status
Decision: go | no-go | needs more evidence. Date: <YYYY-MM-DD>. Owner: <name>.
```

## Rules

- **Required for the handover:** Problem Statement, Goals, Requirements, Scope and Out of Scope. A feature document without these is incomplete, and `feature-to-spec` fills the gaps by interviewing the PO.
- **Optional for the handover:** Open Questions, Assumptions and Risks, and Status. `product-discovery` always writes them. A document written by hand may leave them out.
- **IDs:** goals are `G-n`, requirements are `R-n`. Every requirement names the goal it serves. IDs are never reused.
- **Unknowns:** write "to be determined". Do not guess a number, a name or a limit.
- **Requirements** are outcomes or conditions, never solutions.
- **Status values** are exactly `go`, `no-go` or `needs more evidence`.
- **Extra sections** may follow `Status`. They never replace or rename a section above.
