import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Writer;
import java.lang.RuntimeException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Date;
import java.util.Scanner;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

import org.aspectj.weaver.Iterators.Getter;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.transfer.TransferManager;
import com.amazonaws.services.s3.transfer.Upload;

public class DataLoader {
	private String appConfigPropFile;
	private String serverHost;
	private String serverDataSource;
	private String login;
	private String password;
	private String accountId;
	private int roleId;
	private int port;
	private String[] dimensions;
	private String[] facts;
	private Connection con;
	private String connectionString;
	private Statement statement;
	private ResultSet resultSet;
	private String query;
	private String extractLocationLocal;
	private String extractLocationS3;
	private String statusRptLocation;
	private String factsSqlScriptLocation;
	private String factsPropFile;
	private TransferManager tx;
	private Upload upload;
	private String logLocation;
	private String awsProfile;
	private ArrayList<String> extractStartTime = new ArrayList<String>();
	private ArrayList<String> extractEndTime = new ArrayList<String>();
	private ArrayList<String> loadStartTime = new ArrayList<String>();
	private ArrayList<String> loadEndTime = new ArrayList<String>();
	private ArrayList<String> loadStartTimeRS = new ArrayList<String>();
	private ArrayList<String> loadEndTimeRS = new ArrayList<String>();
	private String redShiftMasterUsername;
	private String redShiftMasterUserPassword;
	private String redShiftPreStageSchemaName;
	private String dbURL;
	private Map<String, String> checkList = new HashMap<String, String>();
	private String[] failedFileList;
	private char csvDelimiter;
	private int RunID;
	private String eol;
	private String aSQLScriptFilePath;
	private File tmpLog;

	
	public DataLoader() throws IOException, ClassNotFoundException,
			SQLException {
		appConfigPropFile = "config.properties";
		Properties properties = new Properties();
		File pf = new File(appConfigPropFile);
		properties.load(new FileReader(pf));

		factsPropFile = "facts.properties";
		eol = System.getProperty("line.separator");

		
		serverHost = properties.getProperty("ServerHost");
		serverDataSource = properties.getProperty("DataSource");
		login = properties.getProperty("Login");
		password = properties.getProperty("Password");
		accountId = properties.getProperty("AccountId");
		roleId = convertToNumber(properties.getProperty("RoleId"), "RoleID");
		port = convertToNumber(properties.getProperty("Port"), "Port");

		if (!properties.getProperty("Dimensions").equalsIgnoreCase("NONE")) {
			dimensions = properties.getProperty("Dimensions").split(",");
		} else {
			dimensions = null;
		}

		if (!properties.getProperty("Facts").equalsIgnoreCase("NONE")) {
			facts = properties.getProperty("Facts").split(",");
		} else {
			facts = null;
		}

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		Date curDate = new Date();
		String strDate = sdf.format(curDate);

		extractLocationLocal = System.getProperty("user.dir") + File.separator
				+ "DB_Extracts" + File.separator + strDate;
		extractLocationS3 = properties.getProperty("s3bucket");
		logLocation = System.getProperty("user.dir") + File.separator + "log"
				+ File.separator + strDate;
		statusRptLocation = System.getProperty("user.dir") + File.separator
				+ "Status_Reports" + File.separator + strDate;
		factsSqlScriptLocation = System.getProperty("user.dir")
				+ File.separator + properties.getProperty("FactFileLoc");

		aSQLScriptFilePath = properties.getProperty("SQLScriptsPath");
		awsProfile = properties.getProperty("AwsProfile");
		redShiftMasterUsername = properties.getProperty("RSUID");
		redShiftMasterUserPassword = properties.getProperty("RSPWD");
		redShiftPreStageSchemaName = properties.getProperty("RSSCHEMAPRESTAGE");
		dbURL = properties.getProperty("RSDBURL");
		csvDelimiter = properties.getProperty("CSVDelim").charAt(0);
		RunID = Integer.parseInt(properties.getProperty("RunID"));
		RunID++;
		updateFactsProperty(appConfigPropFile, "RunID ", String.valueOf(RunID));

		try {
			new File(extractLocationLocal).mkdirs();
			new File(logLocation).mkdirs();
			new File(statusRptLocation).mkdirs();
			// Creating JDBC DB Connection
			Class.forName("com.netsuite.jdbc.openaccess.OpenAccessDriver");
			connectionString = String
					.format("jdbc:ns://%s:%d;ServerDataSource=%s;encrypted=1;CustomProperties=(AccountID=%s;RoleID=%d)",
							serverHost, port, serverDataSource, accountId,
							roleId);

			con = DriverManager
					.getConnection(connectionString, login, password);

			writeLog(
					"Application Started Successfully.RunID  of this session is "
							+ RunID, "info");

			System.out
					.println("************************************ WELCOME TO P2P DB DATA LOADER UTILITIES ************************************");

		} catch (SecurityException e) {
			System.out
					.println("Application Can't create Log Directory. See Error Message for mor details."
							+ eol + e.getMessage());

			tmpLog = new File("tmp.log");
			FileWriter fWriter = new FileWriter(tmpLog);
			PrintWriter pWriter = new PrintWriter(fWriter);
			pWriter.println("Application Can't create Log Directory. See Error Message for mor details."
					+ eol + e.getMessage());

			System.exit(0);

		} catch (ClassNotFoundException e) {
			System.out.println("Error !! Please check error message "
					+ e.getMessage());
			writeLog("RunID " + RunID + eol
					+ "Error !! Please check error message. " + e.getMessage(),
					"error");
			System.exit(0);
		}

	}

