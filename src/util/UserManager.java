package util;

import model.User;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserManager {
    private static final String FILE_PATH = "data/users.txt";

    public UserManager(){
        File file = new File(FILE_PATH);

        // Pretpostavicemo da fajl svakako postoji po defaultu, a ako ne postoji, samo neka izbaci neku gresku.
        // Ovo eventualno kasnije mogu napraviti malo pametnijim tipa da on sam napravi taj fajl ili tako nesto,
        // al verovatno nema potrebe

        if(!file.exists()){
            System.err.println("Greska pri kreiranju fajla: Fajl ne postoji");
        }
    }

    public boolean registerUser(String username, String password){
        // Vracamo false ako user nije uspesno registrovan, u suprotonom vracamo true
        if(username == null || username.trim().isEmpty()){
            return false;
        }
        if(password == null || password.trim().isEmpty()){
            return false;
        }
        // Ne mogu postojati dva usera sa istim usernamovima
        if (usernameExists(username)) {
            return false;
        }

        try(BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))){
            writer.write(username + ";" + password);
            writer.newLine();
            return true;
        } catch (IOException e){
            System.err.println("Greska pri upisivanju korisnika: " + e.getMessage());
            return false;
        }
    }

    // Ovo je za prijavu korisnika
    public boolean loginUser(String username, String password){
        List<User> users = loadUsers();

        for(User u : users){
            if(u.getUsername().equals(username) && u.getPassword().equals(password)){
                return true;
            }
        }

        return false;
    }

    // Ovo proverava postojanje username (cisto da ne bi postojala dva identicna)
    public boolean usernameExists(String username){
        List<User> users = loadUsers();

        for(User u : users){
            if(username.equals(u.getUsername())){
                return true;
            }
        }

        return false;
    }

    // Ucitaj mi sve usere iz fajla
    public List<User> loadUsers() {
        List<User> users = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(";"); // npr odvajamo tacka zarezom

                if (parts.length == 2) {
                    users.add(new User(parts[0], parts[1]));
                }
            }
        } catch (IOException e) {
            System.err.println("Greska pri citanju korisnika: " + e.getMessage());
        }

        return users;
    }
}
