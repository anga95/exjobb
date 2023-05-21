package ExtractOnlyHumanCreated;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;

/**
 * This class is used to build the DDL for SQL Server.
 * @version 1.0
 *
 */
public abstract class DDLBuilder implements DDLBuildInterface{

    /**
     * This method is used to determine if the table is system generated or not.
     * @param schemaName the name of the schema to be checked
     * @param tableName the name of the table to be checked
     * @return boolean
     */
    protected abstract boolean isSystemGenerated(String schemaName, String tableName);

    /**
     * This method is used to build the DDL for the database.
     * @param metaData the metadata of the database
     * @param connection the connection to the database
     * @return StringBuilder the DDL for the database
     */
    public StringBuilder buildDDL(DatabaseMetaData metaData, Connection connection) throws SQLException {
        Set<String> createdSchemas = new HashSet<>();
        StringBuilder ddl = new StringBuilder();

        ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE", "VIEW"}); // Get tables and views from all schemas
        while (tables.next()) {
            String schemaName = tables.getString("TABLE_SCHEM");
            String tableName = tables.getString("TABLE_NAME");
            String tableType = tables.getString("TABLE_TYPE");

            if (isSystemGenerated(schemaName, tableName)) {
                continue;
            }
            if (!createdSchemas.contains(schemaName)) {
                ddl.append("-- Schema: ").append(schemaName).append("\n");
                ddl.append("CREATE SCHEMA ").append(schemaName).append(";\n\n");
                createdSchemas.add(schemaName);
            }

            if ("VIEW".equals(tableType)) {
                StringBuilder viewDDL = getViewDDL(connection, schemaName, tableName);
                ddl.append(viewDDL);
            } else {
                StringBuilder tableDDL = getTableDDL(metaData, connection, schemaName, tableName);
                ddl.append(tableDDL);
            }
        }
        tables.close();
        return ddl;
    }

    /**
     * Retrieves the DDL-command for a view
     * @param connection A Connection object to the database
     * @param schemaName The name of the schema
     * @param tableName The name of the table
     * @return A StringBuilder object containing the DDL-command for the view
     * @throws SQLException If an error occurs while retrieving the metadata
     */
    protected abstract StringBuilder getViewDDL(Connection connection, String schemaName, String tableName) throws SQLException;

    /**
     * Creates a TableBuilder object for the specified database (Oracle, Db2, SQL Server)
     * @param metaData The metadata of the database
     * @param schemaName The name of the schema
     * @param tableName The name of the table
     * @return A TableBuilder object for the specified Database
     * @throws SQLException If an error occurs while retrieving the metadata
     */
    protected abstract TableBuilder createTableBuilder(DatabaseMetaData metaData, String schemaName, String tableName) throws SQLException;

    /**
     * Constructs the DDL-command for a specified table in the database
     * @param metaData The metadata of the database
     * @param connection A Connection object to the database
     * @param schemaName The name of the schema
     * @param tableName The name of the table
     * @return A StringBuilder object containing the DDL-command for the table
     * @throws SQLException If an error occurs while retrieving the metadata
     */
    private StringBuilder getTableDDL(DatabaseMetaData metaData, Connection connection, String schemaName, String tableName) throws SQLException {
        StringBuilder ddl = new StringBuilder();
        TableBuilder tableBuilder = createTableBuilder(metaData, schemaName, tableName);

        ddl.append("-- Table: ").append(schemaName).append(".").append(tableName).append("\n");
        ddl.append("CREATE TABLE ").append(schemaName).append(".").append(tableName).append(" (\n");

        ddl.append(tableBuilder.getColumnsDefinition());
        ddl.append(tableBuilder.getPrimaryKeysDefinition());
        ddl.append(tableBuilder.getUniqueKeysAndIndexesDefinition());
        removeTrailingCommaAndCloseTable(ddl);

        ddl.append(tableBuilder.getForeignKeysDefinition());

        return ddl;
    }

    /**
     * Abstract base class representing a builder for a database table
     * Provides abstract methods for getting the columns, primary keys, unique keys and indexes
     * and a concrete method for getting the foreign keys
     * Each method returns a StringBuilder object containing the DDL-command for the specified part of the table
     * The actual implementation of the methods is done in the subclasses
     */
    protected abstract class TableBuilder {
        protected DatabaseMetaData metaData;
        protected String schemaName;
        protected String tableName;

        /**
         * Constructs a new TableBuilder instance.
         * @param metaData the metadata of the database
         * @param schemaName the name of the schema
         * @param tableName the name of the table
         */
        public TableBuilder(DatabaseMetaData metaData, String schemaName, String tableName) {
            this.metaData = metaData;
            this.schemaName = schemaName;
            this.tableName = tableName;
        }

        /**
         * This method is used to get the columns definition.
         * @return StringBuilder the columns definition
         * @throws SQLException if a database access error occours
         */
        public abstract StringBuilder getColumnsDefinition() throws SQLException;

        /**
         * This method is used to get the primary keys definition.
         * @return StringBuilder the primary keys definition
         * @throws SQLException if a database access error occours
         */
        public abstract StringBuilder getPrimaryKeysDefinition() throws SQLException;

        /**
         * This method is used to get the unique keys and indexes definition.
         * @return StringBuilder the unique keys and indexes definition
         * @throws SQLException if a database access error occours
         */
        public abstract StringBuilder getUniqueKeysAndIndexesDefinition() throws SQLException;

        /**
         * This method is used to get the foreign keys definition.
         * This method is implemented in this class because it is the same for all databases.
         * @return StringBuilder the foreign keys definition
         */
        public StringBuilder getForeignKeysDefinition() throws SQLException {
            StringBuilder ddl = new StringBuilder();
            ResultSet foreignKeys = metaData.getImportedKeys(null, schemaName, tableName);
            while (foreignKeys.next()) {
                String fkName = foreignKeys.getString("FK_NAME");
                String fkColumnName = foreignKeys.getString("FKCOLUMN_NAME");
                String pkTableName = foreignKeys.getString("PKTABLE_NAME");
                String pkColumnName = foreignKeys.getString("PKCOLUMN_NAME");
                String fkSchemaName = foreignKeys.getString("FKTABLE_SCHEM");
                String pkSchemaName = foreignKeys.getString("PKTABLE_SCHEM");

                ddl.append("-- Foreign Key Constraint: ").append(fkName).append("\n");
                ddl.append("ALTER TABLE ").append(fkSchemaName).append(".").append(tableName)
                        .append(" ADD CONSTRAINT ").append(fkName)
                        .append(" FOREIGN KEY (").append(fkColumnName).append(")")
                        .append(" REFERENCES ").append(pkSchemaName).append(".").append(pkTableName)
                        .append(" (").append(pkColumnName).append(");\n\n");
            }
            foreignKeys.close();
            return ddl;
        }
    }

    /**
     * This method is used to remove the trailing comma and closes the table.
     * @param ddl the DDL for the database
     */
    void removeTrailingCommaAndCloseTable(StringBuilder ddl) {
        ddl.delete(ddl.length() - 2, ddl.length());
        ddl.append(");\n\n");
    }

}
