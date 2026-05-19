package controller.pregled;

import model.dto.StatusDto;
import util.Config;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StatusController {

    public static List<StatusDto> ucitajSve() {
        Connection connection = Config.getConnection();
        String query = "SELECT status_id, naziv FROM status_izvodjenja";
        List<StatusDto> statusi = new ArrayList<>();
        try {
            Statement st = connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                statusi.add(new StatusDto(rs.getInt("status_id"), rs.getString("naziv")));
            }
            return statusi;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}