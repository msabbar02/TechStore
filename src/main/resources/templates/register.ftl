<#include "layout.ftl">

<h2>📝 Registro de usuario</h2>

<#if error??>
<p style="color: red;">${error}</p>
</#if>

<form method="post" action="/register" enctype="multipart/form-data" class="formulario">
    <label>Nombre:
        <input type="text" name="nombre" required>
    </label>

    <label>Apellido:
        <input type="text" name="apellido" required>
    </label>

    <label>Dirección:
        <input type="text" name="direccion" required>
    </label>

    <label>Nombre de usuario:
        <input type="text" name="username" required>
    </label>

    <label>Contraseña:
        <input type="password" name="password" required>
    </label>

    <label>Foto de perfil:
        <input type="file" name="fotoPerfil" accept="image/*" required>
    </label>

    <button type="submit">Registrarse</button>
</form>

<p>¿Ya tienes cuenta? <a href="/login">Inicia sesión</a></p>

</main>
</body>
</html>
