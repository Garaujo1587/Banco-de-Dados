package persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

import model.Cliente;

public class ClienteDao {

	private Connection c;
	
	public ClienteDao() throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		c = gDao.getConnection();
	}
	
	public String procCliente(Cliente cli) throws SQLException {
		String sql = "{CALL sp_proc (?, ?, ?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, cli.getNome());
		cs.setString(2, cli.getTelefone());
		cs.registerOutParameter(3, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(3);
		cs.close();
		
		return saida;
	}
	
}
