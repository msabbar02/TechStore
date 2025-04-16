<#include "layout.ftl">
<h2>🛒 Tu carrito</h2>

<#if carrito?size == 0>
<p>El carrito está vacío.</p>
<#else>
<table>
<thead><tr><th>Producto</th><th>Precio</th></tr></thead>
<tbody>
<#assign total = 0>
<#list carrito as p>
<tr><td>${p.nombre}</td><td>${p.precio} €</td></tr>
<#assign total += p.precio>
</#list>
</tbody>
</table>
<p><strong>Total:</strong> ${total} €</p>
<form method="post" action="/carrito/comprar">
    <button class="btn">✅ Confirmar compra</button>
</form>
</#if>

<a class="btn" href="/index">← Volver</a>
</main></body></html>
