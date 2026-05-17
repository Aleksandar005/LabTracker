package gui.dialogs;

import controller.brisanje.DeleteSessionController;
import gui.tables.SessionTable;
import model.dto.SessionDto;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class DeleteSessionDialog extends JDialog {

    public DeleteSessionDialog(List<SessionDto> sessionDtos) {

        setTitle("Brisanje sesije");

        setSize(700, 400);

        setLocationRelativeTo(null);

        setModal(true);

        setLayout(new BorderLayout());

        // tabela
        SessionTable table = new SessionTable(sessionDtos);

        JScrollPane scrollPane = new JScrollPane(table);

        add(scrollPane, BorderLayout.CENTER);

        // dugme
        JButton btnDelete = new JButton("Obriši");


        btnDelete.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if(selectedRow == -1){
                JOptionPane.showMessageDialog(this,
                        "Morate izabrati sesiju.");
                return;
            }

            int izvodjenjeId = (int) table.getValueAt(selectedRow,6);
            boolean success = DeleteSessionController.deleteSession(izvodjenjeId);

            if(!success){
                JOptionPane.showMessageDialog(this,"Niste član ove sesije, brisanje nije dozvoljeno");
                return;
            }
            DefaultTableModel model = (DefaultTableModel) table.getModel();
            model.removeRow(selectedRow);
            JOptionPane.showMessageDialog(this,"Uspesno obrisana sesija");
        });

        add(btnDelete, BorderLayout.SOUTH);
    }
}