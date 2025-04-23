<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - TechStore</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #2563eb, #0ea5e9);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .auth-card {
            background: white;
            padding: 2.5rem;
            border-radius: 16px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        }
        
        .error-message {
            background-color: #fee2e2;
            color: #dc2626;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .form-group {
            margin-bottom: 1.25rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #1e293b;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
        }
        
        button[type="submit"] {
            width: 100%;
            padding: 0.75rem;
            background-color: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        button[type="submit"]:hover {
            background-color: #1d4ed8;
        }
    </style>
</head>
<body>
    <div class="auth-card">
        <h2 style="text-align: center; margin-bottom: 2rem;">
            <i class="fas fa-laptop"></i> TechStore
        </h2>
        
        <#if error?? && error?has_content>
            <div class="error-message">
                ${error}
            </div>
        </#if>
        
        <form action="/login" method="post">
            <div class="form-group">
                <label for="username">
                    <i class="fas fa-user"></i> Usuario
                </label>
                <input type="text" id="username" name="username" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i> Contraseña
                </label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            
            <button type="submit">Iniciar Sesión</button>
        </form>
        
        <p style="text-align: center; margin-top: 1rem;">
            ¿No tienes cuenta? 
            <a href="/register" style="color: #2563eb; text-decoration: none;">Regístrate</a>
        </p>
        
        <p style="text-align: center; margin-top: 1rem;">
            <a href="/" style="color: #64748b; text-decoration: none;">
                <i class="fas fa-home"></i> Volver al inicio
            </a>
        </p>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>