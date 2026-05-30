package model.dto;

import java.sql.Time;
import java.sql.Date;

public class SessionDto {
    private final int sesijaId;
    private final Date datum;
    private final Time vremePocetka;
    private final Time vremeZavrsetka;
    private final Double temperatura;
    private final Double vlaznost;
    private final Double pritisak;
    private final int izvodjenjeId;
    private final int laboratorijaId;

    public SessionDto(int sesijaId, Date datum, Time vremePocetka, Time vremeZavrsetka, Double temperatura, Double vlaznost, Double pritisak, int izvodjenjeId, int laboratorijaId) {
        this.sesijaId = sesijaId;
        this.datum = datum;
        this.vremePocetka = vremePocetka;
        this.vremeZavrsetka = vremeZavrsetka;
        this.temperatura = temperatura;
        this.vlaznost = vlaznost;
        this.pritisak = pritisak;
        this.izvodjenjeId = izvodjenjeId;
        this.laboratorijaId = laboratorijaId;
    }

    public int getSesijaId() {
        return sesijaId;
    }

    public Date getDatum() {
        return datum;
    }

    public Time getVremePocetka() {
        return vremePocetka;
    }

    public Time getVremeZavrsetka() {
        return vremeZavrsetka;
    }

    public Double getTemperatura() {
        return temperatura;
    }

    public Double getVlaznost() {
        return vlaznost;
    }

    public Double getPritisak() {
        return pritisak;
    }

    public int getIzvodjenjeId() {
        return izvodjenjeId;
    }

    public int getLaboratorijaId() {
        return laboratorijaId;
    }
}
