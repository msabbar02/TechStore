<#include "layout.ftl">
<h2>Nuevo producto</h2>

<form method="post" action="/productos/nuevo" enctype="multipart/form-data">
    <input type="text" name="nombre" placeholder="Nombre" required>
    <input type="text" name="descripcion" placeholder="Descripción" required>
    <input type="number" step="0.01" name="precio" placeholder="Precio" required>
    <input type="file" name="imagen" accept="image/*" required>
    <input type="submit" value="Guardar">
</form>
</main></body></html>
