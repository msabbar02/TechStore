<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - TechStore</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f7;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .error-container {
            max-width: 600px;
            text-align: center;
            padding: 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }

        .error-icon {
            font-size: 5rem;
            color: #dc2626;
            margin-bottom: 1rem;
        }
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - TechStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <#include "common-styles.ftl">
    
    <style>
        .error-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 60px);
            padding: 2rem;
            text-align: center;
        }
        
        .error-icon {
            font-size: 5rem;
            color: var(--danger-color);
            margin-bottom: 1.5rem;
        }
        
        .error-title {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }
        
        .error-message {
            font-size: 1.1rem;
            color: var(--text-light);
            margin-bottom: 2rem;
            max-width: 600px;
        }
        
        .error-details {
            background-color: var(--bg-light);
            padding: 1rem;
            border-radius: 0.5rem;
            color: var(--text-light);
            margin-bottom: 2rem;
            max-width: 800px;
            overflow-x: auto;
            font-family: monospace;
            text-align: left;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="/" class="navbar-brand">TechStore</a>
        <div class="navbar-nav">
            <a href="/catalogo_simple" class="nav-link">Catálogo</a>
            <a href="/login" class="btn btn-primary">Iniciar Sesión</a>
        </div>
    </nav>

    <div class="error-container">
        <i class="fas fa-exclamation-triangle error-icon"></i>
        <h1 class="error-title">${error!"Ha ocurrido un error"}</h1>
        <p class="error-message">${mensaje!"Lo sentimos, ha ocurrido un error inesperado. Por favor, inténtalo de nuevo más tarde."}</p>
        
        <#if ruta??>
            <div class="error-details">
                <p>Ruta: ${ruta}</p>
            </div>
        </#if>
        
        <div>
            <a href="/" class="btn btn-primary">
                <i class="fas fa-home"></i> Volver al Inicio
            </a>
            <a href="javascript:history.back()" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Volver Atrás
            </a>
        </div>
    </div>
</body>
</html>
        .error-title {
            font-size: 2rem;
            color: #1e293b;
            margin-bottom: 1rem;
        }

        .error-message {
            color: #64748b;
            margin-bottom: 2rem;
        }
        
        .error-details {
            background-color: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 2rem;
            text-align: left;
            font-family: monospace;
            overflow-x: auto;
            color: #475569;
            font-size: 0.875rem;
        }

        .btn-volver {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: #2563eb;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }

        .btn-volver:hover {
            background-color: #1d4ed8;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <i class="fas fa-exclamation-triangle error-icon"></i>
        <h1 class="error-title">${mensaje!"Ha ocurrido un error"}</h1>
        <p class="error-message">Lo sentimos, se ha producido un error al procesar tu solicitud.</p>
        
        <#if error?? && error?has_content>
        <div class="error-details">
            ${error}
        </div>
        </#if>
        
        <a href="/" class="btn-volver">
            <i class="fas fa-home"></i> Volver al Inicio
        </a>
    </div>
</body>
</html>