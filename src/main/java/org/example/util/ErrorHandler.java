package org.example.util;

import io.javalin.http.Context;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;


/**
 * Manejador de errores optimizado para la aplicación
 * Incluye manejo de errores de plantillas y respuestas eficientes
 */
public class ErrorHandler {
    private static final Logger logger = LoggerFactory.getLogger(ErrorHandler.class);

    /**
     * Maneja excepciones genéricas de la aplicación
     */
    public static void handleException(Exception e, Context ctx) {
        logger.error("Error no manejado: {}", e.getMessage(), e);
        ctx.status(500);
        
        // Sanear el mensaje de error para la presentación
        String mensajeError = e.getMessage();
        if (mensajeError == null || mensajeError.isEmpty()) {
            mensajeError = "Error desconocido";
        }
        
        // Limitar la longitud del mensaje para evitar desbordamientos
        if (mensajeError.length() > 500) {
            mensajeError = mensajeError.substring(0, 497) + "...";
        }
        
        // Evitar mostrar rutas absolutas o información sensible
        mensajeError = mensajeError.replaceAll("(C:|/home|/usr).*?/", "[PATH]/");
        
        // Usar try-catch para evitar errores en cascada con plantillas
        try {
            Map<String, Object> model = new HashMap<>();
            model.put("mensaje", "Ha ocurrido un error inesperado");
            model.put("error", mensajeError);
            
            // Intenta renderizar con la plantilla FTL más simple posible
            ctx.render("error.ftl", model);
        } catch (Exception renderException) {
            // Si falla la renderización, usar respuesta HTML directa sin depender de plantillas
            logger.error("Error al renderizar plantilla de error: {}", renderException.getMessage(), renderException);
            respondWithDirectHtml(ctx, "Error interno del servidor", mensajeError);
        }
    }

    /**
     * Maneja error 404 - Página no encontrada
     */
    public static void handle404(Context ctx) {
        ctx.status(404);
        try {
            ctx.render("error.ftl", Map.of(
                "mensaje", "Página no encontrada",
                "error", "La página que buscas no existe"
            ));
        } catch (Exception e) {
            logger.error("Error al renderizar plantilla 404: ", e);
            respondWithDirectHtml(ctx, "Página no encontrada", "La página que buscas no existe");
        }
    }

    /**
     * Maneja error 401 - No autorizado
     */
    public static void handle401(Context ctx) {
        ctx.status(401);
        try {
            ctx.render("error.ftl", Map.of(
                "mensaje", "No autorizado",
                "error", "Debes iniciar sesión para acceder a esta página"
            ));
        } catch (Exception e) {
            logger.error("Error al renderizar plantilla 401: ", e);
            respondWithDirectHtml(ctx, "No autorizado", "Debes iniciar sesión para acceder a esta página");
        }
    }

    /**
     * Maneja error 403 - Acceso denegado
     */
    public static void handle403(Context ctx) {
        ctx.status(403);
        try {
            ctx.render("error.ftl", Map.of(
                "mensaje", "Acceso denegado",
                "error", "No tienes permisos para acceder a esta página"
            ));
        } catch (Exception e) {
            logger.error("Error al renderizar plantilla 403: ", e);
            respondWithDirectHtml(ctx, "Acceso denegado", "No tienes permisos para acceder a esta página");
        }
    }
    
    /**
     * Método helper para enviar respuesta HTML directa en caso de errores
     * con las plantillas
     */
    private static void respondWithDirectHtml(Context ctx, String title, String message) {
        String html = "<!DOCTYPE html>" +
                      "<html lang='es'>" +
                      "<head>" +
                      "  <meta charset='UTF-8'>" +
                      "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                      "  <title>" + title + " - TechStore</title>" +
                      "  <style>" +
                      "    body { font-family: sans-serif; background: #f5f5f7; margin: 0; padding: 20px; display: flex; justify-content: center; align-items: center; min-height: 100vh; }" +
                      "    .error-box { background: white; border-radius: 8px; padding: 30px; max-width: 500px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
                      "    h1 { color: #1e293b; margin-top: 0; }" +
                      "    p { color: #64748b; }" +
                      "    .message { background: #f1f5f9; padding: 15px; border-radius: 6px; margin: 20px 0; text-align: left; }" +
                      "    a { display: inline-block; background: #2563eb; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; margin-top: 20px; }" +
                      "    a:hover { background: #1d4ed8; }" +
                      "  </style>" +
                      "</head>" +
                      "<body>" +
                      "  <div class='error-box'>" +
                      "    <h1>" + title + "</h1>" +
                      "    <p>Lo sentimos, se ha producido un error al procesar tu solicitud.</p>" +
                      "    <div class='message'>" + message + "</div>" +
                      "    <a href='/'>Volver al inicio</a>" +
                      "  </div>" +
                      "</body>" +
                      "</html>";
        
        ctx.contentType("text/html");
        ctx.result(html);
    }
}