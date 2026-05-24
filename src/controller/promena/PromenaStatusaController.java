package controller.promena;

import util.Config;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class PromenaStatusaController {

    public static boolean promeniStatus(int izvodjenjeId, int statusId) {
        Connection connection = Config.getConnection();

        String query = "UPDATE izvodjenje " +
                "SET status_id = ? " +
                "WHERE izvodjenje_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, statusId);
            ps.setInt(2, izvodjenjeId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}