package controller.brisanje;

import model.Session;
import util.Config;
import model.dto.SessionDto;
import java.util.ArrayList;
import java.util.List;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DeleteSessionController {

    public static boolean deleteSession(int izvodjenjeId, int sesijaId) {
        Connection connection = Config.getConnection();

        int istrazivacId = Session.getIstrazivacId();

        String query = "SELECT * FROM istrazivac_izvodjenje " +
                        "WHERE izvodjenje_id = ?" +
                        " AND istrazivac_id = ?";

        try{
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, izvodjenjeId);
            ps.setInt(2,istrazivacId);

            ResultSet rs = ps.executeQuery();
            if(!rs.next()){
                return false;
            }

            String deleteQuery = "DELETE FROM sesija " +
                                "WHERE sesija_id = ?";

            PreparedStatement ps2 = connection.prepareStatement(deleteQuery);
            ps2.setInt(1, sesijaId);
            ps2.executeUpdate();
            return true;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public static List<SessionDto> ucitajSve() {
        Connection connection = Config.getConnection();
        int istrazivacId = Session.getIstrazivacId();

        String query = "SELECT s.sesija_id, s.datum, s.vreme_pocetka, s.vreme_zavrsetka, " +
                "s.temperatura, s.vlaznost, s.pritisak, s.izvodjenje_id, s.laboratorija_id " +
                "FROM sesija s " + "JOIN istrazivac_izvodjenje ii ON ii.izvodjenje_id = s.izvodjenje_id " +
                "WHERE ii.istrazivac_id = ?";

        List<SessionDto> sesije = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, istrazivacId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SessionDto dto = new SessionDto(
                        rs.getInt("sesija_id"),
                        rs.getDate("datum"),
                        rs.getTime("vreme_pocetka"),
                        rs.getTime("vreme_zavrsetka"),
                        (Double) rs.getObject("temperatura"),
                        (Double) rs.getObject("vlaznost"),
                        (Double) rs.getObject("pritisak"),
                        rs.getInt("izvodjenje_id"),
                        rs.getInt("laboratorija_id")
                );
                sesije.add(dto);
            }
            return sesije;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
