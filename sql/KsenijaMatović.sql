-- SAMOSTALNI UPIT - Ksenija Matović
-- Ovaj samostali upit poredi mernu nesigurnost po tipu merenja
-- Od izvodjenja se posmatraju samo uspesno zavrsena

SELECT
    tm.naziv AS tip_merenja,
    COUNT(*) AS broj_izvodjenja,
    AVG(izv.merna_nesigurnost) AS prosecna_merna_nesigurnost,
    MIN(izv.merna_nesigurnost) AS minimalna_merna_nesigurnost,
    MAX(izv.merna_nesigurnost) AS maksimalna_merna_nesigurnost
FROM izvodjenje izv
JOIN eksperiment e ON e.eksperiment_id = izv.eksperiment_id
JOIN tip_merenja tm ON tm.tip_merenja_id = e.tip_merenja_id
JOIN status_izvodjenja s ON s.status_id = izv.status_id
WHERE s.naziv = 'zavrseno_uspesno' AND izv.merna_nesigurnost IS NOT NULL
GROUP BY tm.tip_merenja_id, tm.naziv
ORDER BY prosecna_merna_nesigurnost ASC;