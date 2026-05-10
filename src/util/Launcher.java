package util;

public class Launcher {

    public static void launch(String[] args) {
        setUp(args);
        work();
    }

    private static void setUp(String[] args) {
        String cfgFile = args.length > 0 ? args[0] : "database.properties";
        Config.loadProperties(cfgFile);
        String host = Config.getPropertyValue("host", "localhost");
        String port = Config.getPropertyValue("port", "3306");
        String db = Config.getPropertyValue("db", "labtracker");
        String user = Config.getPropertyValue("user", "root");
        String password = Config.getPropertyValue("password", "");
        Config.connect(host, port, db, user, password);
    }

    private static void work() {
        new gui.LoginFrame().setVisible(true);
    }

    private Launcher() {
    }
}