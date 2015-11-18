

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.sql.Statement;
import java.util.Properties;

import com.amazonaws.AmazonClientException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;

public class RelationerDataLoaderForSubsidiery {

	private String appConfigPropFile;
	private String msUid;
	private String msPwd;
	private String conStrMS;
	private String msClass;
	private Connection msCon;
	private String baseTbl;
	private String refTbl;
	private String finalTbl;
	private int hierarchyDepth;
	private String awsProfile;
	private String accKey;
	private String scrtKey;
	private String redShiftSchemaNamePreStage;
	private String redShiftSchemaNameStage;
	private String redShiftSchemaNameFinal;
	public RelationerDataLoaderForSubsidiery() {

		appConfigPropFile = "config.properties";
		Properties properties = new Properties();
		File pf = new File(appConfigPropFile);
		try {
			properties.load(new FileReader(pf));

		} catch (IOException e) {

			System.out.println("Error loading properties file.\n"
					+ e.getMessage());
		}

		msUid = properties.getProperty("RSUID");
		msPwd = properties.getProperty("RSPWD");
		conStrMS = properties.getProperty("RSDBURL");
		msClass = properties.getProperty("MySqlClass");
		baseTbl = properties.getProperty("TBLBase");
		refTbl = properties.getProperty("TBLRef");
		finalTbl = properties.getProperty("TBLFinal");
		redShiftSchemaNamePreStage = properties.getProperty("RSSCHEMAPRESTAGE");
		redShiftSchemaNameStage = properties.getProperty("RSSCHEMASTAGE");
		redShiftSchemaNameFinal = properties.getProperty("RSSCHEMA");
		

		AWSCredentials credentials = null;
		
		try {
			credentials = new ProfileCredentialsProvider(awsProfile)
					.getCredentials();
		} catch (Exception e) {
			
			throw new AmazonClientException(
					"Cannot load the credentials from the credential profiles file. "
							+ "Please make sure that your credentials file is at the correct "
							+ "location, and is in valid format.", e);

		}
		
		try {
			Class.forName("com.amazon.redshift.jdbc4.Driver");
			Properties props = new Properties();

			props.setProperty("user", msUid);
			props.setProperty("password", msPwd);
			msCon = DriverManager.getConnection(conStrMS, props);
		} catch (ClassNotFoundException e) {
			
			e.printStackTrace();
		} catch (SQLException e) {
			
			e.printStackTrace();
		}

	}

	public void processResult() throws SQLException {
		ResultSet rs = getEmployeeList(0);
		String sql = "";
		PreparedStatement ps = null;
		int lvl = 0;
		System.out.println("Inserting top level employees to the organization database..");
		Savepoint savepoint1 = msCon.setSavepoint("Before_Insertion_TOP");
		while (rs.next()) {

			try {
				
				sql = "INSERT INTO "
						+ baseTbl
						+ "(EMPLOYEE_ID,NAME,SUPERVISOR_ID,LEVEL) VALUES(?,?,?,?)";
				ps = msCon.prepareStatement(sql);
				ps.setInt(1, rs.getInt("EMPLOYEE_ID"));
				ps.setString(
						2,
						rs.getString("FIRSTNAME") + " "
								+ rs.getString("LASTNAME"));
				ps.setInt(3, rs.getInt("SUPERVISOR_ID"));
				ps.setInt(4, 0);
				ps.executeUpdate();
				

			} catch (SQLException e) {
				System.out.println("Error!!\n" + e.getMessage());
				msCon.rollback(savepoint1);
			}

		}
		addEmployeeBasedOnLavel(lvl + 1, lvl);
		addEmployeeBasedOnQLavel();
		
		System.out.println("All employees are added to the database. Program will now exit.");
		
		msCon.close();

	}

	public void addEmployeeBasedOnLavel(int nxtLvl, int prvLvl) throws SQLException {

		String sql = "";
		PreparedStatement ps = null;
		int res = 0, lvl = prvLvl;
		Savepoint savepoint2 = null;
		
		
		System.out.println("Inserting employees of level " + nxtLvl + " to the organization database..");
		sql = "INSERT INTO "
				+ baseTbl
				+ " (EMPLOYEE_ID,NAME,SUPERVISOR_ID,LEVEL) "
				+ "SELECT b.EMPLOYEE_ID,CONCAT(b.FIRSTNAME,b.LASTNAME),b.SUPERVISOR_ID,? FROM "
				+ baseTbl + " a," + refTbl
				+ " b WHERE a.LEVEL = ? and a.EMPLOYEE_ID = b.SUPERVISOR_ID";

		try {

			savepoint2 = msCon.setSavepoint("Before_Insertion_SUB");
			ps = msCon.prepareStatement(sql);
			ps.setInt(1, nxtLvl);
			ps.setInt(2, prvLvl);
			res = ps.executeUpdate();

			System.out.println("No of employess added to the level:- " + nxtLvl + " are " + res);

			if (res > 0) {
				lvl++;
				nxtLvl = lvl + 1;
				prvLvl = lvl;
				addEmployeeBasedOnLavel(nxtLvl, prvLvl);
				

			} else {
				hierarchyDepth = prvLvl;
				return;
			}

		} catch (SQLException e) {

			System.out.println("Error!!" + System.getProperty("line.separator")
					+ e.getMessage());
			
			msCon.rollback(savepoint2);
			
			System.exit(0);
		}

	}
	
