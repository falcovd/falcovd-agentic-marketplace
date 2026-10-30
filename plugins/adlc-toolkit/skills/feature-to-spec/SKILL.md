---
name: "feature-to-spec"
description: "Turn a feature idea or feature document into a reviewed PRD and a spec (WHAT and WHY) with critique rounds and Product Owner approval. Use for PRDs, specs, user stories or scoping a feature."
---

# Feature to spec

Guide a Product Owner (PO) in one flow from a feature document to an approved PRD, and from there to a spec. The PO decides; you propose, question and check.

Use this skill whenever the PO wants to scope a feature, write or improve a PRD, write user stories or acceptance criteria, or hand a feature to engineering, even if they do not name the artefacts.

## Principles

- **The PO decides.** Never move to the next phase without an explicit approval. A bare "ok" on a long text is not approval of its content, so the PO must see the document before approving it (see "Presenting documents for approval").
- **Do not invent facts.** What cannot be derived from the input or from the PO's answers is written down as an assumption or an open question. An agent that fills gaps with guesses produces specs that look complete and are wrong. Numbers, limits and names come from the PO; you may propose options, the PO chooses.
- **Ask before you leave something open.** An open question that the PO can answer is a missed question. Ask it (see "Resolving open questions") instead of parking it in the document.
- **The spec is WHAT and WHY.** No technical solution, architecture or code. Those belong to the technical plan, which is a later step with its own review. This follows the GitHub Spec Kit terms: spec = what and why, plan = technical how, tasks = deliverables.
- **Output is always in English,** whatever language the PO writes in. You may talk to the PO in their own language, but every file you write is in English.
- **Stay in the feature.** Do not mention development tooling, commands or process steps in the documents. They are about the feature only.
- **Record decisions in the documents first.** Whenever the PO decides something, update the document (and the decision log) before you ask a reviewer to check it. A reviewer that only sees the document will otherwise flag the PO's own decisions as invented.

## How to ask the PO questions

Ask questions with the AskUserQuestion tool, not as plain text in the chat. Structured questions are faster to answer, keep the flow moving and leave a clear record of each choice.

- Offer 2 to 4 concrete options per question, based on what you already know. Put your recommended option first and mark it "(Recommended)". The PO can always type their own answer through "Other", so options are prompts, not limits.
- Keep each question to one decision. You may send up to 4 related questions in one call when they do not depend on each other. If an answer changes the next question, ask them in separate calls.
- For open questions (for example "what is the problem?") still use the tool: offer likely directions as options, and expect the PO to use "Other" to describe it in their own words. Then reflect the answer back in one sentence before you continue.
- Use it for every gate and every choice: approving a phase, accepting, rejecting or parking a finding, and picking where to save.
- **Exception:** when you need the PO to supply text or a document (a pasted report, an existing feature document, a long description), ask in plain text. A multiple-choice question is the wrong shape for that.
- If the tool is not available in this session, ask the same question in plain text, one at a time.

## Presenting documents for approval

Every time the PO has to approve a document, show the document first, then ask for approval.

1. Write or update the file(s) to be approved: the feature document, the PRD or the spec, and the decision log.
2. Present them. If the session can send files (for example the SendUserFile tool), send the files that need approval, so the PO can open and read them. If it cannot, show the full content in the chat. Do this even when only part changed; the PO approves the whole document, not the change.
3. Say in one or two sentences what changed since the last version and what is still open.
4. Only then ask for approval with AskUserQuestion.

Do this at every gate: the feature document before and after critique rounds, the PRD, and the spec. The files may live in a cloud workspace the PO cannot see, so never assume the PO can open them from a folder. Never ask for approval of a document the PO has not been shown.

## Resolving open questions

Before the PO approves the PRD, and again before the PO approves the spec, go through the open questions and ask the PO about every one that is a product decision.

1. Sort the open questions. Product decisions (who is responsible, how long, what is logged, whether someone is notified, which time window) are asked now. Technical questions (how something is built, which tool is chosen) stay open for the technical plan and the team; say so.
2. Ask the product decisions with AskUserQuestion, up to 4 per call, with options you propose and a "Decide later" option. Group related questions.
3. Write each answer into the document at the place it belongs (a requirement, an acceptance criterion, a user story) and remove the question from the open list. Log the answer in the decision log.
4. Leave a question open only when the PO answers "Decide later", or when it is technical. List what stays open at the end of the document and in your summary.

## Phase 0: Intake

1. Ask for the feature document. It should follow the shared contract in `../../contracts/feature-document.md`: Problem Statement, Goals, Requirements, Scope and Out of Scope are required. A `feature.md` from `product-discovery` already does. Check the headings and say which required sections are missing.
2. If there is none, or required sections are missing, interview the PO to fill those five sections, starting with the problem and how the PO knows it exists. If the PO has a source document (for example a test or audit report), ask for the relevant text in plain text and build the document from that. The facts in such a source can change the whole feature: after reading it, say how the framing changed and let the PO confirm before you continue.
3. Write the result down and let the PO confirm it (see "Presenting documents for approval").
4. Choose the folder name only after the problem is clear, so it describes the feature (for example `specs/<feature-name>/`). Ask where the output should go; default to `specs/<feature-name>/` in the working directory. If you are in a cloud session, also tell the PO that the files are not on their computer and send them as files at each gate; ask whether to copy them to a folder on the PO's computer when that is possible.
5. Never write to Jira, Confluence or any other system unless the PO asks for it in this conversation.

