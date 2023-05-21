import java.io.IOException;
import java.sql.*;
import java.io.File;
import ExtractOnlyHumanCreated.*;

public class Main {
    public static void main(String[] args) throws SQLException, IOException {
        //String dbUrl = "jdbc:db2://localhost:25000/Miun";String user = "db2admin";String password = "password";
        //String dbUrl = "jdbc:sqlserver://localhost\\SQLEXPRESS:61209;databaseName=Miun;encrypt=false"; String user = "msftsql"; String password = "password";
        String dbUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; String user = "andre"; String password = "password";


        boolean addGoStatements = false;

        Connection connection = DriverManager.getConnection(dbUrl, user, password);
        DatabaseMetaData metaData = connection.getMetaData();

        FileHandler fileHandler = new FileHandler();
        String databaseProductName = metaData.getDatabaseProductName();
        DDLBuildInterface ddlBuilder;
        String outputDirName;

        if (databaseProductName.toUpperCase().contains("DB2")) {
            ddlBuilder = new Db2DDLBuilder();
            outputDirName = "output_files" + File.separator + "db2" + File.separator;
        } else if (databaseProductName.equalsIgnoreCase("Microsoft SQL Server")) {
            ddlBuilder = new SQLServerDDLBuilder();
            outputDirName = "output_files" + File.separator + "SQL_Server"+ File.separator;
            addGoStatements = true;
        } else if (databaseProductName.equalsIgnoreCase("Oracle")) {
            ddlBuilder = new OracleDDLBuilder();
            outputDirName = "output_files" + File.separator + "Oracle" + File.separator;
        } else {
            throw new UnsupportedOperationException("Unsupported database: " + databaseProductName);
        }

        StringBuilder ddl = ddlBuilder.buildDDL(metaData, connection);

        fileHandler.writeDDLToFile(ddl, outputDirName, addGoStatements);
    }
}
