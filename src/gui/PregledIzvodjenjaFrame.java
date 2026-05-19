package gui;

import controller.pregled.PregledIzvodjenjaController;
import controller.pregled.StatusController;
import model.dto.IzvodjenjeDto;
import model.dto.StatusDto;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class PregledIzvodjenjaFrame extends JFrame {

    private JComboBox<StatusDto> statusComboBox;
    private JTable tabela;
    private DefaultTableModel model;

    public PregledIzvodjenjaFrame() {
        initComponents();
        ucitajPodatke();
    }

    private void initComponents() {
        setTitle("Pregled izvodjenja");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(900, 500);
        setLocationRelativeTo(null);

        JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        topPanel.add(new JLabel("Filter po statusu:"));

        statusComboBox = new JComboBox<>();
        statusComboBox.addItem(null);
        List<StatusDto> statusi = StatusController.ucitajSve();
        for (StatusDto s : statusi) {
            statusComboBox.addItem(s);
        }
        statusComboBox.setRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(JList<?> list, Object value, int index,
                                                          boolean isSelected, boolean cellHasFocus) {
                super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
                if (value == null) {
                    setText("Svi");
                }
                return this;
            }
        });
        statusComboBox.addActionListener(e -> ucitajPodatke());
        topPanel.add(statusComboBox);

        JButton btnOsvezi = new JButton("Osvezi");
        btnOsvezi.addActionListener(e -> ucitajPodatke());
        topPanel.add(btnOsvezi);

        JButton btnZatvori = new JButton("Zatvori");
        btnZatvori.addActionListener(e -> dispose());
        topPanel.add(btnZatvori);

        String[] kolone = {"Eksperiment", "Tip merenja", "Fizicka velicina", "Datum", "Status", "Rezultat", "Nesigurnost"};
        model = new DefaultTableModel(kolone, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        tabela = new JTable(model);
        JScrollPane scrollPane = new JScrollPane(tabela);

        setLayout(new BorderLayout());
        add(topPanel, BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);
    }

    private void ucitajPodatke() {
        model.setRowCount(0);
        StatusDto izabrani = (StatusDto) statusComboBox.getSelectedItem();
        Integer statusId = izabrani == null ? null : izabrani.getId();

        List<IzvodjenjeDto> lista = PregledIzvodjenjaController.ucitaj(statusId);
        for (IzvodjenjeDto dto : lista) {
            model.addRow(new Object[]{
                    dto.getEksperiment(),
                    dto.getTipMerenja(),
                    dto.getFizickaVelicina(),
                    dto.getDatum(),
                    dto.getStatus(),
                    dto.getRezultat() == null ? "-" : dto.getRezultat(),
                    dto.getMernaNesigurnost() == null ? "-" : dto.getMernaNesigurnost()
            });
        }
    }
}