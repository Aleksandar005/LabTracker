package gui;

import util.UserManager;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

// Ova klasa je napravljena uz pomoc AI-a (zbog gui karakteristika)
public class LoginFrame extends JFrame {
    private JTextField usernameField;
    private JPasswordField passwordField;
    private JButton loginButton;
    private JButton goToSignUpButton;
    private UserManager userManager;

    public LoginFrame() {
        userManager = new UserManager();
        initComponents();
    }

    private void initComponents() {
        setTitle("Prijava");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(400, 250);
        setLocationRelativeTo(null);
        setResizable(false);

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new GridBagLayout());
        mainPanel.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // naslov
        JLabel titleLabel = new JLabel("Prijava na sistem", SwingConstants.CENTER);
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 16));
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 2;
        mainPanel.add(titleLabel, gbc);

        // korisnicko ime
        gbc.gridwidth = 1;
        gbc.gridy = 1;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Korisnicko ime:"), gbc);

        usernameField = new JTextField(15);
        gbc.gridx = 1;
        mainPanel.add(usernameField, gbc);

        // lozinka
        gbc.gridy = 2;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Lozinka:"), gbc);

        passwordField = new JPasswordField(15);
        gbc.gridx = 1;
        mainPanel.add(passwordField, gbc);

        // dugmad
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 0));
        loginButton = new JButton("Prijavi se");
        goToSignUpButton = new JButton("Registruj se");
        buttonPanel.add(loginButton);
        buttonPanel.add(goToSignUpButton);

        gbc.gridy = 3;
        gbc.gridx = 0;
        gbc.gridwidth = 2;
        mainPanel.add(buttonPanel, gbc);

        add(mainPanel);

        // listeneri
        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                handleLogin();
            }
        });

        goToSignUpButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                openSignUp();
            }
        });
    }

    private void handleLogin() {
        String username = usernameField.getText().trim();
        String password = new String(passwordField.getPassword());

        if (username.isEmpty() || password.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Unesite korisnicko ime i lozinku.",
                    "Greska", JOptionPane.WARNING_MESSAGE);
            return;
        }

        if (userManager.loginUser(username, password)) {
            JOptionPane.showMessageDialog(this,
                    "Uspesna prijava! Dobrodosli, " + username + ".",
                    "Uspeh", JOptionPane.INFORMATION_MESSAGE);
            // TODO: otvoriti glavni prozor aplikacije
        } else {
            JOptionPane.showMessageDialog(this,
                    "Pogresno korisnicko ime ili lozinka.",
                    "Greska", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void openSignUp() {
        new SignUpFrame().setVisible(true);
        this.dispose();
    }
}
