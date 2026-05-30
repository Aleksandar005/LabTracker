package gui;

import controller.IzvodjenjaController;
import controller.StatusController;
import controller.promena.PromenaStatusaController;
import gui.tables.IzvodjenjaTable;
import model.dto.IzvodjenjeDto;
import model.dto.StatusDto;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class PromenaStatusaIzvodjenjaDialog extends JDialog {

    public PromenaStatusaIzvodjenjaDialog() {

        setTitle("Promena statusa");
        setSize(1000, 600);
        setLocationRelativeTo(null);
        setModal(true);

        // glavni panel
        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout(10, 10));

        // margine oko svega
        mainPanel.setBorder(new EmptyBorder(15, 15, 15, 15));

        // tabela
        List<IzvodjenjeDto> izvodjenjeDtos = IzvodjenjaController.ucitaj(null);
        IzvodjenjaTable tabela = new IzvodjenjaTable(izvodjenjeDtos);
        JScrollPane scrollPane = new JScrollPane(tabela);

        mainPanel.add(scrollPane, BorderLayout.CENTER);

        // donji panel
        JPanel bottomPanel = new JPanel();
        bottomPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 10));

        // combo box
        JComboBox<StatusDto> statusComboBox = new JComboBox<>();

        statusComboBox.addItem(null);

        List<StatusDto> statusi = StatusController.ucitajSve();

        for (StatusDto s : statusi) {
            statusComboBox.addItem(s);
        }

        statusComboBox.setRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(
                    JList<?> list,
                    Object value,
                    int index,
                    boolean isSelected,
                    boolean cellHasFocus) {

                super.getListCellRendererComponent(
                        list, value, index, isSelected, cellHasFocus);

                if (value == null) {
                    setText("Odaberite status");
                }

                return this;
            }
        });

        JButton btnSave = new JButton("Sačuvaj");

        btnSave.addActionListener(e -> {
            int selectedRow = tabela.getSelectedRow();
            StatusDto izabrani = (StatusDto) statusComboBox.getSelectedItem();
            if(selectedRow == -1 || izabrani == null){
                JOptionPane.showMessageDialog(this, "Morate izabrati izvodjenje i status.");
                return;
            }

            int izvodjenjeId = (int) tabela.getValueAt(selectedRow,0);
            int statusKolona = tabela.getColumnModel().getColumnIndex("Status");
            String trenutniStatus = (String) tabela.getValueAt(selectedRow, statusKolona);
            if (trenutniStatus.equals(izabrani.getNaziv())) {
                JOptionPane.showMessageDialog(this, "Izvodjenje vec ima taj status.");
                return;
            }
            int statusId = izabrani.getId();
            boolean success = PromenaStatusaController.promeniStatus(izvodjenjeId,statusId);

            if(!success){
                JOptionPane.showMessageDialog(this,"Doslo je do greske, probajte ponovo");
                return;
            }

            DefaultTableModel model = (DefaultTableModel) tabela.getModel();
            model.setValueAt(izabrani.getNaziv(), selectedRow, statusKolona);

            JOptionPane.showMessageDialog(this, "Status je uspešno promenjen.");


        });

        bottomPanel.add(statusComboBox);
        bottomPanel.add(btnSave);

        mainPanel.add(bottomPanel, BorderLayout.SOUTH);

        add(mainPanel);
    }
}