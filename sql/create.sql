CREATE DATABASE labtracker;
USE labtracker;

CREATE TABLE teorija (
    teorija_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(150) NOT NULL,
    opis TEXT
);

CREATE TABLE tip_merenja (
    tip_merenja_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(20) NOT NULL
);

CREATE TABLE stanje_resursa (
    stanje_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(20) NOT NULL
);

CREATE TABLE akademsko_zvanje (
    zvanje_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(20) NOT NULL
);

CREATE TABLE status_izvodjenja (
    status_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(20) NOT NULL
);

CREATE TABLE eksperiment (
    eksperiment_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(150) NOT NULL,
    tip_merenja_id INT NOT NULL,
    fizicka_velicina VARCHAR(80) NOT NULL,
    FOREIGN KEY (tip_merenja_id) REFERENCES tip_merenja(tip_merenja_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE eksperiment_teorija (
    eksperiment_id INT NOT NULL,
    teorija_id INT NOT NULL,
    PRIMARY KEY (eksperiment_id, teorija_id),
    FOREIGN KEY (eksperiment_id) REFERENCES eksperiment(eksperiment_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (teorija_id) REFERENCES teorija(teorija_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE laboratorija (
    laboratorija_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    opis_lokacije VARCHAR(255),
    tip_laboratorije VARCHAR(80) NOT NULL,
    kapacitet INT NOT NULL,
    nivo_pristupa INT NOT NULL
);

CREATE TABLE resurs (
    resurs_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    serijski_broj VARCHAR(50) NOT NULL,
    stanje_id INT NOT NULL,
    masa DOUBLE,
    dimenzije VARCHAR(50),
    materijal VARCHAR(80),
    FOREIGN KEY (stanje_id) REFERENCES stanje_resursa(stanje_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE laboratorija_resurs (
	laboratorija_id INT NOT NULL,
	resurs_id INT NOT NULL,
	kolicina INT NOT NULL,
	PRIMARY KEY (laboratorija_id, resurs_id),
	FOREIGN KEY (laboratorija_id) REFERENCES laboratorija(laboratorija_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tip_alata (
	tip_alata_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	naziv VARCHAR(80) NOT NULL,
	opis TEXT
);

CREATE TABLE alat (
	alat_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	datum_nabavke DATE NOT NULL,
	datum_proizvodnje DATE,
	tacnost_merenja VARCHAR(50),
	datum_kalibracije DATE,
	laboratorija_id INT NOT NULL,
	tip_alata_id INT NOT NULL,
	FOREIGN KEY (laboratorija_id) REFERENCES laboratorija(laboratorija_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (tip_alata_id) REFERENCES tip_alata(tip_alata_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE istrazivac (
	istrazivac_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ime VARCHAR(50) NOT NULL,
	prezime VARCHAR(50) NOT NULL,
	datum_rodjenja DATE NOT NULL,
	kontakt VARCHAR(100) NOT NULL,
	zvanje_id INT NOT NULL,
	oblast_specijalizacije VARCHAR(80) NOT NULL,
	nivo_pristupa INT NOT NULL,
	FOREIGN KEY (zvanje_id) REFERENCES akademsko_zvanje(zvanje_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE istrazivac_laboratorija (
	istrazivac_id INT NOT NULL,
	laboratorija_id INT NOT NULL,
	PRIMARY KEY (istrazivac_id, laboratorija_id),
	FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (laboratorija_id) REFERENCES laboratorija(laboratorija_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE eksperiment_dizajner (
	eksperiment_id INT NOT NULL,
	istrazivac_id INT NOT NULL,
	PRIMARY KEY (eksperiment_id, istrazivac_id),
	FOREIGN KEY (eksperiment_id) REFERENCES eksperiment(eksperiment_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE izvodjenje (
	izvodjenje_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	datum DATE NOT NULL,
	status_id INT NOT NULL,
	broj_ponavljanja_merenja INT,
	rezultat DOUBLE,
	merna_nesigurnost DOUBLE,
	eksperiment_id INT NOT NULL,
	FOREIGN KEY (status_id) REFERENCES status_izvodjenja(status_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (eksperiment_id) REFERENCES eksperiment(eksperiment_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE istrazivac_izvodjenje (
	istrazivac_id INT NOT NULL,
	izvodjenje_id INT NOT NULL,
	uloga VARCHAR(50) NOT NULL,
	beleske VARCHAR(255),
	PRIMARY KEY (istrazivac_id, izvodjenje_id),
	FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (izvodjenje_id) REFERENCES izvodjenje(izvodjenje_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE sesija (
	sesija_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	datum DATE NOT NULL,
	vreme_pocetka TIME NOT NULL,
	vreme_zavrsetka TIME NOT NULL,
	temperatura DOUBLE,
	vlaznost DOUBLE,
	pritisak DOUBLE,
	izvodjenje_id INT NOT NULL,
	laboratorija_id INT NOT NULL,
	FOREIGN KEY (izvodjenje_id) REFERENCES izvodjenje(izvodjenje_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (laboratorija_id) REFERENCES laboratorija(laboratorija_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE sesija_resurs (
	sesija_id INT NOT NULL,
	resurs_id INT NOT NULL,
	kolicina INT NOT NULL,
	PRIMARY KEY (sesija_id, resurs_id),
	FOREIGN KEY (sesija_id) REFERENCES sesija(sesija_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (resurs_id) REFERENCES resurs(resurs_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE sesija_alat (
	sesija_id INT NOT NULL,
	alat_id INT NOT NULL,
	PRIMARY KEY (sesija_id, alat_id),
	FOREIGN KEY (sesija_id) REFERENCES sesija(sesija_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (alat_id) REFERENCES alat(alat_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Pogled koji prikazuje najproduktivnije istrazivace na osnovu uspesno zavrsenih izvodjenja
-- Posmatraju se samo izvodjaci, jer su samo oni radili eksperiment (nema smisla da se posmatraju dizajneri, oni samo osmisljaju eksperiment)
-- Uslov za rangiranje je da izvodjaci imaju bar 2 uspesno zavrsena izvodjenja

CREATE VIEW pogled_najproduktivniji_istrazivaci AS
SELECT
	i.istrazivac_id,
	i.ime,
	i.prezime,
	az.naziv AS zvanje,
	i.oblast_specijalizacije,
	COUNT(*) AS broj_uspesnih_izvodjenja,
	AVG(izv.broj_ponavljanja_merenja) AS prosecan_broj_ponavljanja
FROM istrazivac i
JOIN akademsko_zvanje az ON i.zvanje_id = az.zvanje_id
JOIN istrazivac_izvodjenje ii ON ii.istrazivac_id = i.istrazivac_id
JOIN izvodjenje izv ON izv.izvodjenje_id = ii.izvodjenje_id
JOIN status_izvodjenja s ON s.status_id = izv.status_id
WHERE s.naziv = 'zavrseno_uspesno'
GROUP BY i.istrazivac_id, i.ime, i.prezime, az.naziv, i.oblast_specijalizacije
HAVING COUNT(*) >= 2
ORDER BY broj_uspesnih_izvodjenja DESC;


-- Procedura koja se poziva kada zelimo da zavrsimo izvodjenje eksperimenta. Postavlja
-- status izvodjenja na 'zavrseno_uspesno' i smanjuje kolicinu resursa u
-- laboratorijama za sve resurse iskoriscene u svim sesijama tog izvodjenja.
-- Sve se odvija u transakciji, ako bilo koja operacija ne uspe, ceo postupak
-- se ponistava. Procedura proverava da izvodjenje postoji, da nije vec
-- zavrseno i da ukupna potraznja resursa po laboratoriji ne prelazi inventar.


DELIMITER //

CREATE PROCEDURE zavrsi_izvodjenje(IN p_izvodjenje_id INT)
BEGIN
    DECLARE v_uspesno_status_id INT;
    DECLARE v_trenutni_status_id INT DEFAULT NULL;
    DECLARE v_nedostaje INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Citamo trenutni status izvodjenja
    SELECT status_id INTO v_trenutni_status_id
    FROM izvodjenje WHERE izvodjenje_id = p_izvodjenje_id;

    -- Da li izvodjenje postoji
    IF v_trenutni_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Izvodjenje sa zadatim id-jem ne postoji.';
    END IF;

    -- Citamo status_id samo za za zavrseno_uspesno
    SELECT status_id INTO v_uspesno_status_id
    FROM status_izvodjenja WHERE naziv = 'zavrseno_uspesno';

    -- Provera da izvodjenje nije vec zavrseno mozda
    IF v_trenutni_status_id = v_uspesno_status_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Izvodjenje je vec zavrseno uspesno.';
    END IF;

    -- Provera da inventar laboratorije ne bi pao u negativno
    SELECT COUNT(*) INTO v_nedostaje
    FROM (
        SELECT s.laboratorija_id, sr.resurs_id, SUM(sr.kolicina) AS ukupno
        FROM sesija s JOIN sesija_resurs sr ON sr.sesija_id = s.sesija_id
        WHERE s.izvodjenje_id = p_izvodjenje_id
        GROUP BY s.laboratorija_id, sr.resurs_id
    ) AS potraznja
    JOIN laboratorija_resurs lr ON lr.laboratorija_id = potraznja.laboratorija_id
        AND lr.resurs_id = potraznja.resurs_id
    WHERE lr.kolicina < potraznja.ukupno;

    IF v_nedostaje > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nema dovoljno resursa u inventaru za sve sesije izvodjenja.';
    END IF;

    -- Smanji kolicinu resursa u laboratorijama za sve resurse iskoriscene u svakoj od sesija
    UPDATE laboratorija_resurs lr
    JOIN (
        SELECT s.laboratorija_id, sr.resurs_id, SUM(sr.kolicina) AS ukupno
        FROM sesija s JOIN sesija_resurs sr ON sr.sesija_id = s.sesija_id
        WHERE s.izvodjenje_id = p_izvodjenje_id
        GROUP BY s.laboratorija_id, sr.resurs_id
    ) AS potraznja
        ON lr.laboratorija_id = potraznja.laboratorija_id
        AND lr.resurs_id = potraznja.resurs_id
    SET lr.kolicina = lr.kolicina - potraznja.ukupno;

    -- Postavi status izvodjenja na zavrseno_uspesno
    UPDATE izvodjenje
    SET status_id = v_uspesno_status_id WHERE izvodjenje_id = p_izvodjenje_id;

   	COMMIT;
END //

DELIMITER ;

-- Funkcija koja za zadatog istrazivaca vraca procenat uspesno zavrsenih izvodjenja u kojima je istrazivac
-- bio u ulozi izvodjaca

DELIMITER //

CREATE FUNCTION procenat_uspesnih_izvodjenja(p_istrazivac_id INT)
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_ukupno INT;
	DECLARE v_uspesnih INT;
	DECLARE v_uspesno_status_id INT;

    -- Procitaj status_id za zavrseno_uspesno
    SELECT status_id INTO v_uspesno_status_id
    FROM status_izvodjenja WHERE naziv = 'zavrseno_uspesno';

    -- Prebroj sva izvodjenja u kojima je istrazivac bio izvodjac
    SELECT COUNT(*) INTO v_ukupno
    FROM istrazivac_izvodjenje WHERE istrazivac_id = p_istrazivac_id;

    IF v_ukupno = 0 THEN
        RETURN NULL;
    END IF;

    -- Prebroji koliko od tih izvodjenja je zavrseno uspesno
    SELECT COUNT(*) INTO v_uspesnih
    FROM istrazivac_izvodjenje ii JOIN izvodjenje izv ON izv.izvodjenje_id = ii.izvodjenje_id
    WHERE ii.istrazivac_id = p_istrazivac_id AND izv.status_id = v_uspesno_status_id;

    RETURN ROUND(v_uspesnih * 100.0 / v_ukupno, 2);
END //

DELIMITER ;


-- Test funkcija koja testira gornju fju
DELIMITER //

CREATE FUNCTION test_procenat_uspesnih_izvodjenja()
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_rezultat DOUBLE;

	-- Test 1: istrazivac 15, ocekivano 60.0
	SET v_rezultat = procenat_uspesnih_izvodjenja(15);
	IF v_rezultat IS NULL OR v_rezultat <> 60.0 THEN
		RETURN FALSE;
	END IF;

	-- Test 2: istrazivac 60, ocekivano 50.0
	SET v_rezultat = procenat_uspesnih_izvodjenja(60);
	IF v_rezultat IS NULL OR v_rezultat <> 50.0 THEN
		RETURN FALSE;
	END IF;

	-- Test 3: istrazivac 95, ocekivano 20.0
	SET v_rezultat = procenat_uspesnih_izvodjenja(95);
	IF v_rezultat IS NULL OR v_rezultat <> 20.0 THEN
		RETURN FALSE;
	END IF;

	-- Test 4: istrazivac 25 (bez izvodjenja), ocekivano NULL
	SET v_rezultat = procenat_uspesnih_izvodjenja(25);
	IF v_rezultat IS NOT NULL THEN
		RETURN FALSE;
	END IF;

	-- Test 5: istrazivac 99999 (ne postoji), ocekivano NULL
	SET v_rezultat = procenat_uspesnih_izvodjenja(99999);
	IF v_rezultat IS NOT NULL THEN
		RETURN FALSE;
	END IF;

	RETURN TRUE;
END //

DELIMITER ;
