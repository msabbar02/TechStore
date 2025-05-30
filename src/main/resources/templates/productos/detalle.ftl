<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle de Producto - TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap, FontAwesome y SweetAlert2 -->
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
            margin-left: 1.5rem;
        }

        .nav-link:hover {
            color: var(--primary);
        }

        .cart-icon-container {
            position: relative;
        }

        #cart-counter {
            position: absolute;
            top: -5px;
            right: -10px;
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
            margin-left: 1.5rem;
        }

        /* Detalle Producto */
        .detalle-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            padding: 2rem;
            max-width: 1200px;
            margin: auto;
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-top: 2rem;
        }

        .imagen-producto {
            overflow: hidden;
            border-radius: 12px;
            position: relative;
        }

        .imagen-producto img {
            width: 100%;
            height: 500px;
            object-fit: cover;
            transition: transform 0.5s ease;
            border-radius: 12px;
        }

        .imagen-producto:hover img {
            transform: scale(1.15);
        }

        .info-producto {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .info-producto h1 {
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .precio {
            font-size: 2rem;
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .descripcion {
            margin-bottom: 2rem;
            color: #64748b;
        }

        .btn-add {
            background: var(--success);
            color: var(--white);
            font-weight: 600;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1.2rem;
            transition: background 0.3s ease;
        }

        .btn-add:hover {
            background: #047857;
        }

        @media (max-width: 768px) {
            .detalle-container {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .imagen-producto img {
                height: auto;
            }
        }
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

<!-- Detalle Producto -->
<div class="detalle-container">
    <div class="imagen-producto">
        <img src="${producto.imagenUrl!'/img/default-product.jpg'}" alt="${producto.nombre}">
    </div>

    <div class="info-producto">
        <h1>${producto.nombre}</h1>
        <p class="precio">$${producto.precio?string(",##0.00")}</p>
        <p class="descripcion">${producto.descripcion}</p>

        <form action="/carrito/agregar" method="post">
            <input type="hidden" name="productoId" value="${producto.id}">
            <button type="submit" class="btn btn-add">
                <i class="fas fa-cart-plus"></i> Añadir al Carrito
            </button>
        </form>
    </div>
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
