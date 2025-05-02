<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Carrito de Compras - TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap, FontAwesome, SweetAlert2 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.5/dist/sweetalert2.min.css" rel="stylesheet">
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

        h1 {
            text-align: center;
            margin: 2rem 0;
            font-weight: 700;
        }

        table {
            background: var(--white);
            width: 100%;
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        th, td {
            padding: 1rem;
            text-align: center;
            border-bottom: 1px solid #e2e8f0;
        }

        th {
            background-color: #f1f5f9;
        }

        .producto-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }

        .btn {
            font-weight: 600;
        }

        .btn-cantidad {
            background: var(--primary);
            color: white;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            border: none;
        }

        .btn-cantidad:hover {
            background: #1e40af;
        }

        .btn-eliminar {
            background: #dc2626;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
        }

        .btn-eliminar:hover {
            background: #b91c1c;
        }

        .formulario-compra {
            background: var(--white);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
        }

        .formulario-compra input {
            width: 100%;
            margin-bottom: 1rem;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
        }

        .btn-finalizar {
            background: var(--success);
            color: var(--white);
            width: 100%;
            padding: 0.75rem;
            font-weight: 600;
            border: none;
            border-radius: 8px;
        }

        .btn-finalizar:hover {
            background: #047857;
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

<!-- Carrito -->
<h1>Mi Carrito</h1>

<div class="container">
    <#if items?? && items?size gt 0>
        <!-- Tabla de productos -->
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>Imagen</th>
                    <th>Producto</th>
                    <th>Precio</th>
                    <th>Cantidad</th>
                    <th>Subtotal</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <#list items as item>
                    <tr>
                        <td><img src="${item.producto.imagenUrl!'/img/default-product.jpg'}" alt="${item.producto.nombre}" class="producto-img"></td>
                        <td>${item.producto.nombre}</td>
                        <td>$${item.producto.precio?string(",##0.00")}</td>
                        <td>
                            <div class="d-flex justify-content-center align-items-center gap-2">
                                <form action="/carrito/${item.producto.id}/decrementar" method="post" class="d-inline">
                                    <button type="submit" class="btn btn-cantidad">-</button>
                                </form>
                                <span>${item.cantidad}</span>
                                <form action="/carrito/${item.producto.id}/incrementar" method="post" class="d-inline">
                                    <button type="submit" class="btn btn-cantidad">+</button>
                                </form>
                            </div>
                        </td>
                        <td>$${(item.producto.precio * item.cantidad)?string(",##0.00")}</td>
                        <td>
                            <form action="/carrito/${item.producto.id}/eliminar" method="post" class="d-inline">
                                <button type="submit" class="btn btn-eliminar">
                                    <i class="fas fa-trash"></i> Eliminar
                                </button>
                            </form>
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>

        <!-- Total y formulario de compra -->
        <div class="text-end mb-4">
            <h4>Total: $${total?string(",##0.00")}</h4>
        </div>

        <div class="formulario-compra">
            <h4>Datos de Envío y Pago</h4>
            <form action="/carrito/finalizar" method="post">
                <div class="row">
                    <div class="col-md-6">
                        <input type="text" name="calle" placeholder="Calle y número" required>
                        <input type="text" name="ciudad" placeholder="Ciudad" required>
                        <input type="text" name="codigoPostal" placeholder="Código Postal" required>
                        <input type="text" name="pais" placeholder="País" required>
                    </div>
                    <div class="col-md-6">
                        <input type="text" name="tarjetaNumero" placeholder="Número de tarjeta" required>
                        <input type="text" name="tarjetaNombre" placeholder="Nombre en la tarjeta" required>
                        <input type="text" name="tarjetaExpiracion" placeholder="MM/AA" pattern="\\d{2}/\\d{2}" required>
                        <input type="text" name="tarjetaCVC" placeholder="CVC" pattern="\\d{3,4}" required>
                    </div>
                </div>
                <button type="submit" class="btn-finalizar mt-3">
                    <i class="fas fa-check"></i> Finalizar Compra
                </button>
            </form>
        </div>
    <#else>
        <!-- Si no hay productos -->
        <div class="text-center">
            <h3>No tienes productos en el carrito</h3>
            <a href="/catalogo_simple" class="btn btn-primary mt-3">
                <i class="fas fa-arrow-left"></i> Ir al catálogo
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
