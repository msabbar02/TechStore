<#include "layout.ftl">
<h2>${producto?? ? 'Editar producto' : 'Nuevo producto'}</h2>

<form method="post" action="${producto?? ? ('/productos/' + producto.id + '/editar') : '/productos/nuevo'}">
    <input type="text" name="nombre" value="${producto.nombre!}" placeholder="Nombre" required>
    <input type="text" name="descripcion" value="${producto.descripcion!}" placeholder="Descripción" required>
    <input type="number" step="0.01" name="precio" value="${producto.precio!}" placeholder="Precio" required>
    <input type="text" name="imagenUrl" value="${producto.imagenUrl!}" placeholder="URL de imagen" required>
    <input type="submit" value="Guardar">
</form>
</main>
</body>
</html>