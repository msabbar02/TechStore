<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registrarse - TechStore</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --background: #f8fafc;
            --white: #ffffff;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --error: #dc2626;
            --shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #1e3a8a, #2563eb, #38bdf8);
            font-family: 'Poppins', sans-serif;
            padding: 2rem;
        }

        .auth-card {
            background: var(--white);
            padding: 2.5rem;
            border-radius: 16px;
            width: 100%;
            max-width: 480px;
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
            transition: all 0.3s ease;
            margin-top: 1rem;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: scale(1.02);
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
            transition: color 0.3s;
        }

        .extra-links a:hover {
            color: var(--primary-dark);
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

        .password-strength {
            height: 6px;
            margin-top: 5px;
            border-radius: 4px;
            background-color: #e5e7eb;
            overflow: hidden;
        }

        .password-meter {
            height: 100%;
            width: 0;
            background-color: red;
            transition: width 0.4s ease, background-color 0.4s ease;
        }

        .input-error {
            font-size: 0.8rem;
            color: var(--error);
            margin-top: 0.25rem;
            display: none;
        }
    </style>
</head>

<body>

<div class="auth-card">
    <h2><i class="fas fa-user-plus"></i> Crear Cuenta</h2>

    <#if error?? && error?has_content>
        <div class="error-message">
            ${error}
        </div>
    </#if>

    <form action="/registro" method="post" enctype="multipart/form-data" id="form-registro">

        <div class="mb-3">
            <label for="nombre" class="form-label"><i class="fas fa-user"></i> Nombre</label>
            <input type="text" id="nombre" name="nombre" class="form-control" required>
            <div class="input-error" id="nombre-error">Nombre requerido</div>
        </div>

        <div class="mb-3">
            <label for="apellido" class="form-label"><i class="fas fa-user"></i> Apellido</label>
            <input type="text" id="apellido" name="apellido" class="form-control" required>
            <div class="input-error" id="apellido-error">Apellido requerido</div>
        </div>

        <div class="mb-3">
            <label for="direccion" class="form-label"><i class="fas fa-map-marker-alt"></i> Dirección</label>
            <input type="text" id="direccion" name="direccion" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="username" class="form-label"><i class="fas fa-envelope"></i> Usuario</label>
            <input type="text" id="username" name="username" class="form-control" required>
            <div class="input-error" id="username-error">Usuario requerido</div>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label"><i class="fas fa-lock"></i> Contraseña</label>
            <input type="password" id="password" name="password" class="form-control" required>
            <div class="password-strength">
                <div class="password-meter" id="password-meter"></div>
            </div>
        </div>

        <div class="mb-3">
            <label for="fotoPerfil" class="form-label"><i class="fas fa-image"></i> Foto de Perfil</label>
            <input type="file" id="fotoPerfil" name="fotoPerfil" class="form-control" accept="image/*">
        </div>

        <button type="submit" class="btn btn-primary">Registrarse</button>
    </form>

    <div class="extra-links">
        ¿Ya tienes cuenta? <a href="/login">Iniciar sesión</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script de validaciones -->
<script>
    const form = document.getElementById('form-registro');
    const nombre = document.getElementById('nombre');
    const apellido = document.getElementById('apellido');
    const username = document.getElementById('username');
    const password = document.getElementById('password');
    const passwordMeter = document.getElementById('password-meter');

    nombre.addEventListener('blur', () => {
        document.getElementById('nombre-error').style.display = nombre.value.trim() ? 'none' : 'block';
    });

    apellido.addEventListener('blur', () => {
        document.getElementById('apellido-error').style.display = apellido.value.trim() ? 'none' : 'block';
    });

    username.addEventListener('blur', () => {
        document.getElementById('username-error').style.display = username.value.trim() ? 'none' : 'block';
    });

    password.addEventListener('input', () => {
        const length = password.value.length;
        let width = 0;
        let color = 'red';

        if (length >= 6) width = 50;
        if (length >= 8) width = 75;
        if (length >= 10) width = 100;

        if (length >= 6) color = '#f59e0b';
        if (length >= 8) color = '#2563eb';
        if (length >= 10) color = '#10b981';

        passwordMeter.style.width = width + '%';
        passwordMeter.style.backgroundColor = color;
    });

    form.addEventListener('submit', (e) => {
        if (!nombre.value.trim() || !apellido.value.trim() || !username.value.trim()) {
            e.preventDefault();
            nombre.dispatchEvent(new Event('blur'));
            apellido.dispatchEvent(new Event('blur'));
            username.dispatchEvent(new Event('blur'));
        }
    });
</script>

</body>
</html>
