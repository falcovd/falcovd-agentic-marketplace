Write the implementation plan for {{FEATURE}}. Use superpowers:writing-plans if it is available; otherwise write the plan to the same rules.

This prompt is self-contained and can be used by anyone, in any session. All paths are relative to the repository root.

Read first:
- {{SPEC_PATH}} (spec v{{VERSION}}): what to build. Do not change it. If it is wrong or unclear, stop and ask.
{{PROJECT_READ}}

Constraints from the project context:
{{CONSTRAINTS}}

Open points in the project context (TBD, settle or ask):
{{PROJECT_GAPS}}

Technical questions the spec left for the plan (settle each one):
{{TECHNICAL_QUESTIONS}}

The spec has these IDs (user stories {{COUNT_US}}, functional requirements {{COUNT_FR}}, non-functional requirements {{COUNT_NFR}}, acceptance criteria {{COUNT_AC}}):
{{IDS}}

Rules for the plan:
- Every task names the US, FR, NFR and AC IDs it delivers.
- End the plan with a coverage table: every FR, NFR and AC ID and the task that delivers it. An ID without a task is a gap: flag it.
- Add no behaviour that is not in the spec. Technical choices follow the constraints above.
- Save the plan where the project keeps plans (docs/plans/ by default).
