package gui.tables;

import model.dto.SessionDto;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.util.List;

public class SessionTable extends JTable {

    public SessionTable(List<SessionDto> sessionDtos) {

        String[] columns = {"datum", "vreme_pocetka", "vreme_zavrsetka", "temperatura", "vlaznost", "pritisak", "izvodjenje"};

        DefaultTableModel model = new DefaultTableModel(columns,0);

        for (SessionDto s : sessionDtos) {
            model.addRow(new Object[]{
                    s.getDatum(),
                    s.getVremePocetka(),
                    s.getVremeZavrsetka(),
                    s.getTemperatura(),
                    s.getVlaznost(),
                    s.getPritisak(),
                    s.getIzvodjenjeId()
            });
        }

        setModel(model);
    }
}