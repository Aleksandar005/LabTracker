package controller.pregled;

import model.dto.IzvodjenjeDto;
import model.Session;
import util.Config;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PregledIzvodjenjaController {

    public static List<IzvodjenjeDto> ucitaj(Integer statusId) {
        Connection connection = Config.getConnection();
        int istrazivacId = Session.getIstrazivacId();

        String query = "SELECT DISTINCT izv.izvodjenje_id, e.naziv AS eksperiment, " +
                "tm.naziv AS tip_merenja, e.fizicka_velicina, izv.datum, " +
                "s.naziv AS status, izv.rezultat, izv.merna_nesigurnost " +
                "FROM izvodjenje izv " +
                "JOIN eksperiment e ON izv.eksperiment_id = e.eksperiment_id " +
                "JOIN tip_merenja tm ON e.tip_merenja_id = tm.tip_merenja_id " +
                "JOIN status_izvodjenja s ON izv.status_id = s.status_id " +
                "LEFT JOIN istrazivac_izvodjenje ii ON ii.izvodjenje_id = izv.izvodjenje_id " +
                "LEFT JOIN eksperiment_dizajner ed ON ed.eksperiment_id = e.eksperiment_id " +
                "WHERE (ii.istrazivac_id = ? OR ed.istrazivac_id = ?) ";

        if (statusId != null) {
            query += "AND izv.status_id = ? ";
        }
        query += "ORDER BY izv.datum DESC";

        List<IzvodjenjeDto> rezultati = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, istrazivacId);
            ps.setInt(2, istrazivacId);
            if (statusId != null) {
                ps.setInt(3, statusId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                IzvodjenjeDto dto = new IzvodjenjeDto(
                        rs.getInt("izvodjenje_id"),
                        rs.getString("eksperiment"),
                        rs.getString("tip_merenja"),
                        rs.getString("fizicka_velicina"),
                        rs.getDate("datum").toString(),
                        rs.getString("status"),
                        rs.getObject("rezultat") == null ? null : rs.getDouble("rezultat"),
                        rs.getObject("merna_nesigurnost") == null ? null : rs.getDouble("merna_nesigurnost")
                );
                rezultati.add(dto);
            }
            return rezultati;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}