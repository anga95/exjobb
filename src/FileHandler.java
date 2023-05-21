import ExtractOnlyHumanCreated.DDLUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Created by andre on 2017-11-08.
 * This class handles the file creation and writing.
 */
public class FileHandler {
    /**
     * Creates the output directory if it does not exist .
     * @param databaseProductName The name of the database product.
     * @return The name of the output directory.
     * @throws IOException If the output directory could not be created.
     */
    public String createOutputDirectory(String databaseProductName) throws IOException {
        String outputDirName;
        if (databaseProductName.contains("DB2")) {
            outputDirName = "output_files" + File.separator + "db2";
        } else if (databaseProductName.contains("Microsoft SQL Server")) {
            outputDirName = "output_files" + File.separator + "SQL_Server";
        } else {
            outputDirName = "output_files" + File.separator + "not_recognized_db";
        }

        File outputDir = new File(outputDirName);
        if (!outputDir.exists()) {
            if (!outputDir.mkdirs()) {
                throw new IOException("Failed to create output directory: " + outputDirName);
            }
        }
        return outputDirName;
    }

    /**
     * Formats the current timestamp to yyMMdd_HHmm.
     * @return The formatted timestamp.
     */
    public static String formatTimestamp() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyMMdd_HHmm");
        String timestamp = LocalDateTime.now().format(formatter);
        return timestamp;
    }

    /**
     * Writes the DDL to a file. The file name is ddl_yyMMdd_HHmm.sql.
     * @param ddl The DDL to write to file.
     * @param outputDirName The name of the output directory.
     * @param addGoStatements If true, the DDL will have GO-statements after each DDL-command.
     * @throws IOException If the file could not be written.
     */
    public void writeDDLToFile(StringBuilder ddl, String outputDirName, boolean addGoStatements) throws IOException {
        String timestamp = FileHandler.formatTimestamp();
        String outputFilePath = outputDirName + File.separator + "ddl_" + timestamp + ".sql";
        File outputFile = new File(outputFilePath);
        try (OutputStream outputStream = new FileOutputStream(outputFile)) {
            outputStream.write(ddl.toString().getBytes());
        }
        if (addGoStatements){
            StringBuilder ddlWithGo = DDLUtils.addGoStatementsForSqlServer(ddl);
            String outputFilePathWithGo = outputDirName + File.separator + "ddl_" + timestamp + "_with_go.sql";
            File outputFileWithGo = new File(outputFilePathWithGo);
            try(OutputStream outputStreamWithGo = new FileOutputStream(outputFileWithGo) ) {
                outputStreamWithGo.write(ddlWithGo.toString().getBytes());
            }
        }
    }
}
