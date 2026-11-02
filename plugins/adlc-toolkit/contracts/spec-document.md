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
- **IDs:** user stories are `US-n`, functional requirements `FR-n`, non-functional requirements `NFR-n`, acceptance criteria `AC-n.m`, assumptions `A-n` and open questions `OQ-n`. Numbers start at 1 and run without gaps in the first version. An ID is never reused for something else. A removed item keeps its number and is marked as removed in the change history of the spec.
- **Linking:** every functional requirement names the user story it serves. Every non-functional requirement names a user story or a goal. An acceptance criterion `AC-n.m` verifies user story `US-n`, so `n` is the story number and `m` counts within that story. Every user story has at least one acceptance criterion.
- **Acceptance criteria** are written as Given / When / Then. They are binary and testable, describe observable behaviour and not the implementation, and cover the happy path, edge cases and error states.
- **Risks** each name the requirement that addresses them, or state an explicit decision not to address them.
- **Open questions** state whether they are a product question or a technical one. Technical questions stay open for the technical plan.
- **No technical solution** in any section.
- **Unknowns:** write them as an assumption or an open question. Do not guess a number, a name or a limit.
- **Extra sections** may follow `Open Questions`. They never replace or rename a section above.
