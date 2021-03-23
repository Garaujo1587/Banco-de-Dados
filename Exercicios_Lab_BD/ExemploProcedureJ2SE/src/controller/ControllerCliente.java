package controller;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.SQLException;

import javax.swing.JOptionPane;
import javax.swing.JTextField;

import model.Cliente;
import persistence.ClienteDao;

public class ControllerCliente implements ActionListener {
	
	private JTextField tfNome;
	private JTextField tfTelefone;
	
	public ControllerCliente(JTextField tfNome, JTextField tfTelefone) {
		this.tfNome = tfNome;
		this.tfTelefone = tfTelefone;
	}

	@Override
	public void actionPerformed(ActionEvent arg0) {
		try {
			insereCliente();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	private void insereCliente() throws ClassNotFoundException, SQLException {
		Cliente cli = new Cliente();
		cli.setNome(tfNome.getText());
		cli.setTelefone(tfTelefone.getText());
		
		ClienteDao cDao = new ClienteDao();
		String saida = cDao.procCliente(cli);
		JOptionPane.showMessageDialog(null, saida, "MENSAGEM", JOptionPane.INFORMATION_MESSAGE);
		
		tfNome.setText("");
		tfTelefone.setText("");
	}

}
