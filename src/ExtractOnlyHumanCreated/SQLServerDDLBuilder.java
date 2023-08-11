package ExtractOnlyHumanCreated;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class SQLServerDDLBuilder extends DDLBuilder {

    @Override
    protected boolean isSystemGenerated(String schemaName, String tableName) {
        return schemaName.equalsIgnoreCase("sys") ||
                schemaName.equalsIgnoreCase("INFORMATION_SCHEMA");
    }

    protected StringBuilder getViewDDL(Connection connection, String schemaName, String tableName) throws SQLException {
        StringBuilder ddl = new StringBuilder();

        ResultSet viewDefinition = connection.createStatement().executeQuery(
                "SELECT definition " +
                        "FROM sys.objects o " +
                        "JOIN sys.sql_modules m ON m.object_id = o.object_id " +
                        "WHERE o.object_id = OBJECT_ID('" + schemaName + "." + tableName + "') " +
                        "AND o.type = 'V'"
        );
        if (viewDefinition.next()) {
            ddl.append("-- View: ").append(schemaName).append(".").append(tableName).append("\n");
            ddl.append(viewDefinition.getString("definition")).append(";\n\n");
        }
        viewDefinition.close();

        return ddl;
    }

    @Override
    protected TableBuilder createTableBuilder(DatabaseMetaData metaData, String schemaName, String tableName) throws SQLException {
        return new SQLServerTableBuilder(metaData, schemaName, tableName);
    }

    private class SQLServerTableBuilder extends TableBuilder {
        private Set<String> primaryKeyColumns;
        public SQLServerTableBuilder(DatabaseMetaData metaData, String schemaName, String tableName) {
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
                boolean isAutoIncrement = "YES".equalsIgnoreCase(columns.getString("IS_AUTOINCREMENT"));

                if (isAutoIncrement) {
                    ddl.append("  ").append(columnName).append(" int IDENTITY(1,1)");
                } else {
                    ddl.append("  ").append(columnName).append(" ").append(dataType);
                }
                if (dataType.equalsIgnoreCase("VARCHAR") || dataType.equalsIgnoreCase("CHAR") || dataType.equalsIgnoreCase("NVARCHAR") || dataType.equalsIgnoreCase("NCHAR")) {
                    ddl.append("(").append(columnSize).append(")");
                } else if (dataType.equalsIgnoreCase("DECIMAL") || dataType.equalsIgnoreCase("NUMERIC")) {
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
                ddl.append("  CONSTRAINT ").append(pkName).append(" PRIMARY KEY (");
                ddl.append(String.join(", ", pkColumns));
                ddl.append("),\n");
            }
            this.primaryKeyColumns = new HashSet<>(pkColumns);
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

                if (primaryKeyColumns.contains(columnName)) {
                    continue; // Ignores primary key indexes because they are already defined
                }

                if (isUnique) {
                    ddl.append("  CONSTRAINT ").append(indexName).append(" UNIQUE (").append(columnName).append("),\n");
                } else {
                    ddl.append("  INDEX ").append(indexName).append(" (").append(columnName).append("),\n");
                }
            }
            uniqueKeys.close();
            return ddl;
        }
    }
}