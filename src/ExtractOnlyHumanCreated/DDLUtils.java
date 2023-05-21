package ExtractOnlyHumanCreated;

/**
 * This class contains utility methods for DDL.
 * @version 1.0
 */
public class DDLUtils {
    public static StringBuilder addGoStatementsForSqlServer(StringBuilder ddl) {
        StringBuilder modifiedDDL = new StringBuilder();

        // Split the DDL by semicolon, and then add a GO statement after each semicolon
        String[] ddlStatements = ddl.toString().split(";");
        for (String statement : ddlStatements) {
            modifiedDDL.append(statement.trim());
            if (!statement.trim().isEmpty()) {
                modifiedDDL.append(";\nGO\n\n");
            }
        }

        return modifiedDDL;
    }
}
