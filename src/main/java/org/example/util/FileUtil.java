package org.example.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileUtil {
    public static final String UPLOAD_DIR = "uploads";
    public static final String USUARIOS_DIR = UPLOAD_DIR + "/usuarios";
    public static final String PRODUCTOS_DIR = UPLOAD_DIR + "/productos";

    /**
     * Guarda un InputStream en un archivo
     *
     * @param inputStream el InputStream a guardar
     * @param filePath    la ruta del archivo donde se guardará el InputStream
     * @throws IOException si ocurre un error al guardar el archivo
     */
    public static void streamToFile(InputStream inputStream, String filePath) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            file.createNewFile();
        }
        Files.copy(inputStream, file.toPath());
    }
    /**
     * Inicializa los directorios necesarios para la aplicación
     */
    public static void inicializarDirectorios() {
        crearDirectorioSiNoExiste(UPLOAD_DIR);
        crearDirectorioSiNoExiste(USUARIOS_DIR);
        crearDirectorioSiNoExiste(PRODUCTOS_DIR);
    }

    /**
     * Crea un directorio si no existe
     *
     * @param dir el directorio a crear
     */
    private static void crearDirectorioSiNoExiste(String dir) {
        File directorio = new File(dir);
        if (!directorio.exists()) {
            directorio.mkdirs();
        }
    }
    /**
     * Guarda un archivo en el directorio especificado
     *
     * @param directorio    el directorio donde se guardará el archivo
     * @param nombreArchivo  el nombre del archivo a guardar
     * @param contenido      el contenido del archivo como byte[]
     * @return la ruta completa del archivo guardado
     * @throws IOException si ocurre un error al guardar el archivo
     */
    public static String guardarArchivo(String directorio, String nombreArchivo, byte[] contenido) throws IOException {
        crearDirectorioSiNoExiste(directorio);
        Path ruta = Paths.get(directorio, nombreArchivo);
        Files.write(ruta, contenido);
        return ruta.toString();
    }

    /**
     * Elimina un archivo en la ruta especificada
     *
     * @param ruta la ruta del archivo a eliminar
     */

    public static void eliminarArchivo(String ruta) {
        try {
            Files.deleteIfExists(Paths.get(ruta));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
