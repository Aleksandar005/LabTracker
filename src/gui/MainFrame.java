package gui;

import model.Session;

import javax.swing.*;
import java.awt.*;

import gui.dialogs.DeleteSessionDialog;
import model.dto.SessionDto;

import util.Config;
import java.util.List;
public class MainFrame extends JFrame {

    public MainFrame() {
        initComponents();
    }

    private void initComponents() {
        setTitle("LabTracker - Glavni meni");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(450, 300);
        setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel(new GridBagLayout());
        mainPanel.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(8, 5, 8, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.gridx = 0;

        JLabel welcomeLabel = new JLabel("Dobrodosli, " + Session.getIme() + " " + Session.getPrezime(),
                SwingConstants.CENTER);
        welcomeLabel.setFont(new Font("SansSerif", Font.BOLD, 14));
        gbc.gridy = 0;
        mainPanel.add(welcomeLabel, gbc);

        JButton btnPregled = new JButton("Pregled eksperimenata");
        gbc.gridy = 1;
        mainPanel.add(btnPregled, gbc);

        JButton btnPromena = new JButton("Promena statusa izvodjenja");
        gbc.gridy = 2;
        mainPanel.add(btnPromena, gbc);

        JButton btnBrisanje = new JButton("Brisanje sesije");
        gbc.gridy = 3;
        mainPanel.add(btnBrisanje, gbc);

        btnPregled.addActionListener(e -> JOptionPane.showMessageDialog(this,
                "Forma jos nije implementirana."));
        btnPromena.addActionListener(e -> JOptionPane.showMessageDialog(this,
                "Forma jos nije implementirana."));

        btnBrisanje.addActionListener(e -> {

            List<SessionDto> sessionDtos =
                    SessionDto.readAll(Config.getConnection());

            DeleteSessionDialog dialog =
                    new DeleteSessionDialog(sessionDtos);

            dialog.setVisible(true);
        });

        add(mainPanel);
    }
}