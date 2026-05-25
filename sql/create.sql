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


-- Procedura koja se poziva pri zavrsetku sesije
-- Ona postavlja status izvodjenja na "zavrseno_uspesno" i smanjuje kolicinu resursa u laboratoriji
-- za onoliko koliko ih je korisceno u toj sesiji.
-- Ako jedna operacija ne uspe, ceopostupak se ponistava. Procedura takodje proverava da li sesija uopste postoji
-- da li je izvodjenje vec zavrseno i da li inverntar laboratorije ne pada u negativno

DELIMITER //

CREATE PROCEDURE zavrsi_sesiju(IN p_sesija_id INT)
BEGIN
    DECLARE v_izvodjenje_id INT DEFAULT NULL;
    DECLARE v_laboratorija_id INT;
    DECLARE v_uspesno_status_id INT;
    DECLARE v_trenutni_status_id INT;
    DECLARE v_nedostaje INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Citamo izvodjenje_id i laboratorija_id iz sesije
    SELECT izvodjenje_id, laboratorija_id INTO v_izvodjenje_id, v_laboratorija_id
    FROM sesija WHERE sesija_id = p_sesija_id;

    -- Da li sesija postoji provera
    IF v_izvodjenje_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sesija sa zadatim id-jem ne postoji.';
    END IF;

    -- Citamo status_id samo za za zavrseno_uspesno
    SELECT status_id INTO v_uspesno_status_id
    FROM status_izvodjenja WHERE naziv = 'zavrseno_uspesno';

    -- Citami trenutni status izvodjenja
    SELECT status_id INTO v_trenutni_status_id
    FROM izvodjenje WHERE izvodjenje_id = v_izvodjenje_id;

    -- Provera da izvodjenje nije vec zavrseno mozda
    IF v_trenutni_status_id = v_uspesno_status_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Izvodjenje je vec zavrseno uspesno.';
    END IF;

    -- Provera da inventar laboratorije ne bi pao u negativno
    SELECT COUNT(*) INTO v_nedostaje
    FROM sesija_resurs sr
    JOIN laboratorija_resurs lr
        ON lr.resurs_id = sr.resurs_id AND lr.laboratorija_id = v_laboratorija_id
    WHERE sr.sesija_id = p_sesija_id AND lr.kolicina < sr.kolicina;

    IF v_nedostaje > 0 THEN
    		SIGNAL SQLSTATE '45000'
    			SET MESSAGE_TEXT = 'Nema dovoljno resursa u inventaru za ovu sesiju.';
    END IF;

    -- Smanjujemo kolicinu resursa u lab
    UPDATE laboratorija_resurs lr
    JOIN sesija_resurs sr ON sr.resurs_id = lr.resurs_id
    SET lr.kolicina = lr.kolicina - sr.kolicina
    WHERE sr.sesija_id = p_sesija_id AND lr.laboratorija_id = v_laboratorija_id;

    -- Postavi status izvodjenja na zavrseno_uspesno
    UPDATE izvodjenje
    SET status_id = v_uspesno_status_id WHERE izvodjenje_id = v_izvodjenje_id;

   	COMMIT;
END //

DELIMITER ;