	public DataLoader(String mode,int runid) throws IOException, ClassNotFoundException,
			SQLException {
		appConfigPropFile = "config.properties";
		Properties properties = new Properties();
		File pf = new File(appConfigPropFile);
		properties.load(new FileReader(pf));

		factsPropFile = "facts.properties";
		eol = System.getProperty("line.separator");

		// Initialize the class variables with properties values
		serverHost = properties.getProperty("ServerHost");
		serverDataSource = properties.getProperty("DataSource");
		login = properties.getProperty("Login");
		password = properties.getProperty("Password");
		accountId = properties.getProperty("AccountId");
		roleId = convertToNumber(properties.getProperty("RoleId"), "RoleID");
		port = convertToNumber(properties.getProperty("Port"), "Port");

		if (!properties.getProperty("Dimensions").equalsIgnoreCase("NONE")) {
			dimensions = properties.getProperty("Dimensions").split(",");
		} else {
			dimensions = null;
		}

		if (!properties.getProperty("Facts").equalsIgnoreCase("NONE")) {
			facts = properties.getProperty("Facts").split(",");
		} else {
			facts = null;
		}

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		Date curDate = new Date();
		String strDate = sdf.format(curDate);

		extractLocationLocal = System.getProperty("user.dir") + File.separator
				+ "DB_Extracts" + File.separator + strDate;
		extractLocationS3 = properties.getProperty("s3bucket");
		logLocation = System.getProperty("user.dir") + File.separator + "log"
				+ File.separator + strDate;
		statusRptLocation = System.getProperty("user.dir") + File.separator
				+ "Status_Reports" + File.separator + strDate;
		factsSqlScriptLocation = System.getProperty("user.dir")
				+ File.separator + properties.getProperty("FactFileLoc");

		aSQLScriptFilePath = properties.getProperty("SQLScriptsPath");
		awsProfile = properties.getProperty("AwsProfile");
		redShiftMasterUsername = properties.getProperty("RSUID");
		redShiftMasterUserPassword = properties.getProperty("RSPWD");
		redShiftPreStageSchemaName = properties.getProperty("RSSCHEMAPRESTAGE");
		dbURL = properties.getProperty("RSDBURL");
		csvDelimiter = properties.getProperty("CSVDelim").charAt(0);
		RunID = runid;
		

		try {
			new File(extractLocationLocal).mkdirs();
			new File(logLocation).mkdirs();
			new File(statusRptLocation).mkdirs();
			// Creating JDBC DB Connection
			Class.forName("com.netsuite.jdbc.openaccess.OpenAccessDriver");
			connectionString = String
					.format("jdbc:ns://%s:%d;ServerDataSource=%s;encrypted=1;CustomProperties=(AccountID=%s;RoleID=%d)",
							serverHost, port, serverDataSource, accountId,
							roleId);

			con = DriverManager
					.getConnection(connectionString, login, password);

			writeLog(
					"Application Started Successfully.RunID  of this session is "
							+ RunID, "info");

			System.out
					.println("************************************ WELCOME TO P2P DB DATA LOADER UTILITIES ************************************");

		} catch (SecurityException e) {
			System.out
					.println("Application Can't create Log Directory. See Error Message for mor details."
							+ eol + e.getMessage());

			tmpLog = new File("tmp.log");
			FileWriter fWriter = new FileWriter(tmpLog);
			PrintWriter pWriter = new PrintWriter(fWriter);
			pWriter.println("Application Can't create Log Directory. See Error Message for mor details."
					+ eol + e.getMessage());

			System.exit(0);

		} catch (ClassNotFoundException e) {
			System.out.println("Error !! Please check error message "
					+ e.getMessage());
			writeLog("RunID " + RunID + eol
					+ "Error !! Please check error message. " + e.getMessage(),
					"error");
			System.exit(0);
		}

	}

	public int getRunID() {
		return this.RunID;
	}
	
	public void setRunID () {
		
		RunID++;
		
	}
	public void createDbExtract() throws IOException {

		String TBL_DEF_CONF = "tbl_def.properties";
		String clmNames;
		String factFileName;
		int count;

		if (dimensions != null) {
			for (int i = 0; i < dimensions.length; i++) {

				System.out
						.println("DataExtraction Operation Started for DB table "
								+ dimensions[i]);
				System.out
						.println("--------------------------------------------------------");

				writeLog("RunID " + RunID + eol
						+ "DataExtraction Operation Started for DB table "
						+ dimensions[i], "info");

				// LOAD USER SPECIFIC COLUMNS FROM THE TABLE DEFINED IN
				// PROPERTIES FILE

				Properties properties = new Properties();
				File pf = new File(TBL_DEF_CONF);
				properties.load(new FileReader(pf));

				query = properties.getProperty(dimensions[i]);

				try {

					extractStartTime.add(i, new SimpleDateFormat("HH:mm:ss")
							.format(Calendar.getInstance().getTime()));
					statement = con.createStatement();
					System.out.println("Executing query for " + dimensions[i]
							+ " table.");

					resultSet = statement.executeQuery(query);

					System.out.println("Retrieving data...");

					writeLog("RunID " + RunID + eol + "Retrieving data for "
							+ dimensions[i], "info");

					SimpleDateFormat sdf = new SimpleDateFormat(
							"ddMMyyyyhhmmss");
					Date curDate = new Date();
					String strDate = sdf.format(curDate);

					String fileName = extractLocationLocal + File.separator
							+ dimensions[i] + "-" + "RunID-" + RunID + "-"
							+ strDate + ".csv";
					File file = new File(fileName);
					FileWriter fstream = new FileWriter(file);
					BufferedWriter out = new BufferedWriter(fstream);
					String str = "";
					List<String> columnNames = getColumnNames(resultSet);
					for (int c = 0; c < columnNames.size(); c++) {
						str = "\"" + columnNames.get(c) + "\"";
						out.append(str);
						if (c != columnNames.size() - 1) {
							out.append(csvDelimiter);
						}
					}

					// process results

					while (resultSet.next()) {

						List<Object> row = new ArrayList<Object>();

						row.add(RunID);

						for (int k = 0; k < columnNames.size() - 1; k++) {
							row.add(resultSet.getObject(k + 1));

						}

						out.newLine();

						for (int j = 0; j < row.size(); j++) {
							if (!String.valueOf(row.get(j)).equals("null")) {
								String tmp = "\"" + String.valueOf(row.get(j))
										+ "\"";
								out.append(tmp);
								if (j != row.size() - 1) {
									out.append(csvDelimiter);
								}
							} else {
								if (j != row.size() - 1) {
									out.append(csvDelimiter);
								}
							}
						}
					}
					out.close();

					File csvFile = new File(fileName);
					double bytes = csvFile.length();

					writeLog("RunID  No." + RunID + eol
							+ "DataExtration Oparation for table "
							+ dimensions[i] + " is extracted in " + fileName,
							"info");
					System.out.println("DataExtration Oparation for table "
							+ dimensions[i] + " is extracted in " + fileName);

					checkList.put(dimensions[i], "Extraction Done");

					extractEndTime.add(i, new SimpleDateFormat("HH:mm:ss")
							.format(Calendar.getInstance().getTime()));

				} catch (SQLException e) {
					System.out
							.println("SQL Error!! Please Cheack the query and try again.\n"
									+ e.getMessage());

					checkList.put(dimensions[i], "Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "SQL Error!!"
									+ e.getMessage(), "error");

					extractEndTime.add(i, "Error");

				} catch (IOException e) {
					System.out
							.println("IO Error!! Please check the error message.\n"
									+ e.getMessage());

					checkList.put(dimensions[i], "Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "Error!!" + e.getMessage(),
							"error");
					extractEndTime.add(i, "Error");

				} catch (Exception e) {
					System.out.println("RunID " + RunID + eol
							+ "Error!! Please check the error message.\n"
							+ e.getMessage());

					checkList.put(dimensions[i], "Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "Error!!" + e.getMessage(),
							"error");
					extractEndTime.add(i, "Error");

				} finally {
					continue;
				}

			}
		} else {

			System.out
					.println("No dimentions are mentioned in the config file.");
		}

		/***************************** Fact Extraction Started **************************************/

		if (facts != null) {
			int idex = dimensions.length - 1;
			System.out.println("DataExtration Oparation is Started for Facts.");

			writeLog("RunID " + RunID + eol
					+ "DataExtration Oparation is Started for Facts.", "info");

			for (int x = 0; x < facts.length; x++) {

				idex = idex + x + 1;
				extractStartTime.add(idex, new SimpleDateFormat("HH:mm:ss")
						.format(Calendar.getInstance().getTime()));
				try {

					factFileName = factsSqlScriptLocation + File.separator
							+ facts[x] + ".sql";

					createFactExtract(con, factFileName, facts[x], idex);

				} catch (Exception e) {

					extractEndTime.add(idex, "Error");

					checkList.put(facts[x], "Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "Error!!" + e.getMessage(),
							"error");

				} finally {
					continue;
				}
			}
		} else {
			System.out.println("No facts are mentioned in the config file.");
		}

	}

