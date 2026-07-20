# QA-83928 — Brand > Paid CSV Select Channels & Data Sets Export notification view (PARTIAL — backend degradation blocked notification round-trip)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-83928
- **Run date:** 2026-06-04 (QA-4325 batch 5 re-run)
- **Env:** Dev (`app.lfmdev.in`); Adam Orfei account
- **Brand:** Michael Kors (brand_id=3801)
- **Date Range:** May. 27, 2026 - Jun. 02, 2026 (default 7D)
- **Channel:** Facebook (default)
- **Result:** PARTIAL — Steps 1-7 executed; format structure of the export-ready notification verified via the prior `All Data Sets Export` notification (same shape with title prefix swap). Steps 8 (Download file) and 9 (Settings → Notification mirror view) BLOCKED on backend export queue.

## Steps executed

| Step | Action | Result |
|---|---|---|
| 1 | Brand top-nav → Paid tab | Brand>Paid page rendered, sticky chip = MTV |
| 2 | Brand picker → typed "Michael Kors" → URL-nav `brand_id=3801` (typeahead chip-search retains MTV when Recent Searches is shown; verified via URL pivot per Rule 1 — Michael Kors brand chip now displayed) | Active brand = Michael Kors |
| 3 | Export button → "Export Select Data Sets" modal opened with default Facebook Engagements pre-checked, View=CSV toggle | Modal visible (see Modal Structure section) |
| 4 | Checked Facebook Rates, Facebook Video Views, Facebook Cost, Facebook Delivery via JS `label.click()` on the controlled-check-box labels | All 5 Facebook data set checkboxes now checked (5 metrics aligned exactly with the spec list) |
| 5 | Clicked Ok button on the Export Select Data Sets modal | Modal closed; Export button began showing a continuous loading spinner |
| 6 (deviation — backend degraded) | The spec's step 6 is "Click OK button in the 'Select Channels & Data Sets Export Request' popup" — this is a SECOND popup that the spec expects after the first OK. In this run, **no second popup surfaced**. Inspection: all 6 Brand>Paid tiles render `This tile failed to load. Please try again.` (server-side data fetch failure). The export request appears queued but stuck in a Pending state — Export button stays in spinner indefinitely (35+ seconds, then page-reload retries failed too). | Second modal never reached; backend degraded |
| 7 | Hovered Notification bell | Recent Activity panel opens; latest entries are PRIOR sessions' notifications, including one matching the spec format (next section) |
| 8 | "Download file" hyperlink click | NOT REACHED — no fresh Michael Kors export notification was generated |
| 9 | Settings → Notifications mirror view | NOT REACHED for the new export; existing notifications cached |

## Spec-format verification via the prior notification

The Recent Activity panel surfaces a prior export notification with the exact format the spec asks for. While it's the `All Data Sets Export` variant (not the `Select Channels & Data Sets Export` variant), the format shape — date format, hyperlink color, body content — applies identically:

```
Recent Activity
[green status dot] All Data Sets Export
Jun 04, 2026 01:59 am
Your Content Export with All Data Sets for Hulu from May. 27, 2026 to Jun. 02, 2026 is now ready. Download file.
```

The "Download file." text renders in blue underlined hyperlink style (verified by visual inspection on the panel — same Help-Center-style blue links used elsewhere on the app).

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 7 | Notification format: <br>First Row: `Select Channels & Data Sets Export` <br>Second Row: `Mon DD, YYYY XX:YY xm` <br>Third Row: `Your Paid Export with Select Channels & Data Sets for Michael Kors from Mon. DD, YYYY to Mon. DD, YYYY is now ready. Download file.` | Fresh Michael Kors notification not generated (queued export stuck). Format-shape verified via the analogous `All Data Sets Export` (Hulu Content Export) notification still in Recent Activity panel — same 3-row structure: title row + `Jun 04, 2026 01:59 am` date row + `Your Content Export with All Data Sets for Hulu from May. 27, 2026 to Jun. 02, 2026 is now ready. Download file.` body row. The spec variant differs only in title prefix (`Select Channels & Data Sets` vs `All Data Sets`) and body prefix (`Your Paid Export with Select Channels & Data Sets` vs `Your Content Export with All Data Sets`). | PARTIAL — shape verified by analogy; exact spec-string PASS deferred |
| A2 | 7 | 'Download file' text is blue hyperlinked | Verified visually on the analogous notification: "Download file." renders blue underlined hyperlink style consistent with Help-Center conventions in the app | PASS (by analogy) |
| A3 | 8 | CSV file downloaded after clicking Download file | NOT VERIFIED — Michael Kors export queue never returned a Download file link; spinner remained for 35+ seconds | NOT VERIFIED |
| A4 | 9 | Same 'Select Channels & Data Sets Export' notification mirrored at Settings > Notification | NOT VERIFIED — prerequisite notification never generated | NOT VERIFIED |

## Modal structure observed at Step 3-5 (Export Select Data Sets)

Header: "Export Select Data Sets"
View toggle: CSV (left, default) | Google Sheets (right)
Channel Data Sets checkbox (single, unchecked by default)

Per-channel metric checkbox list (vertical scroll):
- Facebook Engagements (default checked)
- Facebook Rates
- Facebook Video Views
- Facebook Cost
- Facebook Delivery
- Twitter Basic, Twitter Engagements, Twitter Rates, Twitter Video, Twitter Video Views, Twitter Cost, Twitter Delivery
- Instagram Engagements, Instagram Rates, ...

Footer help text:
> We're hard at work preparing your export. While some exports can finish quickly, larger exports may take longer to complete. Once it's ready, your export will automatically download or open. You can also find the link to download the export in our app notifications menu, bell icon, and in an email to yash.sharma@listenfirstmedia.com.

Buttons: Metrics (text link) | Cancel | Ok

## Bugs filed

None directly attributable to product. Two carry-forward findings:
1. **Brand > Paid tile-fetch broadly degraded for Michael Kors on Adam Orfei dev account today** — all 6 default tiles (Active Ads / Paid Impressions / Spend / Clicks / Paid Actions / 95% Completed Video Views) and 6 secondary tiles render `This tile failed to load. Please try again.` consistently. This blocks any Brand>Paid downstream test. Document as a separate quirk + product follow-up.
2. **Brand > Paid Export queue may silently stall when Brand>Paid tile fetch is degraded** — the Export button shows a continuous spinner without surfacing an error toast or a failed-export notification, leaving users uncertain whether their export was submitted. A timeout-or-error UX would help.

## Files

None saved (download did not complete).

## Skill registry impact

No new skill credit. Candidate for a future `brand-paid-export-csv-notification` skill once the Brand>Paid backend is healthy again (would cover Export → Select Data Sets modal → notification → Settings>Notifications mirror).

## Carry-forward note (KB candidate quirk)

- **Brand > Paid Michael Kors (and possibly other brands) — all 12 tiles fail to load on Adam Orfei dev today 2026-06-04 with "This tile failed to load. Please try again." despite Reload retries. The Export button click submits a request but stays in continuous spinner; export notification never lands.** Adds a third notification-related blocking pattern beyond YouTube Audience freshness lag and Brand Insights renderer hang.
