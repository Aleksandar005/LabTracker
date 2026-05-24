package gui.tables;

import model.dto.IzvodjenjeDto;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.util.List;

public class IzvodjenjaTable extends JTable {

    public IzvodjenjaTable(List<IzvodjenjeDto> izvodjenjeDtos) {

        String[] columns = {"Izvodjenje", "Eksperiment", "Tip merenja", "Fizicka velicina", "Datum", "Status", "Rezultat", "Merna nesigurnost"};

        DefaultTableModel model = new DefaultTableModel(columns,0);

        for(IzvodjenjeDto izvodjenjeDto: izvodjenjeDtos){
            model.addRow(new Object[]{
                    izvodjenjeDto.getIzvodjenjeId(),
                    izvodjenjeDto.getEksperiment(),
                    izvodjenjeDto.getTipMerenja(),
                    izvodjenjeDto.getFizickaVelicina(),
                    izvodjenjeDto.getDatum(),
                    izvodjenjeDto.getStatus(),
                    izvodjenjeDto.getRezultat(),
                    izvodjenjeDto.getMernaNesigurnost()
            });
        }

        setModel(model);

    }
}
