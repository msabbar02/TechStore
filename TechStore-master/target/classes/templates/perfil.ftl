<#include "layout.ftl">
<h2>👤 Mi perfil</h2>

<form method="post" action="/perfil">
    <input type="text" name="nombre" value="${usuario.nombre}" placeholder="Nombre" required>
    <input type="text" name="apellido" value="${usuario.apellido}" placeholder="Apellido" required>
    <input type="text" name="direccion" value="${usuario.direccion}" placeholder="Dirección" required>
    <input type="text" name="fotoPerfil" value="${usuario.fotoPerfil!}" placeholder="URL de foto">
    <input type="submit" value="Guardar cambios">
</form>
</main></body></html>
