<#include "layout.ftl">

<h2>📦 Dashboard - Productos</h2>

<#if productos??>
<p>Total productos: ${productos?size}</p>

<#if productos?size > 0>
<ul>
<#list productos as p>
<li>
<strong>${p.nombre}</strong> - ${p.precio} €
<br>
Imagen: <img src="${p.imagenUrl}" width="150">
            </li>
        </#list>
        </ul>
    <#else>
        <p>❌ No hay productos en la lista.</p>
    </#if>

<#else>
    <p>⚠️ La lista 'productos' no se ha recibido.</p>
</#if>

</main></body></html>
