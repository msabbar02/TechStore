<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Perfil - TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --background: #f9fafb;
            --text: #1e293b;
            --border: #e2e8f0;
        }

        body {
            background: var(--background);
            font-family: 'Poppins', sans-serif;
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            padding: 1rem 0;
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            font-size: 1.5rem;
        }

        .profile-container {
            width: 100%;
            max-width: 500px;
            background: #ffffff;
            margin: 3rem auto;
            padding: 2rem;
            border-radius: 12px;
            border: 1px solid var(--border);
        }

        .profile-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid var(--primary);
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        label {
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        input[type="text"], input[type="file"] {
            width: 100%;
            padding: 0.7rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            background-color: #f8fafc;
            transition: border-color 0.2s;
        }

        input[type="text"]:focus, input[type="file"]:focus {
            border-color: var(--primary);
            background: #ffffff;
            outline: none;
        }

        .btn-primary-custom {
            background-color: var(--primary);
            color: #ffffff;
            font-weight: 100;
            border: none;
            padding: 0.75rem;
            border-radius: 8px;
            width:60%;
            margin-top: 1rem;
            transition: background-color 0.3s ease;
        }

        .btn-primary-custom:hover {
            background-color: #1e40af;
        }

        .btn-secondary-custom {
            background-color: transparent;
            border: 2px solid var(--primary);
            color: var(--primary);
            font-weight: 600;
            padding: 0.75rem;
            border-radius: 8px;
            width: 100%;
            margin-top: 1rem; /* <-- aquí el margen-top corregido */
            transition: background-color 0.3s, color 0.3s;
        }

        .btn-secondary-custom:hover {
            background-color: var(--primary);
            color: #ffffff;
        }
    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="/"><i class="fas fa-laptop"></i> TechStore</a>
    </div>
</nav>

<!-- Contenido de perfil -->
<div class="profile-container text-center">
    <form action="/perfil/actualizar" method="post" enctype="multipart/form-data">

        <img src="${usuario.fotoPerfil!'/img/default-profile.jpg'}" alt="Foto de perfil" class="profile-img">

        <div class="form-group">
            <label for="fotoPerfil">Actualizar Foto de Perfil</label>
            <input type="file" name="fotoPerfil" id="fotoPerfil" accept="image/*">
        </div>


        <div class="form-group">
            <label for="nombre">Nombre</label>
            <input type="text" id="nombre" name="nombre" value="${usuario.nombre}" required>
        </div>

        <div class="form-group">
            <label for="apellido">Apellido</label>
            <input type="text" id="apellido" name="apellido" value="${usuario.apellido}" required>
        </div>

        <div class="form-group">
            <label for="username">Usuario</label>
            <input type="text" id="username" name="username" value="${usuario.username}" readonly>
        </div>

        <div class="form-group">
            <label for="direccion">Dirección de Envío</label>
            <input type="text" id="direccion" name="direccion" value="${usuario.direccion!''}">
        </div>

        <button type="submit" class="btn-primary-custom">
            <i class="fas fa-save"></i> Guardar Cambios
        </button>

        <a href="javascript:history.back()" class="btn-secondary-custom">
            <i class="fas fa-arrow-left"></i> Volver
        </a>

    </form>
</div>

<!-- Bootstrap Script -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
