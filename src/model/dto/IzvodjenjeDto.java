package model.dto;

public class IzvodjenjeDto {

    private final int izvodjenjeId;
    private final String eksperiment;
    private final String tipMerenja;
    private final String fizickaVelicina;
    private final String datum;
    private final String status;
    private final Double rezultat;
    private final Double mernaNesigurnost;

    public IzvodjenjeDto(int izvodjenjeId, String eksperiment, String tipMerenja, String fizickaVelicina,
                         String datum, String status, Double rezultat, Double mernaNesigurnost) {
        this.izvodjenjeId = izvodjenjeId;
        this.eksperiment = eksperiment;
        this.tipMerenja = tipMerenja;
        this.fizickaVelicina = fizickaVelicina;
        this.datum = datum;
        this.status = status;
        this.rezultat = rezultat;
        this.mernaNesigurnost = mernaNesigurnost;
    }

    public int getIzvodjenjeId() { return izvodjenjeId; }
    public String getEksperiment() { return eksperiment; }
    public String getTipMerenja() { return tipMerenja; }
    public String getFizickaVelicina() { return fizickaVelicina; }
    public String getDatum() { return datum; }
    public String getStatus() { return status; }
    public Double getRezultat() { return rezultat; }
    public Double getMernaNesigurnost() { return mernaNesigurnost; }
}
