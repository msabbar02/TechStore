<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Pedidos - TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap, FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --success: #059669;
            --background: #f8fafc;
            --white: #ffffff;
            --text: #1e293b;
            --shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        body {
            background: var(--background);
            font-family: 'Poppins', sans-serif;
            color: var(--text);
        }

        .navbar {
            background: var(--white);
            box-shadow: var(--shadow);
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
        }

        .nav-link {
            font-weight: 600;
            color: var(--text);
        }

        .nav-link:hover {
            color: var(--primary);
        }

        .cart-icon-container {
            position: relative;
            margin-right: 1.5rem;
        }

        #cart-counter {
            position: absolute;
            top: -5px;
            right: -8px;
            background-color: red;
            color: white;
            font-size: 0.75rem;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: none;
            justify-content: center;
            align-items: center;
        }

        .profile-img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid var(--primary);
        }

        h1 {
            text-align: center;
            margin: 2rem 0;
            font-weight: 700;
        }

        .pedido-card {
            background: var(--white);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .pedido-info {
            margin-bottom: 1rem;
        }

        .progress {
            height: 8px;
            border-radius: 5px;
            background: #e5e7eb;
            overflow: hidden;
            margin-top: 1rem;
        }

        .progress-bar {
            background: var(--primary);
            transition: width 0.5s ease;
        }

        .badge {
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
        }

        .badge-preparando { background-color: #facc15; color: #78350f; }
        .badge-camino { background-color: #38bdf8; color: #0c4a6e; }
        .badge-entregado { background-color: #4ade80; color: #065f46; }
    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/"><i class="fas fa-laptop"></i> TechStore</a>

        <div class="d-flex align-items-center ms-auto">
            <a class="nav-link cart-icon-container" href="/carrito" title="Carrito">
                <i class="fas fa-shopping-cart fa-lg"></i>
                <span id="cart-counter"></span>
            </a>

            <a class="nav-link" href="/ordenes">
                <i class="fas fa-box"></i> Mis Pedidos
            </a>

            <div class="nav-item dropdown">
                <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                    <img src="${usuario.fotoPerfil!'/img/default-profile.jpg'}" alt="Perfil" class="profile-img">
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="/perfil"><i class="fas fa-id-card"></i> Perfil</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <form action="/logout" method="post" class="dropdown-item p-0">
                            <button type="submit" class="btn btn-link dropdown-item text-danger">
                                <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                            </button>
                        </form>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<!-- Pedidos -->
<h1>Mis Pedidos</h1>

<div class="container">
    <#if pedidos?? && pedidos?size gt 0>
        <#list pedidos as pedido>
            <div class="pedido-card">
                <div class="pedido-info">
                    <h5><i class="fas fa-receipt"></i> Pedido #${pedido.id}</h5>
                    <p><strong>Productos:</strong> ${pedido.totalProductos} </p>
                    <p><strong>Total Pagado:</strong> $${pedido.totalPagado?string(",##0.00")}</p>
                    <p><strong>Enviado a:</strong> ${pedido.usuario.nombre} - ${pedido.usuario.direccion}</p>
                    <p>
                        <strong>Estado:</strong>
                        <#if pedido.estado == "Preparando">
                            <span class="badge badge-preparando">Preparando</span>
                        <#elseif pedido.estado == "En camino">
                            <span class="badge badge-camino">En Camino</span>
                        <#elseif pedido.estado == "Entregado">
                            <span class="badge badge-entregado">Entregado</span>
                        <#else>
                            <span class="badge bg-secondary">${pedido.estado}</span>
                        </#if>
                    </p>
                </div>

                <div class="progress">
                    <div class="progress-bar" role="progressbar"
                         style="width:
                                 <#if pedido.estado == "Preparando">33%
                                 <#elseif pedido.estado == "En camino">66%
                                 <#elseif pedido.estado == "Entregado">100%
                                 <#else>0%
                         </#if>;">
                    </div>
                </div>
            </div>
        </#list>
    <#else>
        <div class="text-center">
            <h3>No tienes pedidos todavía.</h3>
            <a href="/catalogo_simple" class="btn btn-primary mt-3">
                <i class="fas fa-shopping-bag"></i> Ir al catálogo
            </a>
        </div>
    </#if>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function actualizarContadorCarrito() {
        fetch('/api/carrito/contador')
            .then(response => response.json())
            .then(data => {
                const contador = document.getElementById('cart-counter');
                if (contador) {
                    if (data.cantidad > 0) {
                        contador.textContent = data.cantidad;
                        contador.style.display = 'flex';
                    } else {
                        contador.style.display = 'none';
                    }
                }
            });
    }
    document.addEventListener('DOMContentLoaded', actualizarContadorCarrito);
</script>

</body>
</html>
