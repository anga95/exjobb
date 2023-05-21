package ExtractOnlyHumanCreated;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Db2DDLBuilder extends DDLBuilder {

    @Override
    protected boolean isSystemGenerated(String schemaName, String tableName) {
        return schemaName.startsWith("SYS");
    }

    protected StringBuilder getViewDDL(Connection connection, String schemaName, String tableName) throws SQLException {
        StringBuilder ddl = new StringBuilder();

        ResultSet viewDefinition = connection.createStatement().executeQuery(
                "SELECT TEXT " +
                        "FROM SYSIBM.SYSVIEWS " +
                        "WHERE NAME='" + tableName + "' " +
                        "AND CREATOR='" + schemaName + "'"
        );
        if (viewDefinition.next()) {
            ddl.append("-- View: ").append(schemaName).append(".").append(tableName).append("\n");
            ddl.append(viewDefinition.getString("TEXT")).append(";\n\n");
        }
        viewDefinition.close();

        return ddl;
    }

    @Override
    protected TableBuilder createTableBuilder(DatabaseMetaData metaData, String schemaName, String tableName) {
        return new Db2TableBuilder(metaData, schemaName, tableName);
    }

    private class Db2TableBuilder extends TableBuilder {

        public Db2TableBuilder(DatabaseMetaData metaData, String schemaName, String tableName) {
            super(metaData, schemaName, tableName);
        }

        public StringBuilder getColumnsDefinition() throws SQLException {
                StringBuilder ddl = new StringBuilder();
                ResultSet columns = metaData.getColumns(null, schemaName, tableName, "%");
                while (columns.next()) {
                    String columnName = columns.getString("COLUMN_NAME");
                    String dataType = columns.getString("TYPE_NAME");
                    int columnSize = columns.getInt("COLUMN_SIZE");
                    int decimalDigits = columns.getInt("DECIMAL_DIGITS");
                    boolean isNullable = columns.getString("IS_NULLABLE").equalsIgnoreCase("YES");

                    ddl.append("  ").append(columnName).append(" ").append(dataType);
                    if (dataType.equalsIgnoreCase("VARCHAR") || dataType.equalsIgnoreCase("CHAR")) {
                        ddl.append("(").append(columnSize).append(")");
                    } else if (dataType.equalsIgnoreCase("DECIMAL")) {
                        ddl.append("(").append(columnSize).append(", ").append(decimalDigits).append(")");
                    }
                    if (!isNullable) {
                        ddl.append(" NOT NULL");
                    }
                    ddl.append(",\n");
                }
                columns.close();
                return ddl;
            }

            public StringBuilder getPrimaryKeysDefinition() throws SQLException {
                StringBuilder ddl = new StringBuilder();
                ResultSet primaryKeys = metaData.getPrimaryKeys(null, schemaName, tableName);
                List<String> pkColumns = new ArrayList<>();
                String pkName = "";
                while (primaryKeys.next()) {
                    pkName = primaryKeys.getString("PK_NAME");
                    pkColumns.add(primaryKeys.getString("COLUMN_NAME"));
                }
                primaryKeys.close();
                if (!pkColumns.isEmpty()) {
                    ddl.append("  PRIMARY KEY (");
                    ddl.append(String.join(", ", pkColumns));
                    ddl.append("),\n");
                }
                return ddl;
            }

            public StringBuilder getUniqueKeysAndIndexesDefinition() throws SQLException {
                StringBuilder ddl = new StringBuilder();
                ResultSet uniqueKeys = metaData.getIndexInfo(null, schemaName, tableName, true, false);
                while (uniqueKeys.next()) {
                    if (uniqueKeys.getShort("TYPE") == DatabaseMetaData.tableIndexStatistic) {
                        continue; // Ignore statistic entries
                    }
                    String indexName = uniqueKeys.getString("INDEX_NAME");
                    String columnName = uniqueKeys.getString("COLUMN_NAME");
                    boolean isUnique = !uniqueKeys.getBoolean("NON_UNIQUE");
                    if (isUnique) {
                        ddl.append("  UNIQUE (").append(columnName).append("),\n");
                    } else {
                        ddl.append("  INDEX ").append(indexName).append(" (").append(columnName).append("),\n");
                    }
                }
                uniqueKeys.close();
                return ddl;
            }
        }
}