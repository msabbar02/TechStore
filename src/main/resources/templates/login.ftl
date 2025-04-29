<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar Sesión - TechStore</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --background: #001a33;
            --white: #ffffff;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --error: #dc2626;
            --shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--background);
            font-family: 'Poppins', sans-serif;
            padding: 2rem;
        }

        .auth-card {
            background: var(--white);
            padding: 2.5rem;
            border-radius: 16px;
            width: 100%;
            max-width: 400px;
            box-shadow: var(--shadow);
            animation: fadeIn 0.8s ease forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .auth-card h2 {
            text-align: center;
            color: var(--primary);
            margin-bottom: 1.5rem;
            font-weight: 700;
        }

        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }

        .form-control {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37,99,235,0.2);
        }

        .btn-primary {
            background-color: var(--primary);
            border: none;
            width: 100%;
            padding: 0.75rem;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            transition: background-color 0.3s;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .error-message {
            background: #fee2e2;
            color: var(--error);
            padding: 0.75rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-size: 0.95rem;
            text-align: center;
        }

        .extra-links {
            margin-top: 1rem;
            text-align: center;
            font-size: 0.95rem;
            color: var(--text-muted);
        }

        .extra-links a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            margin-left: 5px;
            transition: color 0.3s;
        }

        .extra-links a:hover {
            color: var(--primary-dark);
        }
    </style>
</head>

<body>

<div class="auth-card">
    <h2><i class="fas fa-laptop-code"></i> TechStore</h2>

    <#if error?? && error?has_content>
        <div class="error-message">
            ${error}
        </div>
    </#if>

    <form action="/login" method="post">
        <div class="mb-3">
            <label for="username" class="form-label"><i class="fas fa-user"></i> Usuario</label>
            <input type="text" id="username" name="username" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label"><i class="fas fa-lock"></i> Contraseña</label>
            <input type="password" id="password" name="password" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
    </form>

    <div class="extra-links">
        ¿No tienes cuenta? <a href="/registro">Regístrate</a>
    </div>

    <div class="extra-links" style="margin-top: 0.5rem;">
        <a href="/"><i class="fas fa-home"></i> Volver al inicio</a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
