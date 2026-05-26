# Assertion Patterns

Reusable assertion definitions. **Assertions are not cheap — accuracy here is the product.**

## Assertion types

### existence
Element is present (or absent) in the DOM.
```yaml
type: existence
selector: "[data-testid='user-menu']"
expected: present   # or absent
```

### text_equals
Text content matches exactly after normalization.
```yaml
type: text_equals
selector: "[data-testid='account-header']"
expected: "Acme Corp"
normalize:
  trim: true
  collapse_whitespace: false   # if true, multiple spaces become one
  case_sensitive: true
```
Failure must produce a character-level diff (`expected[i]` vs `actual[i]`).

### text_contains / regex
Partial or pattern match.
```yaml
type: text_contains   # or regex
selector: "..."
expected: "Welcome back"
```

### numeric
Parse number with currency/unit awareness; optional tolerance.
```yaml
type: numeric
selector: "[data-testid='total-revenue']"
expected: 1234567.89
tolerance: 0.01           # absolute
unit: USD                 # symbol expected in rendered text
locale: en-US
```
Failure diff shows expected vs parsed actual vs raw text.

### date_time
Parse to ISO, compare with tolerance window.
```yaml
type: date_time
selector: "..."
expected: "2026-05-13T00:00:00Z"
tolerance_seconds: 60
format_hint: "MMM D, YYYY"   # optional
```

### table
Row-by-row, cell-by-cell. Expected can be inline rows or a CSV reference.
```yaml
type: table
selector: "table[data-testid='top-brands']"
expected_csv: "knowledge-base/data-references/top-brands-2026-05-13.csv"
key_columns: [brand_id]      # row identity
order_sensitive: false
```
Diff highlights added/removed rows and changed cells.

### set
Order-insensitive list comparison.
```yaml
type: set
selector: "[data-testid='tag']"
collect: "textContent"
expected: ["Music", "Movies", "TV"]
```

### cross_source
Compare a UI value against a separate fetch (API or another page).
```yaml
type: cross_source
ui:
  selector: "[data-testid='total-revenue']"
  parse: numeric
source:
  network: "GET /api/dashboard/summary"
  jsonpath: "$.totals.revenue"
  parse: numeric
tolerance: 0.01
```
This is one of the most valuable assertions — it catches backend/frontend drift bugs.

### visual_region
Use only when functional assertions can't capture the issue (charts, branding).
```yaml
type: visual_region
selector: "[data-testid='trend-chart']"
description: "Line chart should slope upward from left to right"
# Claude describes the screenshot and compares to expectation in natural language
```

## Normalization rules (text)

When `text_equals` is used:
- Default: `trim=true`, `collapse_whitespace=false`, `case_sensitive=true`
- Whitespace mismatches (e.g., `"Acme Corp"` vs `"Acme  Corp"`) are real bugs — never collapse silently
- Unicode normalization: NFC before compare
- Trailing punctuation differences are real differences

## Failure → diff rendering

Every failed assertion must produce a structured diff in the bug evidence:

```
Assertion: <type> on <selector>
Expected:  <value>
Actual:    <value>
Diff:      <character index | numeric delta | cell list>
Source:    <DOM path or API endpoint>
```
