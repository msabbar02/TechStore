<#include "layout.ftl">
<h2>Crear cuenta</h2>

<#if error??>
<p class="error">${error}</p>
</#if>

<form method="post" action="/register">
    <input type="text" name="nombre" placeholder="Nombre" required>
    <input type="text" name="apellido" placeholder="Apellido" required>
    <input type="text" name="direccion" placeholder="Dirección" required>
    <input type="text" name="username" placeholder="Usuario" required>
    <input type="password" name="password" placeholder="Contraseña" required>
    <input type="text" name="fotoPerfil" placeholder="URL de foto">
    <input type="submit" value="Registrarse">
</form>
</main></body></html>
