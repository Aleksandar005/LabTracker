package model;

public class Session {

    private static int istrazivacId;
    private static String ime;
    private static String prezime;
    private static String kontakt;

    public static void set(int id, String ime, String prezime, String kontakt) {
        Session.istrazivacId = id;
        Session.ime = ime;
        Session.prezime = prezime;
        Session.kontakt = kontakt;
    }

    public static int getIstrazivacId() {
        return istrazivacId;
    }

    public static String getIme() {
        return ime;
    }

    public static String getPrezime() {
        return prezime;
    }

    public static String getKontakt() {
        return kontakt;
    }

    private Session() {
    }
}