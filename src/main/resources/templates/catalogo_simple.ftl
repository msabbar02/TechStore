<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo de Productos - TechStore</title>
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

        .productos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 2rem;
            padding: 0 2rem;
        }

        .producto-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.3s;
        }

        .producto-card:hover {
            transform: translateY(-5px);
        }

        .producto-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .producto-info {
            padding: 1rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .precio {
            color: var(--primary);
            font-weight: 700;
            margin: 0.5rem 0;
            font-size: 1.2rem;
        }

        .btn-add, .btn-detalle {
            width: 100%;
            margin-top: 0.5rem;
            font-weight: 600;
        }

        .btn-add {
            background: var(--success);
            color: var(--white);
        }

        .btn-add:hover {
            background: #047857;
        }

        .btn-detalle {
            background: var(--primary);
            color: var(--white);
        }

        .btn-detalle:hover {
            background: #1e40af;
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

<!-- Catálogo -->
<h1>Catálogo de Productos</h1>

<div class="productos-grid">
    <#list productos as producto>
        <div class="producto-card">
            <img src="${producto.imagenUrl!'/img/default-product.jpg'}" alt="${producto.nombre}" class="producto-img">
            <div class="producto-info">
                <div>
                    <h5>${producto.nombre}</h5>
                    <p class="precio">$${producto.precio?string(",##0.00")}</p>
                </div>
                <div class="d-grid gap-2">
                    <button class="btn btn-add" onclick="agregarAlCarrito(${producto.id})">
                        <i class="fas fa-cart-plus"></i> Añadir al Carrito
                    </button>
                    <a href="/producto/${producto.id}" class="btn btn-detalle">
                        <i class="fas fa-info-circle"></i> Ver Detalle
                    </a>
                </div>
            </div>
        </div>
    </#list>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.5/dist/sweetalert2.all.min.js"></script>

<script>
    function agregarAlCarrito(productoId) {
        fetch('/carrito/agregar', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
            body: JSON.stringify({ productoId: productoId })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: '¡Añadido!',
                        text: 'Producto agregado al carrito',
                        timer: 1500,
                        showConfirmButton: false
                    });
                    actualizarContadorCarrito();
                } else {
                    Swal.fire('Error', data.error || 'No se pudo añadir', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire('Error', 'No se pudo procesar la solicitud', 'error');
            });
    }

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
