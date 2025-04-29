package org.example.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

public class PasswordUtil {
    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 512;
    private static final String ALGORITHM = "PBKDF2WithHmacSHA512";

    /**
     * Genera un hash seguro para la contraseña proporcionada
     * @param password La contraseña a hashear
     * @return String con el hash en formato: salt:hash
     */
    public static String hashPassword(String password) {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);

        try {
            PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                ITERATIONS,
                KEY_LENGTH
            );

            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] hash = factory.generateSecret(spec).getEncoded();

            // Combinar salt y hash en un string, separados por ":"
            String encodedSalt = Base64.getEncoder().encodeToString(salt);
            String encodedHash = Base64.getEncoder().encodeToString(hash);
            return encodedSalt + ":" + encodedHash;

        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("Error al hashear la contraseña", e);
        }
    }

    /**
     * Verifica si una contraseña coincide con su hash
     * @param password La contraseña a verificar
     * @param storedHash El hash almacenado (en formato salt:hash)
     * @return true si la contraseña coincide, false en caso contrario
     */
    public static boolean verificarPassword(String password, String storedHash) {
        try {
            // Verificar que los parámetros no sean nulos
            if (password == null || storedHash == null) {
                System.err.println("Error: password o storedHash es null");
                return false;
            }
            
            // Separar el salt y el hash almacenados
            String[] parts = storedHash.split(":");
            if (parts.length != 2) {
                System.err.println("Error: formato de hash incorrecto - debe ser salt:hash");
                return false;
            }
    
            byte[] salt;
            byte[] hash;
            
            try {
                salt = Base64.getDecoder().decode(parts[0]);
                hash = Base64.getDecoder().decode(parts[1]);
            } catch (IllegalArgumentException e) {
                System.err.println("Error al decodificar salt o hash: " + e.getMessage());
                return false;
            }
    
            // Generar nuevo hash con la contraseña proporcionada y el salt almacenado
            PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                ITERATIONS,
                KEY_LENGTH
            );
    
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] testHash = factory.generateSecret(spec).getEncoded();
    
            // Comparar los hashes
            if (hash.length != testHash.length) {
                System.err.println("Error: longitudes de hash diferentes - almacenado: " + 
                                  hash.length + ", calculado: " + testHash.length);
                return false;
            }
            
            int diff = 0;
            for (int i = 0; i < hash.length; i++) {
                diff |= hash[i] ^ testHash[i];
            }
            return diff == 0;
    
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            System.err.println("Error al verificar contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Error inesperado al verificar contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}