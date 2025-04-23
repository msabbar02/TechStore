<#import "layout.ftl" as layout>

<@layout.layout title="Registro - TechStore" showNavbar=false>
    <style>
        .register-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            background: linear-gradient(135deg, #2563eb, #0ea5e9);
        }

        .register-card {
            background: white;
            padding: 2.5rem;
            border-radius: 16px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
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

        .btn-register {
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

        .btn-register:hover {
            background-color: #1d4ed8;
        }

        .login-link {
            text-align: center;
            margin-top: 1rem;
        }

        .login-link a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
        }

        .error-message {
            background-color: #fee2e2;
            border: 1px solid #ef4444;
            color: #dc2626;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
    </style>

    <div class="register-container">
        <div class="register-card">
            <h2 style="text-align: center; margin-bottom: 2rem;">
                <i class="fas fa-user-plus"></i> Registro
            </h2>

            <#if error??>
                <div class="error-message">
                    ${error}
                </div>
            </#if>

            <form action="/register" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Nombre</label>
                    <input type="text" name="nombre" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Apellido</label>
                    <input type="text" name="apellido" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Dirección</label>
                    <input type="text" name="direccion" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Usuario</label>
                    <input type="text" name="username" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Contraseña</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Foto de perfil</label>
                    <input type="file" name="fotoPerfil" accept="image/*" class="form-control" required>
                </div>

                <button type="submit" class="btn-register">
                    Registrarse
                </button>
            </form>

            <div class="login-link">
                ¿Ya tienes cuenta? <a href="/login">Iniciar sesión</a>
            </div>
        </div>
    </div>
</@layout.layout>