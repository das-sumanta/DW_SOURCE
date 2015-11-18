

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Test {

	public static void main(String[] args) throws SQLException {
		
		String error_sql="";
		Connection con=null;
		PreparedStatement ps = null;
		try {

			Class.forName("com.amazon.redshift.jdbc41.Driver");
			con = DriverManager.getConnection("jdbc:redshift://si-dw-poc.cjw3lezcuz9j.us-east-1.redshift.amazonaws.com:5439/sintl", "kdas", "dKle7x@L");
			System.out.println("System is Ready..");
			
			ScriptRunner scriptRunner = new ScriptRunner(con,false, true, 5, "purchase_order");

			String aSQLScriptFilePath = "D:\\Sumanta\\Queries\\purchase_order.sql";
			
			scriptRunner.runScript(new FileReader(aSQLScriptFilePath));

		} catch (ClassNotFoundException e) {

			System.out.println("Error loading Redshift Database Libreries.\n"
					+ e.getMessage());

		} catch (SQLException e) {

			System.out
					.println("Error\n"
							+ e.getMessage());
			
			/*error_sql = "INSERT INTO dw_prestage.message_log(runid,message_desc,target_table,message_stage,message_type,message_timestamp) "
				+ "VALUES(?,?,?,?,?,?)";
			
			ps = con.prepareStatement(error_sql);
			ps.setInt(1, 0);
			ps.setString(2, e.getMessage());
			ps.setString(3, "");
			ps.setString(4, e.getMessage());
			ps.executeUpdate();*/
					
		} catch (FileNotFoundException e) {
			
			e.printStackTrace();
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
		
				

	}

}
