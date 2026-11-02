# Contract: spec document (`spec.md`)

The spec is the handover between requirements and the technical plan. `feature-to-spec` writes it. Skills that come after it read its IDs: verification traces each acceptance criterion to evidence, a plan task names the requirements it delivers. Change the contract first, then the skill, then run `tests/check-spec-contract.sh`.

The spec says WHAT and WHY. It holds no technical solution, architecture or code.

## Format

One Markdown file, in English. The sections below appear in this order, with these exact `##` headings. A consumer finds a section by its heading. Every section is present. A section with nothing to say contains the word "None".

```markdown
# <Feature name>: Spec

## Definitions
- <term>: <the one meaning it has in this spec>.

## Goal and Success Criteria
What the feature achieves and how success is measured. Name the goals of the feature document (G-1, ...) where they apply.

## User Stories
- US-1: As a <who>, I want <what>, so that <why>.

## Functional Requirements
- FR-1: <specific, measurable behaviour>. Story: US-1.

## Non-Functional Requirements
- NFR-1: <quality with its number, for example performance, security, accessibility, privacy>. Story: US-1 or Goal: G-1.

## Acceptance Criteria
- AC-1.1: Given <state>, when <action>, then <observable result>.

## Out of Scope
- <what is deliberately not built>

## Assumptions
- A-1: <assumption>.

## Dependencies and Risks
- Dependency: <what the feature relies on>.
- Risk: <risk>. Addressed by: FR-1 | NFR-1 | Not addressed (decision: <why>).

## Open Questions
- OQ-1: <question>. Type: product | technical.
```

## Rules

- **Required parts:** User Stories, Functional Requirements, Non-Functional Requirements, Acceptance Criteria and Out of Scope carry the substance of the spec. The other sections carry over what the PRD decided.
- **IDs:** user stories are `US-n`, functional requirements `FR-n`, non-functional requirements `NFR-n`, acceptance criteria `AC-n.m`, assumptions `A-n` and open questions `OQ-n`. Numbers start at 1 and run without gaps in the first version. An ID is never reused for something else. A retired item is removed from its section and listed in the Change History; its number is never reused. A new ID is the highest number ever used for that kind, active or retired, plus 1. After version 1, gaps in the numbers are fine.
- **Linking:** every functional requirement names the user story it serves. Every non-functional requirement names a user story or a goal. An acceptance criterion `AC-n.m` verifies user story `US-n`, so `n` is the story number and `m` counts within that story. Every user story has at least one acceptance criterion.
- **Acceptance criteria** are written as Given / When / Then. They are binary and testable, describe observable behaviour and not the implementation, and cover the happy path, edge cases and error states.
- **Risks** each name the requirement that addresses them, or state an explicit decision not to address them.
- **Open questions** state whether they are a product question or a technical one. Technical questions stay open for the technical plan.
- **No technical solution** in any section.
- **Unknowns:** write them as an assumption or an open question. Do not guess a number, a name or a limit.
- **Extra sections** may follow `Open Questions`. They never replace or rename a section above. The one defined extra section is the Change History below.

## Change History (optional section)

`spec-change` adds this section after `## Open Questions` the first time a spec is changed. Version 1 is the original spec and has no entry. A spec without a Change History is valid. It is not one of the required headings above.

```text
## Change History
- v2 (2026-11-03): <one-line reason>. Added: AC-1.4. Changed: FR-2 (reworded). Retired: AC-1.2. Record: SC-1.
```

- One line per version. Versions start at 2 and ascend by one.
- **Added**, **Changed**, **Retired** and **Record** appear in this order. Added, Changed and Retired list IDs, or "None". Record is the ID of the change record in `decisions.md`.
- A criterion whose observable behaviour changes is retired and replaced by a new one, so evidence for the old behaviour never counts for the new one. Pure rewording keeps the ID and is listed under Changed.
- Retiring a user story retires its acceptance criteria. Its requirements are relinked to another story or retired.
- Every user story keeps at least one acceptance criterion, and every link names a story that exists.

## Change record (`decisions.md`)

`spec-change` appends one record to `decisions.md` for each change, next to the decisions `feature-to-spec` logged.

```text
## SC-1: <title> (spec v2, 2026-11-03)
Change: <summary of the change set>
Reason: <reason; "no reason given" is allowed>
Approved by: <name or role> on <date>
Impact: <plan, tests, verification: file:line and IDs, or "none found">
```

Record IDs are `SC-n`, start at 1 and are never reused.