	public void addEmployeeBasedOnQLavel() throws SQLException {

		String sql = "";
		PreparedStatement ps = null;
		int res = 0;
		Savepoint savepoint3 = null;
					
		try {
			savepoint3 = msCon.setSavepoint("Before_Insertion_FINAL");
			
			//LOOP THROUGH THE DEPTH OF THE EMPLOYEE-BOSS HIERERCHY 
			
			for(int i = 1; i <= hierarchyDepth; i++) {
				
				if(i == 1){
					sql = "INSERT INTO EMPLOYEE_HIER_FINAL (EMPLOYEE_ID,NAME,SUPERVISOR_ID,LEVEL,Q_LEVEL) "
							+ "SELECT EMPLOYEE_ID, NAME, SUPERVISOR_ID, ?, ? "
							+ " FROM EMPLOYEES where LEVEL = ?";
													
					ps = msCon.prepareStatement(sql);
					ps.setInt(1, i);
					ps.setInt(2, i-1);
					ps.setInt(3, i);
					System.out.println(ps);
					res = ps.executeUpdate();
					System.out.println("No. of employess added to the level:- 1 are " + res);
					
				} else {
					
					sql = "INSERT INTO EMPLOYEE_HIER_FINAL (EMPLOYEE_ID,NAME,SUPERVISOR_ID,LEVEL,Q_LEVEL) "
							+ " SELECT EMPLOYEE_ID, NAME, SUPERVISOR_ID, ?, ? "
							+ " FROM EMPLOYEES where LEVEL = ?";
													
					ps = msCon.prepareStatement(sql);
					ps.setInt(1, 1);
					ps.setInt(2, i);
					ps.setInt(3, i);
					System.out.println(ps);
					res = ps.executeUpdate();
					System.out.println("No. of employess added to the level:- 1 are " + res);
					
				}
				for(int j = 1; j < i; j++){
					
					sql = "INSERT INTO EMPLOYEE_HIER_FINAL (EMPLOYEE_ID,NAME,SUPERVISOR_ID,LEVEL,Q_LEVEL) "
							+ " SELECT b.EMPLOYEE_ID, b.NAME,a.SUPERVISOR_ID, ? , ? FROM "
							+ "(SELECT * FROM EMPLOYEES WHERE LEVEL = ?) a, "
							+ "(SELECT * FROM EMPLOYEE_HIER_FINAL WHERE Q_LEVEL = ? and LEVEL = ?) b "
							+ "WHERE a.EMPLOYEE_ID = b.SUPERVISOR_ID";
					
					ps = msCon.prepareStatement(sql);
					ps.setInt(1, j+1);
					ps.setInt(2, i);
					ps.setInt(3, i-j);
					ps.setInt(4, i);
					ps.setInt(5, j);
					System.out.println(ps);
					res = ps.executeUpdate();
					System.out.println("No. of employess added to this level are " + res);
					

				}
			}
			sql = "INSERT INTO EMPLOYEE_HIER_FINAL (EMPLOYEE_ID,NAME,SUPERVISOR_ID,LEVEL,Q_LEVEL) "
					+ "SELECT DISTINCT EMPLOYEE_ID , NAME, SUPERVISOR_ID, 0,0 FROM EMPLOYEES";
			ps = msCon.prepareStatement(sql);
			res = ps.executeUpdate();
			System.out.println("No. of employess added to this level are " + res);


		} catch (SQLException e) {

			System.out.println("Error!!" + System.getProperty("line.separator")
					+ e.getMessage());
			
			msCon.rollback(savepoint3);
			
			System.exit(0);
		}

	}

	public ResultSet getEmployeeList(int mgrID) {

		String sql;
		Statement statement;
		ResultSet resultSet = null;

		if (mgrID == 0)
			sql = "SELECT * FROM " + refTbl
					+ " WHERE (SUPERVISOR_ID is null) or (SUPERVISOR_ID = 0)";
		else
			sql = "";

		try {

			statement = msCon.createStatement(
					ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			resultSet = statement.executeQuery(sql);

		} catch (SQLException e) {

			System.out.println("Error raised during executing query " + sql
					+ "\n" + e.getMessage());
		}

		return resultSet;

	}

	public int recordCount(ResultSet result) {
		int totalCount = 0;

		try {
			result.last();
			totalCount = result.getRow();
			result.beforeFirst();
			return totalCount;

		} catch (SQLException e) {

			System.out.println("Blank or null resultset passed!!\n"
					+ e.getMessage());
		}

		return totalCount;
	}
	
	public void createAppTmpTbl() {
		
		Statement stmt = null;
		String sql;
		try {
			stmt = msCon.createStatement();
			sql = "DROP TABLE " + redShiftSchemaNamePreStage + "." + baseTbl;
			stmt.execute(sql);
			sql = "CREATE TABLE " + redShiftSchemaNamePreStage + "." + baseTbl + "(";
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		
	}

	public static void main(String args[]) {

		RelationerDataLoaderForSubsidiery j1 = new RelationerDataLoaderForSubsidiery();
		try {
			j1.processResult();
			//j1.addEmployeeBasedOnQLavel();
			
		} catch (SQLException e) {

			e.printStackTrace();
		}
	}

}
