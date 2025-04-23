package org.example.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

public class FileUtil {
    
    /**
     * Guarda un InputStream en un archivo
     * @param input InputStream a guardar
     * @param fileName Ruta del archivo donde se guardará
     * @throws Exception Si ocurre un error al guardar el archivo
     */
    public static void streamToFile(InputStream input, String fileName) throws Exception {
        try (OutputStream output = new FileOutputStream(new File(fileName))) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }
    }
}
