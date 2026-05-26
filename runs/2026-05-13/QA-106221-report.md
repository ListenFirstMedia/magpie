# QA-106221 — Settings > Custom Data Sets - Edit functionality

> **Status:** ⛔ NOT EXECUTED — precondition mismatch with QA-106218
> **Run date:** 2026-05-13 · **Env:** dev · **Account:** Adam Orfei

## Why not executed

The case requires a Custom Data Set with a **specific initial metrics order** ending in "Impressions" at position 7 (per step 5 "Delete the #7th metric (Impressions)") and a specific final order after the edit ("Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate, Views"). This implies an initial order roughly like `[Reactions, Response Rate, Comments, Shares, Engagement Rate, Engagements, Impressions]`, established by QA-106218.

Surveying Adam Orfei's 6 existing custom data sets, none matches that initial state:

| Data Set | Current Metrics | Has Impressions @ #7? |
|----------|-----------------|:---------------------:|
| Main Test 1 | Engagements, Impressions, Video Views, Saves, Shares, Shares | ❌ (Impressions at #2) |
| Some new data set name | Likes, Shares, Shares, Reactions, Engagements | ❌ (no Impressions) |
| Test | Reactions, Comments, Reactions, Comments | ❌ |
| Test 3 Dupes | Engagements, Reactions, Comments, Shares, Engagements, Reactions, Comments | ❌ |
| performance test | Engagements, Impressions, Engagement Rate, Video Views, Video Response Rate, Clicks, Plays | ❌ (Impressions at #2) |
| performance test 2 | Reactions, Comments, Engaged User Rate, Watch Time (Minutes), Shares, Completed Views, Likes | ❌ |

Running the case against a non-matching data set would invalidate the per-assertion expected values. Per the architecture's accuracy-first principle, we don't fudge assertions to "look like" they pass.

## What would unblock this case

Run QA-106218 first to create the canonical starting data set. Then QA-106221 can run against it.

Alternatively, the test case should be rewritten to be self-contained (create its own starting data set in step 0).

## Automation note

Jira flags this case as **"Not Recommended"** for automation, primarily because of step 4 (drag-and-drop). The skill `custom-data-set-edit` (drafted but not exercised this run) documents two fallback strategies for the drag step:
1. Programmatic DnD via dispatched `dragstart`/`dragover`/`drop` MouseEvents.
2. If the row exposes a context menu with "Move Up" / "Move Down", use that instead.

## Recommendation

- Mark QA-106218 as a hard prerequisite in the test execution order.
- Either run QA-106218 manually before QA-106221, or rewrite QA-106221 to create its own starting state.