## Phase 1: Devil's advocate rounds on the feature document

Goal: sharpen the feature document before it becomes a PRD.

1. Run the critique in a separate subagent with a clean context. Give it the feature document, the checklist below and, from round 2 on, the list of findings the PO already decided on (accepted, rejected, parked), with the instruction not to repeat those and to look only for new weaknesses and contradictions. A reviewer that sees the reasoning behind the document tends to agree with it, so do not give it this conversation.
2. Instruct the subagent to play devil's advocate: look for weaknesses, not confirmation. For each finding it gives the problem, why it matters, and a class: **Must**, **Should** or **Could**.
3. Checklist:
   - Is the problem evidenced (who has it, how often, how do we know)?
   - Are the goals measurable and not just a restatement of the solution?
   - Is every requirement unambiguous, readable in one way only?
   - Which assumptions are unspoken?
   - Is the scope bounded, and does it say what is explicitly out?
   - Which dependencies and risks are missing?
   - Compliance: does the feature touch personal data (for example employee, health, financial or other sensitive data under the GDPR), automated decisions about people, or AI functionality? If so, flag the GDPR and, where AI is involved, the EU AI Act (check its high-risk categories, such as employment and worker management) as points of attention. This is a flag, not a legal opinion.
4. Present the findings to the PO, summarised and grouped so they can be handled in few calls. For each finding the PO chooses: accept, reject with a reason, or park as an open question. Update the document and the decision log for each decision straight away. If the PO rejects a compliance flag, respect that and log it; do not argue again.
5. Stop the critique when no Must findings are open and the PO approves, or when a round brings no new Must findings (the rest is repetition), with a maximum of 3 rounds. After round 3 the PO decides how to continue; do not start a fourth round on your own.
6. Keep a decision log: finding, decision, reason ("no reason given" is a valid entry).
7. Present the updated feature document and the log for approval before moving on.

## Phase 2: PRD

1. Convert the approved feature document into a PRD with these sections: Summary, Problem, Users, Goals and success metrics, Non-goals, Requirements (functional and non-functional), Scope and out of scope, Assumptions, Dependencies and risks (including compliance), Open questions. Trace each requirement to a goal.
2. Check it with a separate clean-context subagent that reads the feature document and the PRD: does every requirement trace to a goal, is anything in the PRD that was not in the feature document without being marked as an assumption or open question, is anything missing, and is anything contradictory?
3. Process the findings: fix editorial and mechanical issues yourself and tell the PO; ask the PO about anything that needs a decision.
4. Resolve the open questions (see "Resolving open questions").
5. Present the PRD for approval. Repeat until the PO approves, with a maximum of 3 rounds.

## Phase 3: Spec

Write the spec from the approved PRD. It always has these five parts, because the PO approves something concrete and verification later needs criteria to check against:

1. **User stories:** who benefits and how, from the user's perspective. Number them US-1, US-2, and so on.
2. **Functional requirements:** what the system must do, as specific and measurable behaviour. FR-1, FR-2, and so on, each linked to a user story.
3. **Non-functional requirements:** performance, security, accessibility, scalability, reliability, privacy. NFR-1, NFR-2, and so on. Agents deliver what is specified and nothing else, so ask the PO actively about what is not yet written down, offer options for each, and let the PO choose the numbers. Put what the PO decides in the PRD as well, so the PRD stays the source.
4. **Acceptance criteria in Given / When / Then:** binary, testable and complete. Cover the happy path, edge cases and error states. Describe observable behaviour, not the implementation. Number them AC-1.1, AC-1.2, and so on, linked to a user story.
5. **Explicit out of scope:** what is deliberately not built, to prevent scope creep.

Also carry over from the PRD: the goal and success criteria, the assumptions, the dependencies and risks, and the open questions. Define terms that can be read in two ways at the top of the spec.

Check the spec with a separate clean-context subagent that reads the PRD and the spec, against this checklist:
- Are all five parts present?
- Does every user story have at least one acceptance criterion, and every requirement a user story or goal?
- Is every acceptance criterion binary and testable?
- Is there no technical solution in it?
- Are there terms that can be read in two ways?
- Does every risk in the PRD map to a requirement or an explicit decision not to address it?
- Is anything in the spec that is not in the PRD without being marked as an assumption or open question?

Process the findings as in Phase 2, resolve the open questions again (see "Resolving open questions"), then present the spec for approval. Repeat until the PO approves, with a maximum of 3 rounds.

## Output

Save to the chosen folder:
- `feature.md`: the final feature document, in the format of `../../contracts/feature-document.md`
- `prd.md`
- `spec.md`
- `decisions.md`: all findings and decisions with reasons

End with a short summary for the PO: what is in the spec, what is still open and why (technical, or decided for later), and that the spec is now ready for refinement with the team. Send the final files (or show them) one last time. Approving the scope happens after that refinement and is the PO's decision, not yours.

## What you do not do

- Do not continue without the PO's approval of a document the PO has been shown.
- Do not put technical choices or code in the spec.
- Do not send anything to external systems unless the PO asks for it.
- Do not fill gaps with invented facts.
- Do not argue again with a finding the PO has already decided on.
- Do not leave a product decision open that you could have asked the PO.