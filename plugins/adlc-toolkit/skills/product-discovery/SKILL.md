---
name: "product-discovery"
description: "Run a structured product discovery flow from a vague problem to a validated feature document. Frames the problem, writes a problem statement with falsification criteria, gathers data evidence, pauses for the user to run interviews, then judges the evidence against a rubric and writes feature.md. Use when the user wants to explore a problem, validate a problem statement, do product discovery, or turn a problem into a feature spec. Resumable: re-invoke after the interviews to continue."
---

# Product Discovery

One flow, one breakpoint. The skill works through framing, problem statement and data evidence on its own, then stops so the user can talk to real users. When the user comes back, it judges all evidence against criteria set in advance and, if the problem holds up, writes the feature document.

## How to interact (applies to every phase)

**Ask with AskUserQuestion, not in plain text.** Every question to the user and every checkpoint goes through the AskUserQuestion tool (1 to 4 questions per call, 2 to 4 options each; the user can always type their own answer via "Other"):
- Put the recommended option first and mark it "(Recommended)".
- For open questions (such as the framing questions), infer 2 to 4 plausible answer options from what the user already said, from the project files or from connected sources, so the user can pick or correct instead of typing everything. Only when there is truly nothing to infer from, ask one short plain-text question first, then continue with AskUserQuestion.
- Use multiSelect when options are not mutually exclusive (for example which data sources to query).
- Do not ask the same thing in chat text and in the tool. Do not write a question in prose and wait for a reply when the tool can ask it.
- Only if AskUserQuestion is not available in the session (for example an unattended run), fall back to plain-text questions.

**Show files right away with SendUserFile.** Whenever the user needs to read, check or approve a file:
1. Write the file.
2. Send it immediately with SendUserFile (one call, all files for that moment together).
3. Only then ask for the approval or feedback with AskUserQuestion.

Never ask for approval of a file the user has not been shown. Do not paste the full file into the chat as a substitute, and do not tell the user to go and look in a directory. Keep the chat text to a 2 to 3 line summary of what the file contains and what you need from them.

## Working directory

All output goes in `discovery/<topic-slug>/`:

```
discovery/<topic-slug>/
  status.md
  framing.md
  problem-statement.md
  evidence/
    data/                one file per source (e.g. support-tickets.md, analytics.md)
    interviews/          one file per interview, added by the user
    interview-guide.md
    interview-overview.md   extraction table built in Phase 4
    verdict.md              (older versions kept as verdict-v1.md, verdict-v2.md, ...)
  feature.md
```

## status.md (source of truth for state)

Create it in Phase 1 and update it after every approval:

```
| Phase | Status | Approved on |
|---|---|---|
| 1 Framing | pending / approved | |
| 2 Problem statement | pending / approved | |
| 3 Data evidence | pending / done | |
| Breakpoint: interviews | waiting / received | |
| 4 Verdict | pending / approved (v1) | |
| 5 Feature document | pending / done | |
```

## Step 0: Detect state (always first)

Read `status.md` and continue at the first phase that is not approved or done. If `status.md` is missing, infer state from the files present and recreate it, telling the user what you assumed. If a file looks half-written or was edited by the user, ask (AskUserQuestion) before overwriting it. If several topics exist, ask (AskUserQuestion) which one.

Special cases:
- Interviews missing at the breakpoint: re-show the interview guide (SendUserFile) and the instructions, do not proceed.
- User wants to skip interviews: allowed. Record "no user interviews" as a limitation in `verdict.md` and cap confidence at low.
- User adds more evidence after a verdict: re-run Phase 4 and save the new verdict as the next version, keeping the old one.

## Phase 1: Frame the problem

Ask these four things in one AskUserQuestion call (one question each, options inferred as described above, "Other" for free text):

1. What problem do you want to solve?
2. Who is facing it?
3. Why is it worth solving? (impact, frequency, cost of doing nothing)
4. What evidence do you already have?

Challenge thin answers with a follow-up AskUserQuestion, at most two follow-ups in total:
- "Users" or "customers" is not a persona: ask for role, context and situation.
- "It's annoying" or "it takes long" is not an impact: ask how often, how long, how many people, and what it costs.
- A solution disguised as a problem ("we need a dashboard") is not a problem: ask what is going wrong without it.

Anything still vague after that is written down as an assumption, not as fact. Write the answers to `framing.md`. Do not suggest solutions.

**Checkpoint:** send `framing.md` with SendUserFile, then ask with AskUserQuestion: Approve / Change something (user explains via Other). Update `status.md` after approval.

## Phase 2: Problem statement

Write `problem-statement.md`. One statement per run: if several personas emerge, ask (AskUserQuestion) which one to pursue first. It is a human-centered problem narrative, not a requirements document.

Format:

> I am a [persona] trying to [goal], but [problem] because [impediment]. This makes me feel [emotion].

Then add:
- **Impact:** how often, how severe, roughly how many users (flag unknowns).
- **Assumptions to test:** every claim in the statement that is a hypothesis, especially the impediment and the emotion. Number them A1, A2, ... and mark the riskiest one.
- **Falsification criteria:** for each assumption, write down in advance what evidence would show it is wrong. Example: "A2 is contradicted if fewer than 1 in 5 relevant tickets mention the workaround" or "A3 is contradicted if most interviewees describe no frustration." Be specific and observable.

Rules:
- No solutions or feature names in the statement.
- Write from the user's perspective, in first person.

**Checkpoint:** send `problem-statement.md` with SendUserFile, then ask with AskUserQuestion: Approve statement and criteria / Change the statement / Change the criteria. These are fixed after approval: later phases judge against them and must not quietly change them. Update `status.md`.

## Phase 3: Verify with data

