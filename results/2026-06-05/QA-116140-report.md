# QA-116140 — Brand Sentiment - Sentiment Export CTA

- **Date:** 2026-06-08 (batch 8/12 QA-22296)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (URL brand_id reported as 10765 post-channel-apply but header shows "MTV" with logo — accepted Brand>Content known URL-drift quirk)
- **Date Range:** Jan. 01, 2026 - Jun. 06, 2026 (Lifetime mode)
- **Perspective:** Public Data (default)
- **Channels:** Twitter (effective after Apply — only one with sentiment data baseline)
- **Result:** PASS

## Steps executed

1. Navigated to Brand>Content for MTV via URL (`brand_id=4018` initial; effective URL post-load shows `brand_id=10765` with MTV header and logo).
2. Confirmed baseline UI: Sentiment button present, Sentiment Export button NOT visible (Sentiment Export was absent from the rendered button list — verified via JS button-text enumeration).
3. Clicked Sentiment button.
4. Sentiment mode rendered: Classification donut (37% Positive / 51% Neutral / 12% Negative) + Classification (Daily) area chart. Sentiment Export button rendered to the right of Sentiment in the button row.
5. Clicked Sentiment Export button at coord (740, 301).
6. Sentiment Export modal opened with body text containing the spec sentence.
7. Clicked Cancel.
8. Verified modal closed via DOM probe (`modalGone: true`).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Sentiment Export button appears only when Sentiment is enabled | Pre-Sentiment-click: button absent (JS enum). Post-Sentiment-click: button visible | PASS |
| A2 | 3 | Sentiment Export button appears to the right of the Sentiment button | Screenshot shows order: Benchmark | Sentiment | Sentiment Export (left → right) | PASS |
| A3 | 4 | Popup message displays "We're hard at work preparing your export. While some exports can finish quickly, larger exports may take longer to complete. Once it's ready, your export will automatically download or open. You can also find the link to download the export in our app notifications menu, bell icon, and in an email to <EMAIL>." | Exact text rendered verbatim with `<EMAIL>` substituted as `yash.sharma@listenfirstmedia.com` | PASS |
| A4 | 5 | Message closes | Modal disappears post-Cancel-click; DOM probe `modalGone: true` | PASS |

## Evidence
- Screenshot `ss_0863i7ybi`: modal open with verbatim spec text (top-of-modal "Sentiment Export" title; View: CSV / Google Sheets toggle; "The Sentiment Export will export all comments with Classification, Emotion and Topics." header line; spec body text; Cancel / Ok buttons).
- Screenshot `ss_7152sdj8s`: Sentiment Export button rendered alongside Sentiment (right side) immediately after Sentiment activation.

## Notes
- Brand URL drift observed: navigated with `brand_id=4018` (MTV); post-Apply URL settled at `brand_id=10765` with channels=twitter only — MTV brand and logo unchanged in UI. Documented as known Brand>Content quirk.
- Email substitution `<EMAIL>` → `yash.sharma@listenfirstmedia.com` confirms spec template is using a per-user dynamic value as intended.

## Bugs filed
None.
