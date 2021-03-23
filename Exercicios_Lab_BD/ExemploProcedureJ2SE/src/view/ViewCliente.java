package view;

import java.awt.EventQueue;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.EmptyBorder;

import controller.ControllerCliente;


public class ViewCliente extends JFrame {
	
	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField tfNome;
	private JTextField tfTelefone;
	
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					ViewCliente frame = new ViewCliente();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}	
		});
	}
	
	public ViewCliente() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		tfNome = new JTextField();
		tfNome.setBounds(84, 47, 299, 20);
		contentPane.add(tfNome);
		tfNome.setColumns(10);
		
		JLabel lblNome = new JLabel("Nome");
		lblNome.setBounds(10, 50, 64, 14);
		contentPane.add(lblNome);
		
		JLabel lblTelefone = new JLabel("Telefone");
		lblTelefone.setBounds(10, 83, 64, 14);
		contentPane.add(lblTelefone);
		
		tfTelefone = new JTextField();
		tfTelefone.setBounds(84, 80, 119, 20);
		contentPane.add(tfTelefone);
		tfTelefone.setColumns(10);
		
		JButton btnEnviar = new JButton("Enviar");
		btnEnviar.setBounds(10, 131, 89, 23);
		contentPane.add(btnEnviar);
		
		ActionListener chamadaCliente = new ControllerCliente(tfNome, tfTelefone);
		btnEnviar.addActionListener(chamadaCliente);
		tfTelefone.addActionListener(chamadaCliente);
	}

}
