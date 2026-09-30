# Probability Concepts in Excel — South African National Party Support (2024 Elections)

**Portfolio project · Applied Business Statistics · Storytelling with Data**

## Overview

This project applies core probability concepts — cross-tabulation, empirical
probability, marginal probability, joint probability, and conditional
probability — to a real, high-profile South African dataset: the official
results of the **29 May 2024 Provincial Legislature elections**.

Instead of a synthetic textbook example, the "events" here are real ballots:
which of South Africa's 9 provinces a vote was cast in, and which of the
top 5 parties (by national seat count) it went to — ANC, DA, EFF, MK, and IFP.

## Files

| File | Description |
|---|---|
| `sa_election_2024_province_party_votes.csv` | Tidy source data: one row per Province × Party, with real vote counts. 45 rows (9 provinces × 5 parties). |
| `probability_sa_elections_2024.xlsx` | Excel workbook — cross-tab + all probability calculations as live formulas. |
| `probability_sa_elections_2024.sql` | SQL schema, data load, and queries reproducing the same analysis. |
| `README.md` | This file. |

## Data source & integrity

Vote counts are the **official results** published by the Electoral
Commission of South Africa (IEC) for the provincial ballot, compiled from
Wikipedia's *"2024 South African provincial elections"* summary tables
(themselves sourced to the IEC). Every number in the dataset is a real,
audited vote count — nothing here is simulated. Only the top 5 parties by
national seat total are included, so province/party totals in this dataset
are a subset of each province's full result (smaller parties are excluded
by design, to keep the cross-tab readable).

## Excel workbook structure

1. **Read Me** — project overview, navigation, and sourcing.
2. **Data** — the raw tidy dataset (Province, Party, Votes).
3. **Cross-Tab** — a 9×5 contingency table built entirely with `SUMIFS`
   formulas pulling from the Data tab, with row and column totals.
4. **Probabilities** — five fully formula-driven sections:
   - **Empirical / marginal probability of each party** — P(Party) = party
     votes ÷ grand total (this *is* the party's overall vote share).
   - **Marginal probability of each province** — P(Province) = province
     votes ÷ grand total.
   - **Joint probability** — P(Province ∩ Party) = cell ÷ grand total, for
     all 45 combinations (sums to 100%).
   - **Conditional probability P(Party | Province)** — "given a ballot was
     cast in this province, how likely is it to have gone to this party?"
     (each row sums to 100%).
   - **Conditional probability P(Province | Party)** — "given a ballot went
     to this party, how likely is it to have come from this province?"
     (each column sums to 100%).

Every probability cell is a formula referencing the Cross-Tab sheet — change
nothing by hand and the whole sheet recalculates correctly if the source
data changes.

## Key concepts demonstrated

- **Cross-tabulation** — organizing two categorical variables (Province,
  Party) into a contingency table.
- **Empirical probability** — probability estimated directly from observed
  frequencies (here, real vote counts) rather than a theoretical model.
- **Marginal probability** — the probability of one variable, ignoring the
  other (row/column totals ÷ grand total).
- **Joint probability** — the probability of two events occurring together.
- **Conditional probability** — how the probability of one variable changes
  once the other is known, and why P(A|B) ≠ P(B|A) (compare the two
  conditional tables directly — they tell very different stories about the
  same 45 numbers).

## How to reproduce / extend

- The SQL script creates a `election_votes` table and runs the same seven
  analyses (cross-tab, grand total, marginal ×2, joint, conditional ×2)
  using standard `GROUP BY`, `CASE WHEN`, and correlated subqueries — tested
  against SQLite but written in portable ANSI SQL that also runs on
  PostgreSQL/MySQL with minor `AUTOINCREMENT` → `SERIAL`/`AUTO_INCREMENT`
  substitution.
- To extend: add more parties/provinces to the CSV, or pull the 2019
  election results for the same provinces to build a two-election comparison
  and explore how conditional probabilities shifted.