	public void createDbExtract(char mode, String[] failedFileList)
			throws IOException {

		String TBL_DEF_CONF = "tbl_def.properties";
		String clmNames;
		String factFileName;

		for (int i = 0; i < failedFileList.length; i++) {

			if (!Arrays.asList(facts).contains(failedFileList[i])) {

				System.out
						.println("DataExtraction Operation Started for DB table "
								+ failedFileList[i]);
				System.out
						.println("--------------------------------------------------------");

				writeLog("DataExtraction Operation Started for DB table "
						+ failedFileList[i], "info");

				// LOAD USER SPECIFIC COLUMNS FROM THE TABLE DEFINED IN
				// PROPERTIES FILE

				Properties properties = new Properties();
				File pf = new File(TBL_DEF_CONF);
				properties.load(new FileReader(pf));

				clmNames = properties.getProperty(failedFileList[i]);

				if (clmNames.equalsIgnoreCase("ALL"))
					query = "SELECT * FROM " + failedFileList[i] + ";";
				else
					query = "SELECT " + clmNames + " FROM " + failedFileList[i]
							+ ";";

				try {

					// extractStartTime.add(i, new SimpleDateFormat("HH:mm:ss")
					// .format(Calendar.getInstance().getTime()));

					statement = con.createStatement();
					System.out.println("Executing query for "
							+ failedFileList[i] + " table.");

					resultSet = statement.executeQuery(query);

					System.out.println("Retrieving data...");

					writeLog("Retrieving data for " + failedFileList[i], "info");

					SimpleDateFormat sdf = new SimpleDateFormat(
							"ddMMyyyyhhmmss");
					Date curDate = new Date();
					String strDate = sdf.format(curDate);

					String fileName = extractLocationLocal + File.separator
							+ failedFileList[i] + "-" + "RunID-" + RunID + "-"
							+ strDate + ".csv";
					File file = new File(fileName);
					FileWriter fstream = new FileWriter(file);
					BufferedWriter out = new BufferedWriter(fstream);
					String str = "";
					List<String> columnNames = getColumnNames(resultSet);

					for (int c = 0; c < columnNames.size(); c++) {
						str = "\"" + columnNames.get(c) + "\"";
						out.append(str);
						if (c != columnNames.size() - 1) {
							out.append(",");
						}
					}

					// process results
					while (resultSet.next()) {
						List<Object> row = new ArrayList<Object>();
						// do something meaning full with the result
						for (int k = 0; k < columnNames.size(); k++) {
							row.add(resultSet.getObject(k + 1));
						}

						out.newLine();

						for (int j = 0; j < row.size(); j++) {
							if (!String.valueOf(row.get(j)).equals("null")) {
								String tmp = "\"" + String.valueOf(row.get(j))
										+ "\"";
								out.append(tmp);
								if (j != row.size() - 1) {
									out.append(",");
								}
							} else {
								if (j != row.size() - 1) {
									out.append(",");
								}
							}
						}
					}
					out.close();

					writeLog("RunID " + RunID + eol
							+ "DataExtration Oparation for table "
							+ failedFileList[i] + " is extracted in "
							+ fileName, "info");
					System.out.println("DataExtration Oparation for table "
							+ failedFileList[i] + " is extracted in "
							+ fileName);

					// checkList.put(dimensions[i],"Extraction Done");

					// extractEndTime.add(i, new
					// SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime()));

				} catch (SQLException e) {
					System.out
							.println("SQL Error!! Please Cheack the query and try again.\n"
									+ e.getMessage());

					// checkList.put(dimensions[i],"Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "SQL Error!!"
									+ e.getMessage(), "error");

					// extractEndTime.add(i, "Error");

				} catch (IOException e) {
					System.out
							.println("IO Error!! Please check the error message.\n"
									+ e.getMessage());

					// checkList.put(dimensions[i],"Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "Error!!" + e.getMessage(),
							"error");
					// extractEndTime.add(i, "Error");

				} catch (Exception e) {
					System.out
							.println("Error!! Please check the error message.\n"
									+ e.getMessage());

					// checkList.put(dimensions[i],"Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "Error!!" + e.getMessage(),
							"error");
					// extractEndTime.add(i, "Error");

				} finally {
					continue;
				}

			} else {

				try {

					factFileName = factsSqlScriptLocation + File.separator
							+ failedFileList[i] + ".sql";

					createFactExtract(con, factFileName, failedFileList[i], -1);

				} catch (Exception e) {

					// extractEndTime.add(idex, "Error");

					// checkList.put(facts[x],"Extraction Error");

					writeLog(
							"RunID " + RunID + eol + "Error!!" + e.getMessage(),
							"error");

				} finally {
					continue;
				}
			}

		}

	}

	private void createFactExtract(Connection conn, String factFile,
			String factName, int pos) throws SQLException, IOException {

		Statement st = null;
		ResultSet rs = null;
		String lastModDate;
		String[] tmpdt = null;
		String currDate = null;

		Properties factsProp = new Properties();
		Properties tmpProp = new Properties();
		File pf = new File(factsPropFile);
		File tmpFile = new File("tmpFile.properties");

		try {
			factsProp.load(new FileReader(pf));
			tmpProp.load(new FileReader(tmpFile));

		} catch (IOException e) {

			throw new IOException(e.toString());
		}

		try {
			BufferedReader in = new BufferedReader(new FileReader(factFile));

			Scanner scn = new Scanner(in);
			scn.useDelimiter("/\\*[\\s\\S]*?\\*/|--[^\\r\\n]*|;");

			st = conn.createStatement();

			while (scn.hasNext()) {
				String line = scn.next().trim();

				if (!line.isEmpty()) {
					tmpdt = factsProp.getProperty(factName).split(",");
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy-MM-dd HH:mm:ss");
					Date date = formatter.parse(tmpdt[1]);
					Calendar cal = Calendar.getInstance();
					cal.setTime(date);
					cal.add(Calendar.SECOND, 1);
					lastModDate = cal.getTime().toString();
					line = String.format(line, lastModDate);
					writeLog("RunID " + RunID + eol + "Executing query for "
							+ factName + "where DATE_LAST_MODIFIED >= "
							+ lastModDate, "info");

					rs = st.executeQuery(line);

					currDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
							.format(Calendar.getInstance().getTime());
					lastModDate = tmpdt[1] + "," + currDate;
					updateFactsProperty("tmpFile.properties", factName,
							lastModDate);

					if (rs.next()) {

						rs.beforeFirst();
						System.out.println("Retrieving data...");

						writeLog("Retrieving data for " + factName, "info");

						SimpleDateFormat sdf = new SimpleDateFormat(
								"ddMMyyyyhhmmss");
						Date curDate = new Date();
						String strDate = sdf.format(curDate);

						String fileName = extractLocationLocal + File.separator
								+ factName + "-" + "RunID-" + RunID + "-"
								+ strDate + ".csv";
						File file = new File(fileName);
						FileWriter fstream = new FileWriter(file);
						BufferedWriter out = new BufferedWriter(fstream);

						String str = "";
						List<String> columnNames = getColumnNames(rs);
						for (int c = 0; c < columnNames.size(); c++) {
							str = "\"" + columnNames.get(c) + "\"";
							out.append(str);
							if (c != columnNames.size() - 1) {
								out.append(csvDelimiter);
							}
						}

						while (rs.next()) {
							List<Object> row = new ArrayList<Object>();

							for (int k = 0; k < columnNames.size(); k++) {
								row.add(rs.getObject(k + 1));
							}

							out.newLine();

							for (int j = 0; j < row.size(); j++) {
								if (!String.valueOf(row.get(j)).equals("null")) {
									String tmp = "\""
											+ String.valueOf(row.get(j)) + "\"";
									out.append(tmp);
									if (j != row.size() - 1) {
										out.append(csvDelimiter);
									}
								} else {
									if (j != row.size() - 1) {
										out.append(csvDelimiter);
									}
								}
							}
						}
						out.close();
						fstream.close();

						if (pos >= 0) {
							checkList.put(factName, "Extraction Done");
							extractEndTime.add(pos, new SimpleDateFormat(
									"HH:mm:ss").format(Calendar.getInstance()
									.getTime()));
						}

						System.out.println("Extraction Completed for fact "
								+ factName);
						writeLog("RunID " + RunID + eol
								+ "Extraction Completed for fact " + factName,
								"info");
					} else {
						System.out
								.println("No resultset generated after executing query for "
										+ factName
										+ "where DATE_LAST_MODIFIED >= "
										+ lastModDate);
						writeLog(
								"RunID "
										+ RunID
										+ eol
										+ "No resultset generated after executing query for "
										+ factName
										+ "where DATE_LAST_MODIFIED >= "
										+ lastModDate, "info");
						if (pos >= 0) {
							checkList.put(factName, "Extraction Error");
							extractEndTime.add(pos, "Error");
						}
						scn.close();

						if (st != null)
							st.close();
						return;

					}

				}

			}
			scn.close();
			if (st != null)
				st.close();

		} catch (FileNotFoundException e) {

			writeLog("RunID " + RunID + eol + "Error!!" + e.getMessage(),
					"error");
			throw new FileNotFoundException(e.toString());

		} catch (SQLException e) {

			writeLog("RunID " + RunID + eol + "Error!!" + e.getMessage(),
					"error");
			throw new SQLException(e.toString());

		} catch (IOException e) {

			writeLog("RunID " + RunID + eol + "Error!!" + e.getMessage(),
					"error");
			throw new IOException(e.toString());

		} catch (ParseException e) {
			writeLog("RunID " + RunID + eol + "Error!!" + e.getMessage(),
					"error");
			throw new SQLException(e.toString());
		}

	}

	public void doAmazonS3FileTransfer() {

		String[] files = combine(dimensions, facts);
		AWSCredentials credentials = null;
		try {
			// credentials = new
			// ProfileCredentialsProvider("kaushik_das").getCredentials();
			credentials = new ProfileCredentialsProvider(awsProfile)
					.getCredentials();
		} catch (Exception e) {
			writeLog(
					"Cannot load the credentials from the credential profiles file. "
							+ "Please make sure that your credentials file is at the correct "
							+ "location, and is in valid format.", "error");
			throw new AmazonClientException(
					"Cannot load the credentials from the credential profiles file. "
							+ "Please make sure that your credentials file is at the correct "
							+ "location, and is in valid format.", e);

		}

		AmazonS3 s3 = new AmazonS3Client(credentials);
		Region usWest2 = Region.getRegion(Regions.US_WEST_2);
		s3.setRegion(usWest2);
		tx = new TransferManager(s3);

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		Date curDate = new Date();
		String strDate = sdf.format(curDate);

		String bucketName = extractLocationS3;
		String key = credentials.getAWSAccessKeyId();

		System.out.println("\n\nUploading DB Extracts to Amazon S3");
		System.out
				.println("--------------------------------------------------------");

		for (int i = 0; i < files.length; i++) {

			if (!checkErrorStatus("Extraction", files[i])) {

				loadStartTime.add(i, new SimpleDateFormat("HH:mm:ss")
						.format(Calendar.getInstance().getTime()));

				try {

					File s3File = getLastFileModifiedFile(extractLocationLocal,
							files[i]);
					writeLog(
							"RunID " + RunID + eol + "Uploading "
									+ s3File.getName()
									+ " to Amazon S3 bucket " + bucketName,
							"info");
					System.out.println("Uploading " + s3File.getName()
							+ " to S3.\n");

					PutObjectRequest request = new PutObjectRequest(bucketName,
							strDate + "/" + s3File.getName(), s3File);
					upload = tx.upload(request);

					writeLog("RunID " + RunID + eol + s3File.getName()
							+ " transffered successfully.", "info");
					System.out.println(files[i] + " file transffered.");

					loadEndTime.add(i, new SimpleDateFormat("HH:mm:ss")
							.format(Calendar.getInstance().getTime()));
					boolean ex = new File(statusRptLocation + File.separator
							+ "Status_Report.txt").exists();
					boolean header = false;
					if (!ex) {
						if (i == 0) {
							header = true;
						}
					} else {
						header = false;
					}

					loadDataToRedShiftDB(files[i], s3File.getName());

					writeStatusReport(RunID, files[i], extractStartTime.get(i),
							extractEndTime.get(i), loadStartTime.get(i),
							loadEndTime.get(i), loadStartTimeRS.get(i),
							loadEndTimeRS.get(i), header);

				} catch (AmazonServiceException ase) {

					writeLog(
							"Caught an AmazonServiceException, which means your request made it "
									+ "to Amazon S3, but was rejected with an error response for some reason."
									+ eol + "Error Message:" + ase.getMessage()
									+ eol + "HTTP Status Code: "
									+ ase.getStatusCode() + eol
									+ "AWS Error Code: " + ase.getErrorCode()
									+ eol + "Error Type: " + ase.getErrorType()
									+ eol + "Request Id: " + ase.getRequestId(),
							"error");
					System.out
							.println("Caught an AmazonServiceException, which means your request made it "
									+ "to Amazon S3, but was rejected with an error response for some reason.");
					System.out.println("Error Message:    " + ase.getMessage());
					System.out.println("HTTP Status Code: "
							+ ase.getStatusCode());
					System.out.println("AWS Error Code:   "
							+ ase.getErrorCode());
					System.out.println("Error Type:       "
							+ ase.getErrorType());
					System.out.println("Request ID:       "
							+ ase.getRequestId());

					loadEndTime.add(i, "Error");

					boolean ex = new File(statusRptLocation + File.separator
							+ "Status_Report.txt").exists();

					boolean header = false;

					if (!ex) {
						if (i == 0) {
							header = true;
						}
					} else {
						header = false;
					}

					checkList.put(files[i], "Loading Error");

					writeStatusReport(RunID, files[i], extractStartTime.get(i),
							extractEndTime.get(i), loadStartTime.get(i),
							loadEndTime.get(i), loadStartTimeRS.get(i),
							loadEndTimeRS.get(i), header);

				} catch (AmazonClientException ace) {
					writeLog(
							"Caught an AmazonClientException, which means the client encountered "
									+ "a serious internal problem while trying to communicate with S3, "
									+ "such as not being able to access the network."
									+ ace.getMessage(), "error");

					loadEndTime.add(i, "Error");
					boolean ex = new File(statusRptLocation + File.separator
							+ "Status_Report.txt").exists();
					boolean header = false;

					if (!ex) {
						if (i == 0) {
							header = true;
						}
					} else {
						header = false;
					}

					checkList.put(files[i], "Loading Error");

					writeStatusReport(RunID, files[i], extractStartTime.get(i),
							extractEndTime.get(i), loadStartTime.get(i),
							loadEndTime.get(i), loadStartTimeRS.get(i),
							loadEndTimeRS.get(i), header);

				} catch (Exception e) {
					writeLog("RunID " + RunID + eol + e.getMessage(), "error");
					System.out.println("Error !! Please check error message "
							+ e.getMessage());

					loadEndTime.add(i, "Error");

					checkList.put(files[i], "Loading Error");

					boolean ex = new File(statusRptLocation + File.separator
							+ "Status_Report.txt").exists();
					boolean header = false;

					if (!ex) {
						if (i == 0) {
							header = true;
						}
					} else {
						header = false;
					}

					writeStatusReport(RunID, files[i], extractStartTime.get(i),
							extractEndTime.get(i), loadStartTime.get(i),
							loadEndTime.get(i), loadStartTimeRS.get(i),
							loadEndTimeRS.get(i), header);
				} finally {
					continue;
				}

			} else {
				checkList.put(files[i], "Loading Error");
				writeLog("There is an issue while creating the extract of "
						+ files[i] + ". So loading operation is skipped for "
						+ files[i], "info");
				System.out
						.println("There is an issue while creating the extract of "
								+ files[i]
								+ ". So loading operation is skipped for "
								+ files[i]);
			}
		}

		// reviewDataLoadingSession();

	}

	public void doAmazonS3FileTransfer(char mode, String[] files) {

		AWSCredentials credentials = null;
		try {
			credentials = new ProfileCredentialsProvider(awsProfile)
					.getCredentials();
		} catch (Exception e) {
			writeLog(
					"Cannot load the credentials from the credential profiles file. "
							+ "Please make sure that your credentials file is at the correct "
							+ "location, and is in valid format.", "error");
			throw new AmazonClientException(
					"Cannot load the credentials from the credential profiles file. "
							+ "Please make sure that your credentials file is at the correct "
							+ "location, and is in valid format.", e);

		}

		AmazonS3 s3 = new AmazonS3Client(credentials);
		Region usWest2 = Region.getRegion(Regions.US_WEST_2);
		s3.setRegion(usWest2);
		tx = new TransferManager(s3);

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		Date curDate = new Date();
		String strDate = sdf.format(curDate);

		String bucketName = extractLocationS3;
		String key = credentials.getAWSAccessKeyId();

		System.out.println("\nUploading DB Extracts to Amazon S3");
		System.out
				.println("--------------------------------------------------------");

		for (int i = 0; i < files.length; i++) {

			if (!checkErrorStatus("Extraction", files[i])) {

				// loadStartTime.add(i, new
				// SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime()));

				try {

					File s3File = getLastFileModifiedFile(extractLocationLocal,
							files[i]);
					writeLog("Uploading " + s3File.getName()
							+ " to Amazon S3 bucket " + bucketName, "info");
					System.out.println("Uploading " + s3File.getName()
							+ " to S3.\n");

					PutObjectRequest request = new PutObjectRequest(bucketName,
							strDate + "/" + s3File.getName(), s3File);
					upload = tx.upload(request);

					writeLog(s3File.getName() + " transffered successfully.",
							"info");
					System.out.println(files[i] + " file transffered.");

					// loadEndTime.add(i, new
					// SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime()));

					/*
					 * boolean ex = new File(statusRptLocation + File.separator
					 * + "Status_Report.txt").exists(); boolean header = false;
					 * if(!ex) { if(i == 0){ header = true; } } else { header =
					 * false; } writeStatusReport(files[i],
					 * extractStartTime.get(i), extractEndTime.get(i),
					 * loadStartTime.get(i), loadEndTime.get(i), header);
					 */

					loadDataToRedShiftDB(files[i], s3File.getName());

				} catch (AmazonServiceException ase) {

					writeLog(
							"Caught an AmazonServiceException, which means your request made it "
									+ "to Amazon S3, but was rejected with an error response for some reason.\nError Message:"
									+ ase.getMessage() + "\n"
									+ "HTTP Status Code: "
									+ ase.getStatusCode() + "\n"
									+ "AWS Error Code: " + ase.getErrorCode()
									+ "\n" + "Error Type: "
									+ ase.getErrorType() + "\n"
									+ "Request Id: " + ase.getRequestId(),
							"error");
					System.out
							.println("Caught an AmazonServiceException, which means your request made it "
									+ "to Amazon S3, but was rejected with an error response for some reason.");
					System.out.println("Error Message:    " + ase.getMessage());
					System.out.println("HTTP Status Code: "
							+ ase.getStatusCode());
					System.out.println("AWS Error Code:   "
							+ ase.getErrorCode());
					System.out.println("Error Type:       "
							+ ase.getErrorType());
					System.out.println("Request ID:       "
							+ ase.getRequestId());

					/*
					 * loadEndTime.add(i, "Error");
					 * 
					 * boolean ex = new File(statusRptLocation + File.separator
					 * + "Status_Report.txt").exists();
					 * 
					 * checkList.put(files[i],"Loading Error");
					 * 
					 * writeStatusReport(files[i], extractStartTime.get(i),
					 * extractEndTime.get(i), loadStartTime.get(i),
					 * loadEndTime.get(i), (i > 0 && ex == true) ? false :
					 * true);
					 */

				} catch (AmazonClientException ace) {
					writeLog(
							"Caught an AmazonClientException, which means the client encountered "
									+ "a serious internal problem while trying to communicate with S3, "
									+ "such as not being able to access the network."
									+ ace.getMessage(), "error");

					System.out.println("Error !! Please check error message "
							+ ace.getMessage());

					/*
					 * loadEndTime.add(i, "Error");
					 * 
					 * checkList.put(files[i],"Loading Error");
					 * 
					 * boolean ex = new File(statusRptLocation + File.separator
					 * + "Status_Report.txt").exists();
					 * 
					 * writeStatusReport(files[i], extractStartTime.get(i),
					 * extractEndTime.get(i), loadStartTime.get(i),
					 * loadEndTime.get(i), (i > 0 && ex == true) ? false :
					 * true);
					 */

				} catch (Exception e) {
					writeLog("RunID " + RunID + eol + e.getMessage(), "error");
					System.out.println("Error !! Please check error message "
							+ e.getMessage());

					/*
					 * loadEndTime.add(i, "Error");
					 * 
					 * checkList.put(files[i],"Loading Error");
					 * 
					 * boolean ex = new File(statusRptLocation + File.separator
					 * + "Status_Report.txt").exists();
					 * 
					 * writeStatusReport(files[i], extractStartTime.get(i),
					 * extractEndTime.get(i), loadStartTime.get(i),
					 * loadEndTime.get(i), (i > 0 && ex == true) ? false :
					 * true);
					 */
				} finally {
					continue;
				}

			} else {
				checkList.put(files[i], "Loading Error");
				writeLog("There is an issue while creating the extract of "
						+ files[i] + ". So loading operation is skipped for "
						+ files[i], "info");
				System.out
						.println("There is an issue while creating the extract of "
								+ files[i]
								+ ". So loading operation is skipped for "
								+ files[i]);
			}
		}

	}

	public void loadDataToRedShiftDB(String tableName, String fileName) {

		Connection conn = null;
		Statement stmt = null;
		AWSCredentials credentials = null;
		String lastModDate = "";

		try {
			credentials = new ProfileCredentialsProvider(awsProfile)
					.getCredentials();
		} catch (Exception e) {
			writeLog(
					"Cannot load the credentials from the credential profiles file. "
							+ "Please make sure that your credentials file is at the correct "
							+ "location, and is in valid format.", "error");
			throw new AmazonClientException(
					"Cannot load the credentials from the credential profiles file. "
							+ "Please make sure that your credentials file is at the correct "
							+ "location, and is in valid format.", e);

		}

		AmazonS3 s3 = new AmazonS3Client(credentials);
		Region usWest2 = Region.getRegion(Regions.US_WEST_2);
		s3.setRegion(usWest2);

		String accKey = credentials.getAWSAccessKeyId();
		String scrtKey = credentials.getAWSSecretKey();

		System.out.println("RedShift Data Loading Started..");
		System.out.println("RedShift Data loading started for " + tableName);
		writeLog("RedShift Data loading started for " + tableName, "info");
		try {

			System.out
					.println("Waiting 1 min. for the availability of the file in Amazon S3");
			Thread.sleep(120000);
			Class.forName("com.amazon.redshift.jdbc4.Driver");

			// Open a connection and define properties.
			System.out.println("Connecting to Redshift Cluster...");

			loadStartTimeRS.add((loadStartTimeRS.size() + 1) - 1,
					new SimpleDateFormat("HH:mm:ss").format(Calendar
							.getInstance().getTime()));

			Properties props = new Properties();

			props.setProperty("user", redShiftMasterUsername);
			props.setProperty("password", redShiftMasterUserPassword);
			conn = DriverManager.getConnection(dbURL, props);

			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			Date curDate = new Date();
			String strDate = sdf.format(curDate);

			stmt = conn.createStatement();
			String sql;
			sql = "truncate table " + redShiftPreStageSchemaName + "."
					+ tableName;
			stmt.executeUpdate(sql);
			sql = "copy "
					+ redShiftPreStageSchemaName
					+ "."
					+ tableName
					+ " from 's3://"
					+ extractLocationS3
					+ "/"
					+ strDate
					+ "/"
					+ fileName
					+ "' credentials 'aws_access_key_id="
					+ accKey
					+ ";aws_secret_access_key="
					+ scrtKey
					+ "' timeformat 'YYYY-MM-DD HH:MI:SS' escape removequotes delimiter as ',' IGNOREHEADER 1 ACCEPTINVCHARS;";
			System.out.println("Executing Query..");
			writeLog("Executing Query..\n" + sql, "info");

			stmt.executeUpdate(sql);

			System.out.println("Done..");

			loadEndTimeRS.add((loadEndTimeRS.size() + 1) - 1,
					new SimpleDateFormat("HH:mm:ss").format(Calendar
							.getInstance().getTime()));

			checkList.put(tableName, "Loading Done");
			writeLog("RedShift Data loading is completed successfully for "
					+ tableName, "info");
			stmt.close();
			conn.close();

			for (String s : this.facts) {
				if (s.equals(tableName)) {

					Properties p = new Properties();
					File pf = new File("tmpFile.properties");
					p.load(new FileReader(pf));
					lastModDate = p.getProperty(tableName);
					updateFactsProperty(factsPropFile, tableName, lastModDate);
				}
			}

		} catch (Exception ex) {
			loadEndTimeRS.add((loadEndTimeRS.size() + 1) - 1, "error");
			checkList.put(tableName, "Loading Error");
			System.out
					.println("Error occured while loading data from S3 to Redshift Cluster for "
							+ tableName);
			System.out.println("System now trying to load data from local...");

			writeLog(
					"RunID "
							+ RunID
							+ eol
							+ "Error occured while loading data from S3 to Redshift Cluster for "
							+ tableName + eol + ex.getMessage(), "error");

		} finally {
			// Finally block to close resources.
			try {
				if (stmt != null)
					stmt.close();
			} catch (Exception ex) {
			}// nothing we can do
			try {
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}

	}

	public void reviewDataLoadingSession() {
		int errCount = 0;
		int successCount = 0;
		System.out.println("DataLoading Operation completed.");

		for (Map.Entry<String, String> entry : checkList.entrySet()) {
			if (entry.getValue().equalsIgnoreCase("Extraction Error")) {

				errCount++;

			} else if (entry.getValue().equalsIgnoreCase("Loading Error")) {

				errCount++;

			} else {
				successCount++;
			}
		}

		if (errCount > 0) {
			writeLog(
					"RunID "
							+ RunID
							+ eol
							+ "Out of "
							+ (dimensions.length + facts.length)
							+ "tables "
							+ successCount
							+ " tables are loaded successfully. \n Program will try to load all the failure tables in the next run",
					"info");
			System.out
					.println("Out of "
							+ (dimensions.length + facts.length)
							+ "tables "
							+ successCount
							+ " tables are loaded successfully. \n Program will try to load all the failure tables in the next run");
			cleanResources();
			System.exit(0);

		} else {
			writeLog("RunID " + RunID + eol
					+ "All tables are loaded sucessfully", "info");
			System.out.println("All tables are loaded successfully");
			cleanResources();
			System.exit(0);
		}
	}

	// Utility methods
	public int convertToNumber(String value, String propertyName) {
		try {
			return Integer.valueOf(value);
		} catch (NumberFormatException e) {
			throw new RuntimeException(propertyName + " must be a number: "
					+ value);
		}
	}

	public File getLastFileModifiedFile(String dir, String prefix) {
		File fl = new File(dir);
		File[] files = fl.listFiles(new FileFilter() {
			public boolean accept(File file) {
				return file.isFile();
			}
		});
		long lastMod = Long.MIN_VALUE;
		File choice = null;
		for (File file : files) {
			if ((file.lastModified() > lastMod)
					&& (file.getName().startsWith(prefix))) {
				choice = file;
				lastMod = file.lastModified();
			}
		}
		return choice;
	}

	private List<String> getColumnNames(ResultSet resultSet)
			throws SQLException {
		List<String> columnNames = new ArrayList<String>();
		ResultSetMetaData metaData = resultSet.getMetaData();
		columnNames.add("RunID");
		for (int i = 0; i < metaData.getColumnCount(); i++) {
			// indexing starts from 1
			columnNames.add(metaData.getColumnName(i + 1));
		}
		return columnNames;
	}

	private void cleanResources() {
		if (resultSet != null) {
			try {
				resultSet.close();
			} catch (SQLException e) {
			}
		}
		if (statement != null) {
			try {
				statement.close();
			} catch (SQLException e) {
			}
		}
		if (con != null) {
			try {
				con.close();
			} catch (SQLException e) {
			}
		}
	}

	private void writeLog(String msg, String type) {

		Logger logger = Logger.getLogger("AppLog");
		logger.setUseParentHandlers(false);

		switch (type) {
		case "info":
			try {
				FileHandler fh = new FileHandler(logLocation + File.separator
						+ "App.log", true);
				logger.addHandler(fh);
				SimpleFormatter formatter = new SimpleFormatter();
				fh.setFormatter(formatter);
				logger.info(msg);
				fh.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return;
		case "error":
			try {
				FileHandler fh = new FileHandler(logLocation + File.separator
						+ "App.log", true);
				logger.addHandler(fh);
				SimpleFormatter formatter = new SimpleFormatter();
				fh.setFormatter(formatter);
				logger.severe(msg);
				fh.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
			return;
		}

	}

	private void writeStatusReport(int RunID, String tblName, String extStart,
			String extEnd, String loadStart, String loadEnd,
			String loadStartRS, String loadEndRS, boolean headers)
			throws ParseException {

		String Status, content;
		if (extEnd.equalsIgnoreCase("error")) {
			Status = "Error during Data Extraction";
			content = RunID + "\t\t\t" + tblName + "\t\t\t" + extStart
					+ "\t\t--\t\t" + loadStart + "\t\t" + loadEnd + "\t\t"
					+ Status;
		} else if (loadEnd.equalsIgnoreCase("error")) {
			Status = "Datafile created but S3 load error";
			content = RunID + "\t\t\t" + tblName + "\t\t\t" + extStart + "\t\t"
					+ extEnd + "\t\t" + loadStart + "\t\t--\t\t" + Status;
		} else if (loadEndRS.equalsIgnoreCase("error")) {

			Status = "Datafile created and loaded in S3 but Redshift load error";
			content = RunID + "\t\t\t" + tblName + "\t\t\t" + extStart + "\t\t"
					+ extEnd + "\t\t" + loadStart + "\t\t" + loadEnd + "\t\t"
					+ loadStartRS + "\t\t--\t\t" + Status;

		} else {
			Status = "Loaded";
			content = RunID + "\t\t\t" + tblName + "\t\t\t" + extStart + "\t\t"
					+ extEnd + "\t\t" + loadStart + "\t\t" + loadEnd + "\t\t"
					+ loadStartRS + "\t\t" + loadEndRS + "\t\t" + Status;
		}

		String FileName = statusRptLocation + File.separator
				+ "Status_Report.txt";

		File file = new File(FileName);

		try (PrintWriter out = new PrintWriter(new BufferedWriter(
				new FileWriter(file, true)))) {

			if (headers) {
				out.println("RunID \t\t\tTable\t\t\tExtractStartTime\t\tExtractEndTime\t\tLoadStartTime(S3)\t\tLoadEndTime(S3)\t\tLoadStartTime(Redshift)\t\tLoadEndTime(Redshift)\t\tStatus");
			}

			out.println(content);
			out.flush();
			out.close();
		}

		catch (IOException e) {

			e.printStackTrace();
		}

	}

	public String[] getListOfDimensionsFacts() {
		String[] files = null;
		if (dimensions != null && facts != null) {
			files = combine(dimensions, facts);
		} else if (dimensions != null && facts == null) {
			files = dimensions;
		} else {
			files = facts;

		}
		return files;
	}

	private void updateFactsProperty(String propName, String key, String value)
			throws FileNotFoundException {

		Properties props = new Properties();
		Writer writer = null;
		File f = new File(propName);
		if (f.exists()) {
			try {

				props.load(new FileReader(f));
				props.setProperty(key.trim(), value.trim());

				writer = new FileWriter(f);
				props.store(writer, null);
				writer.close();
			} catch (IOException e) {

				e.printStackTrace();
			}

		} else {
			throw new FileNotFoundException("Invalid Properties file or "
					+ propName + " not found");
		}
	}

	private String[] combine(String[] a, String[] b) {
		int length = a.length + b.length;
		String[] result = new String[length];
		System.arraycopy(a, 0, result, 0, a.length);
		System.arraycopy(b, 0, result, a.length, b.length);
		return result;
	}

	private boolean checkErrorStatus(String errorType, String tabName) {

		String status = checkList.get(tabName);
		boolean errorStatus = false;

		switch (errorType) {
		case "Extraction":
			if (status.equalsIgnoreCase("Extraction Error"))
				errorStatus = true;
			break;

		case "Loading":
			if (status.equalsIgnoreCase("Loading Error"))
				errorStatus = true;
			break;
		}
		return errorStatus;

	}

	public Connection createRedShiftDbCon() {

		Connection con = null;

		try {
			Class.forName("com.amazon.redshift.jdbc41.Driver");
			Properties props = new Properties();
			props.setProperty("user", redShiftMasterUsername);
			props.setProperty("password", redShiftMasterUserPassword);
			con = DriverManager.getConnection(dbURL, props);
		} catch (ClassNotFoundException e) {
			System.out.println("Error::createRedShiftDbCon()->"
					+ e.getMessage());
		} catch (SQLException e) {
			System.out.println("Error::createRedShiftDbCon()->"
					+ e.getMessage());
		}

		return con;

	}

	public void listFilesForFolder(final File folder) {
		for (final File fileEntry : folder.listFiles()) {
			if (fileEntry.isDirectory()) {
				listFilesForFolder(fileEntry);
			} else {
				System.out.println(fileEntry.getName());
			}
		}
	}
	
	public void updateRunID(int runID) {
		
		
		try {
			updateFactsProperty(appConfigPropFile, "RunID ", String.valueOf(runID));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) throws ClassNotFoundException,
			IOException, SQLException {

		String entity = "";
		if (args.length == 0) {
			DataLoader dl = new DataLoader();
			dl.createDbExtract();
			dl.doAmazonS3FileTransfer();

			final File folder = new File(dl.aSQLScriptFilePath);
			for (final File fileEntry : folder.listFiles()) {
				if (fileEntry.isDirectory()) {
					continue;
				} else {
					entity = fileEntry.getName().substring(0,
							fileEntry.getName().indexOf('_'));
					ScriptRunner scriptRunner = new ScriptRunner(
							dl.createRedShiftDbCon(), false, true, dl.RunID,
							entity);
					System.out.println("Executing ScriptRunner for entity "
							+ entity);
					scriptRunner.runScript(new FileReader(dl.aSQLScriptFilePath
							+ File.separator + fileEntry.getName()));
				}
			}

		} else {
			System.out.println("DataLoader running in mannual mode");
			String[] fileList = args[1].split(",");
			DataLoader dl = new DataLoader();
			dl.createDbExtract('r', fileList);
			dl.doAmazonS3FileTransfer('r', fileList);
		}

	}

}
