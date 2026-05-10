import util.Config;
import util.Launcher;

public class Main {
    public static void main(String[] args) {
        Runtime.getRuntime().addShutdownHook(new Thread(Config::disconnect));
        Launcher.launch(args);
    }
}