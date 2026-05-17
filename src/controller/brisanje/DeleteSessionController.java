package controller.brisanje;

import model.Session;
import util.Config;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DeleteSessionController {

    public static boolean deleteSession(int izvodjenjeId) {
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
                                "WHERE izvodjenje_id = ?";

            PreparedStatement ps2 = connection.prepareStatement(deleteQuery);
            ps2.setInt(1,izvodjenjeId);
            ps2.executeUpdate();
            return true;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
