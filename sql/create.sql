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