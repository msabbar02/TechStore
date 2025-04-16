<#include "layout.ftl">
<h2>${producto.nombre}</h2>

<div class="card">
    <img src="${producto.imagenUrl}" class="producto-img">
    <p><strong>${producto.descripcion}</strong></p>
    <p><strong>${producto.precio} €</strong></p>
    <form method="post" action="/carrito/${producto.id}/añadir">
        <button class="btn">🛒 Añadir al carrito</button>
    </form>
</div>

<a class="btn" href="/index">← Volver</a>
</main></body></html>
