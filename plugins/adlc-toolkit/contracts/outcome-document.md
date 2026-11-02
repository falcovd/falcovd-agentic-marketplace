# Contract: outcome review document (`outcome-review-vN.md`)

The outcome review compares the goals of a feature with what was measured after release. `outcome-review` writes it. People read it to decide whether to close the feature, adjust it, start a new discovery round or wait. Change the contract first, then the skill, then run `tests/check-outcome-contract.sh`.

The document is based on `feature.md` as defined in `contracts/feature-document.md`. It uses the goal IDs of that document (`G-n`) and never invents or renumbers them.

## Format

One Markdown file per run, in English, saved next to `feature.md` as `outcome-review-v1.md`, `outcome-review-v2.md` and so on. An earlier version is never changed or deleted. The sections below appear in this order, with these exact `##` headings. A consumer finds a section by its heading.

```markdown
# <Feature name>: Outcome Review v<N>

## Summary
Overall: achieved | partly achieved | not achieved | inconclusive
Feature: <path to feature.md>. Date: <YYYY-MM-DD>.

## Goals
| Goal | Metric | Baseline | Target | Measured | Status | Source |
| --- | --- | --- | --- | --- | --- | --- |
| G-1 | weekly active users | 10 | 20 | 18 | partially met | analytics export, 2026-10-30 |

## Findings
- <G-n>: <what the data shows>. Source: <where>. Period: <period>. Sample: <size>.

## Limits
- <what the data cannot show>

## Recommendation
<close | adjust | new discovery | wait>: <reason>. The person decides.

## Findings for Discovery
- <what was learned and which goals missed, with evidence>

## Changes Since Previous Version
- <G-n>: <old status> to <new status>.
```

## Rules

- **Status** of a goal is one of `met`, `partially met`, `missed`, `not measurable` or `too early`. Met means the measured value reaches the target. The direction is the direction from baseline to target, so a goal that should go down works the same way. Partially met means the value moved from the baseline toward the target but did not reach it, and needs a baseline. Missed means no improvement, or worse than the baseline. Not measurable means the metric or target is missing, no value was supplied, or there is no baseline and the target is not reached, so partial progress cannot be judged. Too early means the timeframe is not over.
- **Direction without a baseline:** when the baseline is unknown, the person says which way is better. With that, `met` can be shown; `partially met` cannot.
- **Overall verdict:** `achieved` when every goal is met. `inconclusive` when no goal can be reviewed, or when every goal that can be reviewed is met but some goals could not be reviewed. `not achieved` when at least one goal can be reviewed and none is met or partially met. Otherwise `partly achieved`.
- **Recommendation:** `achieved` gives `close`, `partly achieved` gives `adjust`, `not achieved` gives `new discovery` and `inconclusive` gives `wait`. The skill proposes; the person decides.
- **Measured values** each have a source, a date or period and a sample size where it applies. Unknown stays unknown. Never invent a number.
- **Limits** list what the data cannot show: other changes in the same period, small samples, a missing baseline, values that were not confirmed, goals that could not be reviewed. A met target shows that the goal was reached, not that the feature caused it, and Limits says so. Write "None" only when there are none.
- **Findings** hold one entry per goal. **Findings for Discovery** holds what was learned when the recommendation is `new discovery` and "None" otherwise. **Changes Since Previous Version** is present from version 2 on.
- **No secrets or personal data** from the measured data are copied into the document.
- **Extra sections** may follow `Changes Since Previous Version`. They never replace or rename a section above.
