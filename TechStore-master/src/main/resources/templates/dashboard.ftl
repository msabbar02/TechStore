<#include "layout.ftl">
<h2>Dashboard</h2>
<a class="btn" href="/productos/nuevo">➕ Añadir producto</a>

<div class="grid">
    <#if productos?? && productos?size > 0>
        <#list productos?keys as id>
            <div class="card">
                <img src="${productos[id].imagenUrl}" alt="${productos[id].nombre}" class="producto-img">
                <h3>${productos[id].nombre}</h3>
                <p>${productos[id].descripcion}</p>
                <p><strong>${productos[id].precio} €</strong></p>
                <a class="btn" href="/productos/${id}/editar">✏️ Editar</a>
                <form method="post" action="/productos/${id}/eliminar" style="display:inline">
                    <button class="btn eliminar" type="submit">❌ Eliminar</button>
                </form>
            </div>
        </#list>
    <#else>
        <p>No hay productos registrados.</p>
    </#if>
</div>
</main>
</body>
</html>