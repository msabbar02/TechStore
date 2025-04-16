<h2>Catálogo de productos</h2>

<div class="grid">
<#if productos?? && productos?size > 0>
    <#list productos as p>
        <div class="card">
            <img src="${p.imagenUrl}" alt="${p.nombre}" class="producto-img">
            <h3>${p.nombre}</h3>
            <p>${p.descripcion}</p>
            <p><strong>${p.precio} €</strong></p>
            <form method="post" action="/carrito/${p.id}/añadir">
                <button class="btn">🛒 Añadir al carrito</button>
            </form>
            <a class="btn" href="/comprar/${p.id}">💳 Comprar</a>
        </div>
    </#list>
<#else>
    <p>No hay productos disponibles.</p>
</#if>
</div>