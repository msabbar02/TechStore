<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap, FontAwesome y Google Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #2563eb;
            --background: #f8fafc;
            --glass-bg: rgba(255, 255, 255, 0.8);
            --glass-border: rgba(255, 255, 255, 0.3);
            --shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            --text-color: #1e293b;
        }

        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: var(--background);
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            width: 250px;
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-right: 1px solid var(--glass-border);
            height: 100vh;
            padding: 2rem 1rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .sidebar.collapsed {
            width: 80px;
            align-items: center;
        }

        .profile-img {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary);
            margin-bottom: 2rem;
            transition: all 0.3s;
        }

        .menu-toggle {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            background: none;
            border: none;
            color: var(--primary);
            cursor: pointer;
        }

        .menu {
            width: 100%;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem;
            text-decoration: none;
            color: var(--text-color);
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .menu a:hover, .menu a.active {
            background: var(--primary);
            color: white;
        }

        .sidebar.collapsed .menu a span {
            display: none;
        }

        /* Botón cerrar sesión */
        .logout-btn {
            width: 100%;
            margin-top: 2rem;
        }

        .logout-btn button {
            width: 100%;
            background-color: #ef4444;
            border: none;
            color: white;
            padding: 0.75rem;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.3s;
        }

        .logout-btn button:hover {
            background-color: #dc2626;
        }

        /* Main */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            flex-grow: 1;
            transition: all 0.3s;
        }

        .sidebar.collapsed ~ .main-content {
            margin-left: 80px;
        }

        /* Sections */
        .section {
            display: none;
        }

        .section.active {
            display: block;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                left: -250px;
            }

            .sidebar.show {
                left: 0;
            }

            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <img src="${usuario.fotoPerfil!'/img/default-avatar.png'}" alt="Perfil" class="profile-img">
    <button class="menu-toggle" id="menuToggle"><i class="fas fa-bars"></i></button>

    <nav class="menu">
        <a href="#" id="linkProductos" class="active"><i class="fas fa-box"></i><span>Productos</span></a>
        <a href="#" id="linkPedidos"><i class="fas fa-shopping-cart"></i><span>Pedidos</span></a>
        <a href="#" id="linkPerfil"><i class="fas fa-user"></i><span>Mi Perfil</span></a>
    </nav>

    <div class="logout-btn">
        <form action="/logout" method="post">
            <button type="submit"><i class="fas fa-sign-out-alt"></i> <span>Cerrar Sesión</span></button>
        </form>
    </div>
</div>

<!-- Main -->
<div class="main-content" id="mainContent">

    <!-- Productos -->
    <div id="productosSection" class="section active">
        <h1 class="mb-4">Gestión de Productos</h1>
        <div class="row g-4">
            <#list productos as producto>
                <div class="col-md-6 col-lg-4">
                    <div class="card shadow-sm h-100">
                        <img src="${producto.imagenUrl!'/img/default-product.jpg'}" class="card-img-top" alt="${producto.nombre}">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">${producto.nombre}</h5>
                            <p class="card-text text-muted">${producto.descripcion}</p>
                            <p class="h5 text-primary mb-3">$${producto.precio?string(",##0.00")}</p>
                            <div class="mt-auto d-flex gap-2">
                                <a href="/productos/${producto.id}/editar" class="btn btn-outline-primary w-50">
                                    <i class="fas fa-edit"></i> Editar
                                </a>
                                <form action="/productos/${producto.id}/eliminar" method="post" class="w-50">
                                    <button type="submit" class="btn btn-outline-danger w-100">
                                        <i class="fas fa-trash"></i> Eliminar
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </#list>
        </div>
    </div>

    <!-- Pedidos -->
    <div id="pedidosSection" class="section">
        <h1>Pedidos</h1>
        <!-- Aquí tu contenido de pedidos -->
    </div>

    <!-- Perfil -->
    <div id="perfilSection" class="section">
        <h1 class="mb-4">Mi Perfil</h1>
        <form action="/perfil/actualizar" method="post" enctype="multipart/form-data" class="card shadow-sm p-4">
            <div class="text-center mb-4">
                <img src="${usuario.fotoPerfil!'/img/default-avatar.png'}" class="rounded-circle" width="100" height="100" alt="Foto Perfil">
            </div>
            <div class="mb-3">
                <label class="form-label">Nombre</label>
                <input type="text" name="nombre" class="form-control" value="${usuario.nombre}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Apellido</label>
                <input type="text" name="apellido" class="form-control" value="${usuario.apellido}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Dirección</label>
                <input type="text" name="direccion" class="form-control" value="${usuario.direccion}">
            </div>
            <div class="mb-3">
                <label class="form-label">Foto de Perfil</label>
                <input type="file" name="fotoPerfil" class="form-control">
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary w-50">
                    <i class="fas fa-save"></i> Guardar Cambios
                </button>
                <a href="/" class="btn btn-outline-secondary w-50">
                    <i class="fas fa-arrow-left"></i> Volver
                </a>
            </div>
        </form>
    </div>

</div>

<!-- Scripts -->
<script>
    const sidebar = document.getElementById('sidebar');
    const menuToggle = document.getElementById('menuToggle');
    const links = document.querySelectorAll('.menu a');
    const sections = document.querySelectorAll('.section');

    menuToggle.addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
    });

    links.forEach(link => {
        link.addEventListener('click', e => {
            e.preventDefault();
            links.forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            const id = link.id.replace('link', '').toLowerCase() + 'Section';
            sections.forEach(section => section.classList.remove('active'));
            document.getElementById(id).classList.add('active');
        });
    });
</script>

</body>
</html>
