package model.dto;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.sql.Date;
import java.util.List;

public class SessionDto {

    public static List<SessionDto> readAll(Connection connection){
        String query = "Select sesija_id, datum, vreme_pocetka, vreme_zavrsetka, temperatura, vlaznost, pritisak, izvodjenje_id, laboratorija_id FROM sesija";
        try{
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(query);
            List<SessionDto> sessionDtos = new ArrayList<>();
            while(rs.next()){
                int sesijaId = rs.getInt("sesija_id");
                Date datum = rs.getDate("datum");
                Time vremePocetka = rs.getTime("vreme_pocetka");
                Time vremeZavrsetka = rs.getTime("vreme_zavrsetka");
                Double temperatura = (Double) rs.getObject("temperatura");
                Double vlaznost = (Double) rs.getObject("vlaznost");
                Double pritisak = (Double) rs.getObject("pritisak");
                int izvodjenjeId = rs.getInt("izvodjenje_id");
                int laboratorijaId = rs.getInt("laboratorija_id");
                SessionDto sessionDto = new SessionDto(sesijaId,datum,vremePocetka,vremeZavrsetka,temperatura,vlaznost,pritisak,izvodjenjeId,laboratorijaId);
                sessionDtos.add(sessionDto);
            }
            return sessionDtos;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

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
