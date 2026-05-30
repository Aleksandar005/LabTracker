-- SAMOSTALNI UPIT - Aleksandar Todorović
-- Ovaj samostalni upit rangira teorije po broju eksperimenata koje su vezane za njih
-- i po ukupnom broju izvođenja tih eksperimenata

SELECT
    t.naziv AS teorija,
    COUNT(DISTINCT e.eksperiment_id) AS broj_eksperimenata,
    COUNT(DISTINCT izv.izvodjenje_id) AS broj_izvodjenja
FROM teorija t
JOIN eksperiment_teorija et ON et.teorija_id = t.teorija_id
JOIN eksperiment e ON e.eksperiment_id = et.eksperiment_id
LEFT JOIN izvodjenje izv ON izv.eksperiment_id = e.eksperiment_id
GROUP BY t.teorija_id, t.naziv
HAVING COUNT(DISTINCT e.eksperiment_id) >= 2
ORDER BY broj_izvodjenja DESC, broj_eksperimenata DESC;