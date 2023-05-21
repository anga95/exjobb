package ExtractOnlyHumanCreated;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

/**
 * This interface is used to build the DDL for the database.
 */
public interface DDLBuildInterface {
    StringBuilder buildDDL(DatabaseMetaData metaData, Connection connection) throws SQLException;

}
