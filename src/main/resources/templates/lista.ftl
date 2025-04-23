<!DOCTYPE html>
<html>
<head>
    <title>Mis Compras</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .ordenes-container {
            padding: 20px;
            max-width: 1000px;
            margin: 0 auto;
        }

        .orden-card {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
        }

        .orden-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .orden-estado {
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
        }

        .estado-pendiente { background-color: #ffd700; }
        .estado-completada { background-color: #90EE90; }
        .estado-cancelada { background-color: #ffcccb; }
    </style>
</head>
<body>
    <div class="ordenes-container">
        <h1>Mis Compras</h1>
        
        <#if ordenes?? && ordenes?size gt 0>
            <#list ordenes as orden>
                <div class="orden-card">
                    <div class="orden-header">
                        <span>Orden #${orden.id}</span>
                        <span class="orden-estado estado-${orden.estado?lower_case}">
                            ${orden.estado}
                        </span>
                    </div>
                    <div>Fecha: ${orden.fecha?string("dd/MM/yyyy HH:mm")}</div>
                    <div>Total: $${orden.total?string(",##0.00")}</div>
                    <a href="/ordenes/${orden.id}">Ver Detalle</a>
                </div>
            </#list>
        <#else>
            <p>No tienes compras realizadas</p>
        </#if>
        
        <a href="/catalogo_simple" class="btn-volver">Volver al Catálogo</a>
    </div>
</body>
</html>