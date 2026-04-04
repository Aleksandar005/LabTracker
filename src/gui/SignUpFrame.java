package gui;

import util.UserManager;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

// Ova klasa je napravljena uz pomoc AI-a (zbog gui karakteristika)
public class SignUpFrame extends JFrame {
    private JTextField usernameField;
    private JPasswordField passwordField;
    private JPasswordField confirmPasswordField;
    private JButton signUpButton;
    private JButton goToLoginButton;
    private UserManager userManager;

    public SignUpFrame() {
        userManager = new UserManager();
        initComponents();
    }

    private void initComponents() {
        setTitle("Registracija");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(400, 300);
        setLocationRelativeTo(null);
        setResizable(false);

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new GridBagLayout());
        mainPanel.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // naslov
        JLabel titleLabel = new JLabel("Registracija novog korisnika", SwingConstants.CENTER);
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

        // potvrda lozinke
        gbc.gridy = 3;
        gbc.gridx = 0;
        mainPanel.add(new JLabel("Potvrda lozinke:"), gbc);

        confirmPasswordField = new JPasswordField(15);
        gbc.gridx = 1;
        mainPanel.add(confirmPasswordField, gbc);

        // dugmad
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 0));
        signUpButton = new JButton("Registruj se");
        goToLoginButton = new JButton("Nazad na prijavu");
        buttonPanel.add(signUpButton);
        buttonPanel.add(goToLoginButton);

        gbc.gridy = 4;
        gbc.gridx = 0;
        gbc.gridwidth = 2;
        mainPanel.add(buttonPanel, gbc);

        add(mainPanel);

        // listeneri
        signUpButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                handleSignUp();
            }
        });

        goToLoginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                goBackToLogin();
            }
        });
    }

    private void handleSignUp() {
        String username = usernameField.getText().trim();
        String password = new String(passwordField.getPassword());
        String confirmPassword = new String(confirmPasswordField.getPassword());

        if (username.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Sva polja moraju biti popunjena.",
                    "Greska", JOptionPane.WARNING_MESSAGE);
            return;
        }

        if (username.contains(";")) {
            JOptionPane.showMessageDialog(this,
                    "Korisnicko ime ne sme sadrzati znak ';'.",
                    "Greska", JOptionPane.WARNING_MESSAGE);
            return;
        }

        if (!password.equals(confirmPassword)) {
            JOptionPane.showMessageDialog(this,
                    "Lozinke se ne poklapaju.",
                    "Greska", JOptionPane.WARNING_MESSAGE);
            return;
        }

        if (userManager.registerUser(username, password)) {
            JOptionPane.showMessageDialog(this,
                    "Uspesna registracija! Mozete se prijaviti.",
                    "Uspeh", JOptionPane.INFORMATION_MESSAGE);
            goBackToLogin();
        } else {
            JOptionPane.showMessageDialog(this,
                    "Korisnicko ime vec postoji ili je doslo do greske.",
                    "Greska", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void goBackToLogin() {
        new LoginFrame().setVisible(true);
        this.dispose();
    }
}