-- =====================================================================
-- South African National Elections 2024 — Probability & Cross-Tabulation
-- SQL companion script (SQLite / PostgreSQL / MySQL compatible syntax)
-- =====================================================================
-- Source: Electoral Commission of South Africa (IEC) — official 2024
-- Provincial Legislature election results (provincial ballot), 29 May 2024.
-- Compiled via Wikipedia: "2024 South African provincial elections".
-- Figures are real, official vote counts for the top 5 parties by
-- national seat count, across all 9 provinces.
-- =====================================================================

DROP TABLE IF EXISTS election_votes;

CREATE TABLE election_votes (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,  -- use SERIAL in Postgres
    province TEXT NOT NULL,
    party    TEXT NOT NULL,
    votes    INTEGER NOT NULL
);

INSERT INTO election_votes (province, party, votes) VALUES
('Eastern Cape',  'ANC', 1114294),
('Eastern Cape',  'DA',   267007),
('Eastern Cape',  'EFF',  181855),
('Eastern Cape',  'MK',    25904),
('Eastern Cape',  'IFP',    1343),
('Free State',    'ANC',  429241),
('Free State',    'DA',   181062),
('Free State',    'EFF',  111850),
('Free State',    'MK',    15985),
('Free State',    'IFP',    1537),
('Gauteng',       'ANC', 1367248),
('Gauteng',       'DA',  1079229),
('Gauteng',       'EFF',  508390),
('Gauteng',       'MK',   384968),
('Gauteng',       'IFP',   34250),
('KwaZulu-Natal', 'ANC',  595958),
('KwaZulu-Natal', 'DA',   468515),
('KwaZulu-Natal', 'EFF',   79211),
('KwaZulu-Natal', 'MK',  1590813),
('KwaZulu-Natal', 'IFP',  633771),
('Limpopo',       'ANC', 1037627),
('Limpopo',       'DA',    84388),
('Limpopo',       'EFF',  199900),
('Limpopo',       'MK',    12027),
('Limpopo',       'IFP',     890),
('Mpumalanga',    'ANC',  584609),
('Mpumalanga',    'DA',   137408),
('Mpumalanga',    'EFF',  158511),
('Mpumalanga',    'MK',   193995),
('Mpumalanga',    'IFP',    5352),
('North West',    'ANC',  510994),
('North West',    'DA',   117168),
('North West',    'EFF',  153743),
('North West',    'MK',    18198),
('North West',    'IFP',    1335),
('Northern Cape', 'ANC',  195267),
('Northern Cape', 'DA',    83848),
('Northern Cape', 'EFF',   52433),
('Northern Cape', 'MK',     3111),
('Northern Cape', 'IFP',     303),
('Western Cape',  'ANC',  384853),
('Western Cape',  'DA',  1088423),
('Western Cape',  'EFF',  104354),
('Western Cape',  'MK',    11263),
('Western Cape',  'IFP',     824);

-- =====================================================================
-- 1. CROSS-TABULATION: Province x Party contingency table
-- =====================================================================
SELECT
    province,
    SUM(CASE WHEN party = 'ANC' THEN votes ELSE 0 END) AS ANC,
    SUM(CASE WHEN party = 'DA'  THEN votes ELSE 0 END) AS DA,
    SUM(CASE WHEN party = 'EFF' THEN votes ELSE 0 END) AS EFF,
    SUM(CASE WHEN party = 'MK'  THEN votes ELSE 0 END) AS MK,
    SUM(CASE WHEN party = 'IFP' THEN votes ELSE 0 END) AS IFP,
    SUM(votes) AS row_total
FROM election_votes
GROUP BY province
ORDER BY province;

-- =====================================================================
-- 2. GRAND TOTAL (denominator for all probability calculations)
-- =====================================================================
SELECT SUM(votes) AS grand_total FROM election_votes;

-- =====================================================================
-- 3. EMPIRICAL / MARGINAL PROBABILITY OF EACH PARTY — P(Party)
-- =====================================================================
SELECT
    party,
    SUM(votes) AS votes,
    ROUND(1.0 * SUM(votes) / (SELECT SUM(votes) FROM election_votes), 4) AS p_party
FROM election_votes
GROUP BY party
ORDER BY p_party DESC;

-- =====================================================================
-- 4. MARGINAL PROBABILITY OF EACH PROVINCE — P(Province)
-- =====================================================================
SELECT
    province,
    SUM(votes) AS votes,
    ROUND(1.0 * SUM(votes) / (SELECT SUM(votes) FROM election_votes), 4) AS p_province
FROM election_votes
GROUP BY province
ORDER BY p_province DESC;

-- =====================================================================
-- 5. JOINT PROBABILITY — P(Province AND Party) = cell / grand total
-- =====================================================================
SELECT
    province,
    party,
    votes,
    ROUND(1.0 * votes / (SELECT SUM(votes) FROM election_votes), 4) AS p_joint
FROM election_votes
ORDER BY province, party;

-- =====================================================================
-- 6. CONDITIONAL PROBABILITY — P(Party | Province)
--    "Given a ballot was cast in this province, P(it went to this party)"
-- =====================================================================
SELECT
    e.province,
    e.party,
    e.votes,
    ROUND(1.0 * e.votes / prov.row_total, 4) AS p_party_given_province
FROM election_votes e
JOIN (
    SELECT province, SUM(votes) AS row_total
    FROM election_votes
    GROUP BY province
) prov ON e.province = prov.province
ORDER BY e.province, p_party_given_province DESC;

-- =====================================================================
-- 7. CONDITIONAL PROBABILITY — P(Province | Party)
--    "Given a ballot went to this party, P(it was cast in this province)"
-- =====================================================================
SELECT
    e.province,
    e.party,
    e.votes,
    ROUND(1.0 * e.votes / party_tot.col_total, 4) AS p_province_given_party
FROM election_votes e
JOIN (
    SELECT party, SUM(votes) AS col_total
    FROM election_votes
    GROUP BY party
) party_tot ON e.party = party_tot.party
ORDER BY e.party, p_province_given_party DESC;
