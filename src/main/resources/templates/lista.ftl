<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Pedidos - Admin TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap y Poppins -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: #f8fafc;
            font-family: 'Poppins', sans-serif;
            padding: 2rem;
        }
        .pedidos-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .pedido-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .pedido-card:hover {
            transform: translateY(-5px);
        }
        .pedido-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .pedido-estado {
            padding: 0.4rem 0.8rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
        }
        .estado-pendiente { background-color: #facc15; color: #1f2937; }
        .estado-completada { background-color: #4ade80; color: white; }
        .estado-cancelada { background-color: #f87171; color: white; }
    </style>
</head>

<body>

<div class="pedidos-container">
    <h1 class="mb-4 text-center">Gestión de Pedidos</h1>

    <#if ordenes?? && ordenes?size gt 0>
        <#list ordenes as orden>
            <div class="pedido-card">
                <div class="pedido-header">
                    <h5>Pedido #${orden.id}</h5>
                    <span class="pedido-estado estado-${orden.estado?lower_case}">
                        ${orden.estado}
                    </span>
                </div>
                <div class="mb-2"><strong>Cliente:</strong> ${orden.usuario.nombre} ${orden.usuario.apellido}</div>
                <div class="mb-2"><strong>Fecha:</strong> ${orden.fecha?string("dd/MM/yyyy HH:mm")}</div>
                <div class="mb-2"><strong>Total:</strong> $${orden.total?string(",##0.00")}</div>

                <form action="/admin/orden/${orden.id}/estado" method="post" class="mt-3 d-flex gap-2 align-items-center">
                    <select name="estado" class="form-select w-auto">
                        <option value="PENDIENTE" <#if orden.estado == 'PENDIENTE'>selected</#if>>Pendiente</option>
                        <option value="COMPLETADA" <#if orden.estado == 'COMPLETADA'>selected</#if>>Completada</option>
                        <option value="CANCELADA" <#if orden.estado == 'CANCELADA'>selected</#if>>Cancelada</option>
                    </select>
                    <button type="submit" class="btn btn-primary btn-sm">
                        Actualizar Estado
                    </button>
                    <a href="/orden/${orden.id}" class="btn btn-outline-primary btn-sm">
                        <i class="fas fa-eye"></i> Ver Detalle
                    </a>
                </form>
            </div>
        </#list>
    <#else>
        <div class="alert alert-info text-center">
            No hay pedidos registrados aún.
        </div>
    </#if>
</div>

<!-- FontAwesome para íconos -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>
