<#include "layout.ftl">

<h2>👤 Mi perfil</h2>

<div class="perfil-container">
    <div class="perfil-info">
        <p><strong>Nombre:</strong> ${usuario.nombre}</p>
        <p><strong>Apellido:</strong> ${usuario.apellido}</p>
        <p><strong>Dirección:</strong> ${usuario.direccion}</p>
        <p><strong>Usuario:</strong> ${usuario.username}</p>
        <p><strong>Rol:</strong> ${usuario.rol}</p>

        <p><strong>Foto de perfil:</strong></p>
        <img src="${usuario.fotoPerfil}" alt="Foto de perfil" style="width: 150px; border-radius: 50%; box-shadow: 0 0 5px #999; margin-top: 10px;">
    </div>

    <hr>

    <h3>✏️ Editar datos</h3>
    <form method="post" action="/perfil" enctype="multipart/form-data" class="formulario">
        <label>Nombre:
            <input type="text" name="nombre" value="${usuario.nombre}" required>
        </label>
        <label>Apellido:
            <input type="text" name="apellido" value="${usuario.apellido}" required>
        </label>
        <label>Dirección:
            <input type="text" name="direccion" value="${usuario.direccion}" required>
        </label>
        <label>Nueva foto de perfil:
            <input type="file" name="fotoPerfil" accept="image/*">
        </label>
        <button type="submit">Guardar cambios</button>
    </form>
</div>

</main></body></html>
