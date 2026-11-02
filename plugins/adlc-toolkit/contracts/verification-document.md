# Contract: verification document (`verification-vN.md`)

The verification document is the result of checking an implementation against its spec. `verify-against-spec` writes it. People and later skills read it to see which acceptance criteria are met and how well that is shown. Change the contract first, then the skill, then run `tests/check-verification-contract.sh`.

The document is based on `spec.md` as defined in `contracts/spec-document.md`. It uses the IDs of that spec and never invents or renumbers them.

## Format

One Markdown file per run, in English, saved next to `spec.md` as `verification-v1.md`, `verification-v2.md` and so on. An earlier version is never changed or deleted. The sections below appear in this order, with these exact `##` headings. A consumer finds a section by its heading.

```markdown
# <Feature name>: Verification v<N>

## Summary
Verdict: verified | partial | failed | unverified
Spec: <path to spec.md>. Date: <YYYY-MM-DD>. Tests: run | not run.

## Limits
- <what could not be checked>

## Stories
| Story | Verdict | Covered / total |
| --- | --- | --- |
| US-1 | verified | 3 / 3 |

## Traceability
| AC | Story | Requirements | Status | Evidence | Link | Test |
| --- | --- | --- | --- | --- | --- | --- |
| AC-1.1 | US-1 | FR-1, NFR-2 | covered | tests/a.test.ts:14 | id | pass |

## Findings
- <AC id>: <what is missing or what contradicts the criterion>. Evidence: <file:line>.

## Changes Since Previous Version
- <AC id>: <old status> to <new status>.
```

## Rules

- **Status** of a criterion is one of `covered`, `uncovered`, `deviating` or `not verifiable`. Covered means evidence was found and, when tests ran, passes. Uncovered means no evidence. Deviating means the evidence contradicts the criterion or the linked test fails. Not verifiable means it needs a manual or production check, which is stated as a limit.
- **Link** is one of `id` (the evidence names the AC ID), `inferred-confirmed` (matched by meaning and confirmed by the user), `inferred-unconfirmed` (matched by meaning, not confirmed) or `none`. An `inferred-unconfirmed` link never counts as covered.
- **Test** is one of `pass`, `fail`, `not run` or `n/a`.
- **Evidence** is a `file:line` reference. A claim has evidence. An uncovered or not verifiable criterion carries a reason in Findings or Limits instead. Never invent evidence.
- **Story verdict:** `verified` when every criterion of the story is covered, `failed` when any is deviating, `unverified` when none is covered, otherwise `partial`.
- **Overall verdict** is the worst story verdict, in this order from worst to best: `failed`, `unverified`, `partial`, `verified`.
- **Limits** list what could not be checked: tests not run, criteria that are not verifiable, links that are not confirmed. Write "None" only when there are none.
- **Findings** hold one entry per uncovered or deviating criterion. **Changes Since Previous Version** is present from version 2 on.
- **Requirements** in the traceability table are the functional and non-functional requirements that name the story of the criterion.
- **No secrets or personal data** from the evidence are copied into the document.
- **Extra sections** may follow `Changes Since Previous Version`. They never replace or rename a section above.