Goal: test the assumptions against existing data, using the falsification criteria.

1. Check which connected sources could hold relevant data (support system, CRM, analytics, issue tracker, chat). Ask with AskUserQuestion (multiSelect) which of the found sources to query, and mention any you could not find.
2. Pull what is relevant and write one file per source in `evidence/data/`. Each file contains: source, query or filter, date range, sampling method and sample size, findings per assumption (A1, A2, ...), and limitations.
3. Look for disconfirming evidence as actively as for confirming evidence, and report both.
4. Privacy: summarize, never copy personal data, customer names or full messages into files. Short anonymized quotes are fine.
5. If no source is available, ask with AskUserQuestion whether the user wants to add data files to `evidence/data/` themselves or continue without data (record that as a limitation). The user can always add their own evidence there.
6. Send the data files with SendUserFile so the user sees what was found.

Then continue straight into the breakpoint.

## BREAKPOINT: Verify with real users (human step)

The skill cannot do this step. Prepare the user, then **stop**.

1. Write `evidence/interview-guide.md`:
   - Participant profile (must match the persona from the statement) and a suggested minimum of 5 interviews.
   - 6 to 10 open, non-leading questions about past behavior and real situations, not hypotheticals ("Tell me about the last time..." rather than "Would you use...").
   - For each assumption, at least one question that could disprove it, especially those the data left untested.
   - A reminder to anonymize notes and to have consent for any recording.
   - The interview note template below.
2. Send `interview-guide.md` with SendUserFile right away.
3. Update `status.md` to "waiting".
4. End with a short message (no question, no tool call to ask anything): a summary of the data findings in 5 lines or less including gaps the interviews should close, and the instructions: run the interviews, save each one as a separate file in `evidence/interviews/`, and re-invoke this skill when done.

Do not proceed to Phase 4 in the same turn. End the turn here.

### Interview note template (include in the guide)

```
# Interview <nr>: <date>
Participant: <role, context; no name>
Matches persona: yes / partly / no (why)
Context of the conversation: <short>

## Observed behavior (what they did, not what they think)
## Verbatim quotes (exact words, with a short note on context)
## Emotions or frustration expressed
## Assumptions touched: A1 / A2 / ... (supports, contradicts or unclear)
## Surprises
```

Free-form notes from the user are also accepted; map them onto this structure in Phase 4.

## Phase 4: Verdict

1. **Extract first.** Read every interview and build `evidence/interview-overview.md`: one row per interview with columns for persona match, and for each assumption (A1, A2, ...) supports / contradicts / unclear, plus one verbatim quote and the source file. Do not judge yet.
2. **Judge against the criteria.** Use the falsification criteria from the problem statement and the rubric below.
3. Write `evidence/verdict.md` (or the next version number on a re-run).
4. Send `verdict.md` and `interview-overview.md` with SendUserFile.

Contents of `verdict.md`:
- **Verdict:** `confirmed`, `partially confirmed`, or `refuted`.
- **Per assumption:** supported / contradicted / untested, with a short reason and references to the evidence files.
- **Contradicting evidence:** listed explicitly, never omitted.
- **Triangulation:** which source types support it (data, interviews), how many interviews, and how many matched the persona.
- **Confidence:** low / medium / high per the rubric, with the reasons.
- **Recommendation:** see below.

Rules for the verdict:
- Every claim cites an evidence file. No citation, no claim.
- Quotes are verbatim and taken from the files, never paraphrased into quotation marks.
- Do not change the falsification criteria after seeing the evidence. If they turn out to be badly chosen, say so in the verdict and let the user decide.

### Confidence rubric
- **High:** at least 5 interviews matching the persona, plus data that agrees, and no significant contradicting evidence.
- **Medium:** both source types but fewer than 5 matching interviews, or notable contradicting evidence on a non-core assumption.
- **Low:** only one source type, no interviews, mostly non-matching participants, or the riskiest assumption is untested or contradicted.

### Recommendation
- **Confirmed:** continue to Phase 5.
- **Partially confirmed:** propose a revised problem statement and list what is still untested. After the user agrees, update `problem-statement.md` (keep the old version as a note) and say explicitly whether more evidence is needed or the flow can continue.
- **Refuted:** recommend stopping or reframing, and explain why.

**Checkpoint:** after the files are shown, ask with AskUserQuestion what to do, with the recommendation first: Go to the feature document / Revise the problem statement / Gather more evidence / Stop. Never write `feature.md` without an explicit go. Update `status.md`.

## Phase 5: Feature document

Write `feature.md` with:

1. **Problem statement:** who has which problem, and the evidence (link to files in `evidence/`, do not copy).
2. **Goals:** the outcomes we want. For each goal give a metric, baseline, target and timeframe (mark unknowns as "to be determined" instead of guessing).
3. **Requirements:** what must be true for the problem to be solved. Write them as outcomes or conditions, not solutions (not "a dashboard", but "a manager can see X without asking Y"). Link each requirement to the evidence or assumption that justifies it.
4. **Scope:** what is in, and explicitly what is out.
5. **Open questions, assumptions and risks.**
6. **Status:** go / no-go / needs more evidence, with date and owner.

Send `feature.md` with SendUserFile, finish with a two-sentence summary, and ask with AskUserQuestion whether it is approved or what to change. Update `status.md`.

## General rules

- One breakpoint only: after Phase 3. Every other phase ends with a file shown and a short confirmation, not a handover.
- Questions go through AskUserQuestion; files for review go through SendUserFile before the question is asked.
- Keep every file short and scannable. Evidence is referenced, never duplicated.
- Do not invent evidence, quotes or numbers. Unknown means unknown.
- Reply in the language the user writes in; keep file names and headings in English.
