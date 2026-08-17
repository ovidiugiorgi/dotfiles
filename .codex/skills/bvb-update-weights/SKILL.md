---
name: bvb-update-weights
description: Update official BET constituent weights in the user's BVB Google Sheet, preserve the curated ticker list and order, repair total formulas, optionally prepare a fee-aware buy-allocation draft, and require independent read-only verification. Use only when the user explicitly invokes `$bvb-update-weights` or asks to run the saved BVB weight or allocation workflow.
---

# Update BVB Portfolio

Update the tracked BET weights from official Bursa de Valori Bucuresti data. Treat the spreadsheet as an execution aid, not investment advice.

## Defaults

- Spreadsheet: use the URL supplied in the invocation. If none is supplied, ask for it before accessing Google Sheets. Treat private spreadsheet URLs as runtime inputs and never save them in this skill.
- Index: `BET`
- Official source: `https://m.bvb.ro/financialinstruments/indices/indicesprofiles`
- Tab: use the user-specified tab; otherwise select the newest tab whose title is an ISO date (`YYYY-MM-DD`), excluding sheets explicitly marked hidden. If visibility metadata is absent, use the newest ISO-dated tab and report the selection.
- Allocation draft: `<source tab> Draft`
- Simple fee estimate: `0.44%` of order value plus `1.57 RON` for each nonzero order. Keep both assumptions visible and editable in the draft.

Allow the user to override the spreadsheet URL or tab in the invocation.

## Required Tools

Use the connected Google Sheets capability for spreadsheet reads and writes. Use the official BVB page for source data. Do not use a browser session to verify Google Sheets when the connector can read it; browser authentication is separate and unnecessary for this numeric workflow.

Read and follow the Google Sheets skill before inspecting or editing the workbook.

## Workflow

### 1. Ground the target

1. Read spreadsheet metadata and resolve the exact tab and `sheetId`.
2. Read the bounded table, headers, formulas, formatting, and validation with cell-level data.
3. Locate the ticker/name column, `Weight` column, contiguous constituent rows, and `Total` row from live content. Do not assume fixed row numbers.
4. Parse each ticker from the start of its ticker/name cell, before ` - `; trim whitespace and normalize to uppercase for matching without changing the cell text.
5. Record the ticker list, order, weight values, last constituent row, and every populated formula in the Total row.
6. Stop before writing if tickers are blank, duplicated, ambiguous, or the table shape cannot be resolved confidently.

### 2. Fetch official weights

1. Fetch the current BET composition from the official BVB index-profile page.
2. Record the composition date, ticker, and published `Pondere (%)` exactly as displayed.
3. Confirm the page clearly identifies BET and a composition date.
4. Match by ticker, never by row position or company name.
5. Stop before writing if any tracked ticker has no unique official match.

Keep the spreadsheet's ticker list and order exactly as they are. Never add rows for official constituents that are absent from the sheet, and never remove tracked rows. Source-only tickers are expected intentional exclusions, not mismatches or failures. Do not renormalize tracked weights to 100% and do not compare the tracked total with the complete-index total as a pass criterion. The expected total is the sum of only the tracked tickers.

Compare each weight at the precision published by BVB. For totals, compare the sheet's displayed value with the tracked-weight sum rounded to the Total cell's displayed decimal precision; do not fail on binary floating-point residue below half of the smallest displayed unit.

### 3. Apply one scoped update

1. Re-read ticker and weight cells immediately before writing; abort if the ticker list or order changed.
2. Prepare one atomic Google Sheets batch.
3. Update only the existing Weight input cells, using the exact BVB percentages as numeric values.
4. In the Total row, update every populated total formula whose range ends before the last constituent row. Preserve each formula's column and shape while changing its terminal row to the live last constituent row.
5. Write only `userEnteredValue` so existing formats, validation, notes, and neighboring cells remain intact.
6. Do not update prices, funds, quantities, ticker names, row order, or unrelated formulas.

### 4. Verify in the primary session

Re-read the ticker rows and the full Total row. Confirm all of the following:

- Every tracked ticker has the official published weight.
- Ticker values and order match the pre-write snapshot.
- The displayed Weight total equals the independently calculated sum for tracked tickers.
- Every populated Total-row sum formula ends at the live last constituent row.
- No stale terminal-row reference remains in the Total row.
- Existing array or calculation formulas that are intended to cover constituent rows still reach the live last constituent row; report a stale range instead of silently broadening unrelated formulas.
- Formatting of changed cells is preserved after a write; treat this check as not applicable for an explicitly requested dry run.

If a scoped discrepancy has an unambiguous cause, correct it and repeat this verification. Never claim success from the write response alone.

### 5. Run the independent checker

Spawn a fresh subagent/session with no inherited conversation context. Give it only:

- The spreadsheet URL and resolved tab.
- The official BVB index-profile URL and index name.
- A strict read-only instruction.
- A request to derive all expected values independently.

Do not provide the expected weights, expected total, or prior conclusions. Require the checker to:

1. Fetch the official BET composition and composition date itself.
2. Read the live ticker and Weight cells itself.
3. Compare every tracked ticker by symbol.
4. Calculate the expected sum for only the tracked tickers.
5. Inspect the full Total row and confirm every populated sum formula ends at the last constituent row.
6. Ignore official source-only tickers for pass/fail because the tracked list is intentionally selective; it may mention them as informational exclusions only.
7. Report tracked-ticker mismatches explicitly or state that none exist.
8. Make no edits.

Wait for the checker. Do not report success unless it passes. If subagents are unavailable, state that independent verification could not be completed and do not describe the workflow as fully verified. If the checker finds a mismatch, investigate in the primary session, make only an unambiguous scoped correction, and run a fresh independent checker.

### 6. Prepare a buy-allocation draft when requested

Never add allocation formulas to the source tab. Duplicate the resolved source tab as `<source tab> Draft`; if that tab already exists, inspect it and update only the established allocation area. Preserve ticker rows and order. Rebalancing against current holdings is out of scope.

Use the current price, tracked weight, and Funds inputs to calculate:

- `Target Value = Funds * Weight / 100`
- `Ideal Units = Target Value / Price`
- `Base Buy = ROUNDDOWN(Ideal Units, 0)`
- `Suggested Buy = Base Buy + RR Add`
- `Suggested Value = Price * Suggested Buy`
- `Est. Fee = Suggested Value * variable fee + fixed fee` for a nonzero order; otherwise zero

Perform exactly one round-robin pass in existing sheet row order. Start from the fee-adjusted cash remaining after all base quantities. For each row, set `RR Add` to one only when all are true:

- Ticker is populated.
- Price is numeric and greater than zero.
- Weight is greater than zero.
- Ideal units are valid.
- Current remaining cash covers `Price * (1 + variable fee)`, plus the fixed fee when `Base Buy` is zero.

Otherwise set `RR Add` to zero. Never reorder rows to optimize the allocation, never give more than one RR unit to a ticker, and never repeat the pass automatically.

Add visible validation before treating the allocation as usable:

- `Input status`: fail for a blank price, nonpositive price, blank weight, negative weight, or tracked-weight total outside `(0, 100]`.
- A zero-weight row is allowed only as a zero-purchase row; it must never receive an RR unit.
- `Budget status`: show `BLOCKED` unless Input status passes; otherwise show `PASS` when suggested value plus estimated fees is at most Funds, or `OVER BUDGET` when it exceeds Funds.

Keep a running fee-adjusted `Cash Left` column and reconcile its final value with `Funds - Suggested Value total - Estimated Fees total`. Preserve the source tab unchanged.

### 7. Verify the allocation draft

Re-read all allocation formulas and effective values. Confirm:

- There are no formula errors.
- Every Base Buy equals the floor of Ideal Units.
- Every Suggested Buy equals Base Buy plus RR Add.
- RR decisions reproduce a single top-to-bottom pass and no row with `Weight <= 0` receives an addition.
- Fixed fees apply exactly once per nonzero order and never to a zero order.
- Suggested value, fees, cash required, and every cash-remaining indicator reconcile within spreadsheet floating-point precision.
- Input and budget statuses agree with their underlying conditions.
- The source tab remains unchanged.

Exercise these cases with read-only external calculations or a temporary test artifact that is removed afterward: exact affordability, `0.01 RON` below affordability, low funds, blank price, zero price, zero weight, total weight above 100%, and a Base Buy of zero that becomes a nonzero RR order. The expected safeguards are: zero-weight RR is rejected; blank/nonpositive prices block the allocation; invalid total weight blocks the allocation; and exact marginal cost passes while one cent below does not add the unit.

When allocation is included, give the fresh independent checker only the spreadsheet URL, source and draft tabs, fee assumptions, official BVB source, and a read-only request. Require it to derive the weight matches, RR sequence, fees, validation states, totals, and source-tab isolation independently. Do not provide expected quantities or totals.

## Final Report

Report concisely:

- Spreadsheet and tab updated.
- Official BVB composition date.
- Number of tracked tickers updated.
- Tracked-weight total, noting that it can be below 100% because exclusions are intentional.
- Total-row formula range status.
- Independent checker pass/fail and any mismatches.
- When allocation is included: suggested-value total, estimated fees, cash required, cash remaining, Input status, Budget status, and RR addition count.

Link the Google Sheet and official BVB source. Do not ask the user to sign in to Google for connector-based verification.
