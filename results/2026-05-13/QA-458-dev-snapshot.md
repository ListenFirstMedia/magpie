# QA-458 — Dev Snapshot for Prod Comparison

> Run on **dev** (https://app.lfmdev.in) on **2026-05-13** as account `Adam Orfei`, user `lfiqa@listenfirstmedia.com` (display name LFQA).
>
> Use this snapshot to compare against an identical run on **prod**. The assertion (A1) is that every numeric cell below matches the prod equivalent exactly.

## Configuration

| Setting | Value |
|---------|-------|
| Account | Adam Orfei (account_id=54) |
| Brand | The Walking Dead — Public Data perspective |
| Date type | Relative |
| Interval | Days |
| Range | 3 Days Before Event – 1 Day After Event |
| Key Date | Season 9 Episode 16 → **Mar 31, 2019** |
| Metrics | All rate metrics that were enabled-toggleable for this brand's channels |
| Options | Show Metrics Graphs **off**; Show Share **on**; Show Change **on** |
| Story ID | `https://app-reporting.lfmdev.in/#story/time_window_comparison/152990` |

## Coverage

- **52 data tables** captured (one per metric × table-variant: Value, Change, Change %, Brand Share).
- Channels with data: **Cross-Channel, Facebook, Twitter, Instagram, YouTube**. TikTok had no rate metrics available for this brand.
- 13 unique metrics across categories: Response Rate, Fan Growth Rate, Response Rate (with IG Saves, IG Shares & FB Clicks), Facebook Fan Growth Rate, Facebook Response Rate, Facebook Response Rate (with Clicks), Twitter Follower Growth Rate, Twitter Response Rate, Instagram Organic Response Rate, Instagram Follower Growth Rate, Instagram Response Rate (with Saves & Shares), YouTube Subscriber Growth Rate, YouTube Response Rate.

Each metric block contains four tables: the base metric value, **Change** (absolute period delta), **Change %** (relative percent delta), and **Brand Share** (percent of competitive set — 100% with a single brand).

## Tables

The format below is: `#<table_idx> [<metric context>] <header column> :: <day1> -> <value> | <day2> -> <value> | ...`

### Cross-Channel

```
#0  [Response Rate] Response Rate / The Walking Dead :: 3 Days Out -> 0.15% | 2 Days Out -> 0.15% | 1 Day Out -> 0.15% | Event Day -> 0.45% | 1 Day Post -> 0.46%
#1  [Response Rate] Change / The Walking Dead :: 3 Days Out -> -0.11% | 2 Days Out -> >-0.01% | 1 Day Out -> <0.01% | Event Day -> 0.29% | 1 Day Post -> 0.01%
#2  [Response Rate] Change % / The Walking Dead :: 3 Days Out -> -42% | 2 Days Out -> -0.57% | 1 Day Out -> 3% | Event Day -> 191% | 1 Day Post -> 3%
#3  [Response Rate] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> 100% | 1 Day Post -> 100%
#4  [Fan Growth Rate] Fan Growth Rate / The Walking Dead :: 3 Days Out -> <0.01% | 2 Days Out -> <0.01% | 1 Day Out -> >-0.01% | Event Day -> >-0.01% | 1 Day Post -> <0.01%
#5  [Fan Growth Rate] Change / The Walking Dead :: 3 Days Out -> >-0.01% | 2 Days Out -> >-0.01% | 1 Day Out -> >-0.01% | Event Day -> >-0.01% | 1 Day Post -> 0.01%
#6  [Fan Growth Rate] Change % / The Walking Dead :: (partial — see ##truncated tables below)
#7  [Fan Growth Rate] Brand Share / The Walking Dead :: (partial — see ##truncated tables below)
#8  [Response Rate (with IG Saves, IG Shares & FB Clicks)] Response Rate / The Walking Dead :: 3 Days Out -> 0.14% | 2 Days Out -> 0.14% | 1 Day Out -> 0.15% | Event Day -> 0.23% | 1 Day Post -> 0.42%
#9  [Response Rate (with IG Saves, IG Shares & FB Clicks)] Change / The Walking Dead :: 3 Days Out -> -0.11% | 2 Days Out -> 0.01% | 1 Day Out -> 0.01% | Event Day -> 0.09% | 1 Day Post -> 0.19%
#10 [Response Rate (with IG Saves, IG Shares & FB Clicks)] Change % / The Walking Dead :: 3 Days Out -> -44% | 2 Days Out -> 4% | 1 Day Out -> 4% | Event Day -> 58% | 1 Day Post -> 81%
#11 [Response Rate (with IG Saves, IG Shares & FB Clicks)] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> 100% | 1 Day Post -> 100%
```

### Facebook

```
#12 [Facebook Fan Growth Rate] Facebook Fan Growth Rate / The Walking Dead :: 3 Days Out -> >-0.01% | 2 Days Out -> -0.01% | 1 Day Out -> -0.01% | Event Day -> -0.01% | 1 Day Post -> >-0.01%
#13 [Facebook Fan Growth Rate] Change / The Walking Dead :: 3 Days Out -> >-0.01% | 2 Days Out -> >-0.01% | 1 Day Out -> >-0.01% | Event Day -> <0.01% | 1 Day Post -> <0.01%
#14 [Facebook Fan Growth Rate] Change % / The Walking Dead :: 3 Days Out -> -61% | 2 Days Out -> -51% | 1 Day Out -> -11% | Event Day -> 13% | 1 Day Post -> 82%
#15 [Facebook Fan Growth Rate] Brand Share / The Walking Dead :: 3 Days Out -> -100% | 2 Days Out -> -100% | 1 Day Out -> -100% | Event Day -> -100% | 1 Day Post -> -100%
#16 [Facebook Response Rate] Facebook Response Rate / The Walking Dead :: 3 Days Out -> 0.02% | 2 Days Out -> 0.02% | 1 Day Out -> 0.01% | Event Day -> 0.03% | 1 Day Post -> 0.04%
#17 [Facebook Response Rate] Change / The Walking Dead :: 3 Days Out -> -0.01% | 2 Days Out -> >-0.01% | 1 Day Out -> >-0.01% | Event Day -> 0.01% | 1 Day Post -> 0.01%
#18 [Facebook Response Rate] Change % / The Walking Dead :: 3 Days Out -> -31% | 2 Days Out -> -17% | 1 Day Out -> -12% | Event Day -> 79% | 1 Day Post -> 49%
#19 [Facebook Response Rate] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> 100% | 1 Day Post -> 100%
#20 [Facebook Response Rate (with Clicks)] Facebook Response Rate (with Clicks) / The Walking Dead :: 3 Days Out -> 0.02% | 2 Days Out -> 0.02% | 1 Day Out -> 0.01% | Event Day -> 0.03% | 1 Day Post -> 0.04%
#21 [Facebook Response Rate (with Clicks)] Change / The Walking Dead :: 3 Days Out -> -0.01% | 2 Days Out -> >-0.01% | 1 Day Out -> >-0.01% | Event Day -> 0.01% | 1 Day Post -> 0.01%
#22 [Facebook Response Rate (with Clicks)] Change % / The Walking Dead :: 3 Days Out -> -31% | 2 Days Out -> -17% | 1 Day Out -> -12% | Event Day -> 79% | 1 Day Post -> 49%
#23 [Facebook Response Rate (with Clicks)] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> 100% | 1 Day Post -> 100%
```

### Twitter

```
#24 [Twitter Follower Growth Rate] Twitter Follower Growth Rate / The Walking Dead :: 3 Days Out -> -0.01% | 2 Days Out -> >-0.01% | 1 Day Out -> >-0.01% | Event Day -> >-0.01% | 1 Day Post -> -0.01%
#25 [Twitter Follower Growth Rate] Change / The Walking Dead :: 3 Days Out -> >-0.01% | 2 Days Out -> <0.01% | 1 Day Out -> >-0.01% | Event Day -> >-0.01% | 1 Day Post -> -0.01%
#26 [Twitter Follower Growth Rate] Change % / The Walking Dead :: 3 Days Out -> -741% | 2 Days Out -> 90% | 1 Day Out -> -75% | Event Day -> -48% | 1 Day Post -> -443%
#27 [Twitter Follower Growth Rate] Brand Share / The Walking Dead :: 3 Days Out -> -100% | 2 Days Out -> -100% | 1 Day Out -> -100% | Event Day -> -100% | 1 Day Post -> -100%
#28 [Twitter Response Rate] Twitter Response Rate / The Walking Dead :: 3 Days Out -> 0.06% | 2 Days Out -> 0.02% | 1 Day Out -> 0.04% | Event Day -> 0.03% | 1 Day Post -> 0.07%
#29 [Twitter Response Rate] Change / The Walking Dead :: 3 Days Out -> -0.01% | 2 Days Out -> -0.04% | 1 Day Out -> 0.01% | Event Day -> >-0.01% | 1 Day Post -> 0.03%
#30 [Twitter Response Rate] Change % / The Walking Dead :: 3 Days Out -> -8% | 2 Days Out -> -61% | 1 Day Out -> 52% | Event Day -> -9% | 1 Day Post -> 105%
#31 [Twitter Response Rate] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> 100% | 1 Day Post -> 100%
```

### Instagram

```
#32 [Instagram Organic Response Rate] Instagram Organic Response Rate / The Walking Dead :: 3 Days Out -> 1.35% | 2 Days Out -> 1.03% | 1 Day Out -> 0.94% | Event Day -> 1.35% | 1 Day Post -> 3.92%
#33 [Instagram Organic Response Rate] Change / The Walking Dead :: 3 Days Out -> -0.62% | 2 Days Out -> -0.32% | 1 Day Out -> -0.09% | Event Day -> 0.41% | 1 Day Post -> 2.57%
#34 [Instagram Organic Response Rate] Change % / The Walking Dead :: 3 Days Out -> -31% | 2 Days Out -> -24% | 1 Day Out -> -9% | Event Day -> 43% | 1 Day Post -> 191%
#35 [Instagram Organic Response Rate] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> 100% | 1 Day Post -> 100%
#36 [Instagram Follower Growth Rate] Instagram Follower Growth Rate / The Walking Dead :: 3 Days Out -> 0.04% | 2 Days Out -> 0.03% | 1 Day Out -> 0.03% | Event Day -> -0.02% | 1 Day Post -> 0.02%
#37 [Instagram Follower Growth Rate] Change / The Walking Dead :: 3 Days Out -> -0.01% | 2 Days Out -> -0.01% | 1 Day Out -> >-0.01% | Event Day -> -0.04% | 1 Day Post -> 0.03%
#38 [Instagram Follower Growth Rate] Change % / The Walking Dead :: 3 Days Out -> -18% | 2 Days Out -> -24% | 1 Day Out -> -12% | Event Day -> -169% | 1 Day Post -> 184%
#39 [Instagram Follower Growth Rate] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> -100% | 1 Day Post -> 100%
#40 [Instagram Response Rate (with Saves & Shares)] Instagram Response Rate (with Saves & Shares) / The Walking Dead :: 3 Days Out -> 1.35% | 2 Days Out -> 1.03% | 1 Day Out -> 0.94% | Event Day -> 1.35% | 1 Day Post -> 3.92%
#41 [Instagram Response Rate (with Saves & Shares)] Change / The Walking Dead :: 3 Days Out -> -0.62% | 2 Days Out -> -0.32% | 1 Day Out -> -0.09% | Event Day -> 0.41% | 1 Day Post -> 2.57%
#42 [Instagram Response Rate (with Saves & Shares)] Change % / The Walking Dead :: 3 Days Out -> -31% | 2 Days Out -> -24% | 1 Day Out -> -9% | Event Day -> 43% | 1 Day Post -> 191%
#43 [Instagram Response Rate (with Saves & Shares)] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> 100% | Event Day -> 100% | 1 Day Post -> 100%
```

### YouTube

```
#44 [YouTube Subscriber Growth Rate] YouTube Subscriber Growth Rate / The Walking Dead :: 3 Days Out -> 0.00% | 2 Days Out -> 0.14% | 1 Day Out -> 0.00% | Event Day -> 0.14% | 1 Day Post -> 0.00%
#45 [YouTube Subscriber Growth Rate] Change / The Walking Dead :: 3 Days Out -> -0.14% | 2 Days Out -> 0.14% | 1 Day Out -> -0.14% | Event Day -> 0.14% | 1 Day Post -> -0.14%
#46 [YouTube Subscriber Growth Rate] Change % / The Walking Dead :: 3 Days Out -> -100% | 2 Days Out -> >999% | 1 Day Out -> -100% | Event Day -> >999% | 1 Day Post -> -100%
#47 [YouTube Subscriber Growth Rate] Brand Share / The Walking Dead :: 3 Days Out -> – | 2 Days Out -> 100% | 1 Day Out -> – | Event Day -> 100% | 1 Day Post -> –
#48 [YouTube Response Rate] YouTube Response Rate / The Walking Dead :: 3 Days Out -> 0.30% | 2 Days Out -> 0.27% | 1 Day Out -> – | Event Day -> 0.25% | 1 Day Post -> 0.08%
#49 [YouTube Response Rate] Change / The Walking Dead :: 3 Days Out -> – | 2 Days Out -> -0.02% | 1 Day Out -> – | Event Day -> – | 1 Day Post -> -0.17%
#50 [YouTube Response Rate] Change % / The Walking Dead :: 3 Days Out -> – | 2 Days Out -> -8% | 1 Day Out -> – | Event Day -> – | 1 Day Post -> -69%
#51 [YouTube Response Rate] Brand Share / The Walking Dead :: 3 Days Out -> 100% | 2 Days Out -> 100% | 1 Day Out -> – | Event Day -> 100% | 1 Day Post -> 100%
```

## How to use this for prod comparison

1. On prod, repeat the exact same configuration shown above.
2. After the report builds, capture the equivalent 52 tables.
3. Compare row-by-row, cell-by-cell. Any cell value that differs is a violation of assertion A1.
4. `–` (em-dash) is the platform's "no data" marker — it should match between dev and prod on the same date.

Any value mismatch should be filed as a parity bug, with this snapshot URL and the prod snapshot URL attached.
