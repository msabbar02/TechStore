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

         .card {
             border-radius: 16px;
             transition: all 0.3s ease;
         }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .badge {
            font-size: 0.85rem;
            padding: 0.5rem 0.75rem;
            border-radius: 0.5rem;
        }
        .card-img-top{
            height: 200px;
            object-fit: cover;
        }


    </style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <img src="${usuario.fotoPerfil!'/img/default-avatar.png'}" alt="Perfil" class="profile-img">
    <h2 class="text-center text-primary">${usuario.nombre!''} ${usuario.apellido!''}</h2>
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
        <!-- Buscador y Categorías -->
        <div class="mb-4">
            <form class="d-flex mb-3" method="get" action="/dashboard">
                <input type="text" name="buscar" class="form-control me-2" placeholder="Buscar producto..." value="${buscar!}">
                <button type="submit" class="btn btn-outline-primary">
                    <i class="fas fa-search"></i> Buscar
                </button>
            </form>

            <div class="d-flex flex-wrap gap-2">
                <a href="/dashboard" class="btn btn-sm <#if categoria?? && categoria == 'ALL'>btn-primary<#else>btn-outline-secondary</#if>">ALL</a>
                <a href="/dashboard?categoria=PC" class="btn btn-sm <#if categoria?? && categoria == 'PC'>btn-primary<#else>btn-outline-secondary</#if>">PC</a>
                <a href="/dashboard?categoria=TABLET" class="btn btn-sm <#if categoria?? && categoria == 'TABLET'>btn-primary<#else>btn-outline-secondary</#if>">TABLET</a>
                <a href="/dashboard?categoria=SMARTPHONE" class="btn btn-sm <#if categoria?? && categoria == 'SMARTPHONE'>btn-primary<#else>btn-outline-secondary</#if>">SMARTPHONE</a>
                <!-- Agrega más categorías si quieres -->
            </div>
        </div>

        <!-- Botón Añadir Producto -->
        <div class="mb-4 d-flex justify-content-end">
            <a href="/productos/nuevo" class="btn btn-success">
                <i class="fas fa-plus"></i> Añadir Producto
            </a>
        </div>

        <div class="row g-4">
            <#list productos as producto>
                <div class="col-md-6 col-lg-4">
                    <div class="card shadow-sm h-100">
                        <img src="${producto.imagenUrl!'/img/images.png'}" class="card-img-top" alt="${producto.nombre}">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">${producto.nombre}</h5>
                            <p class="card-text text-muted">${producto.descripcion}</p>
                            <p class="h5 text-primary mb-3">$${producto.precio?string(",##0.00")}</p>
                            <p class="h5 text-primary mb-4">Existencias: ${producto.existencias}</p>

                            <div class="mt-auto d-flex gap-2">
                                <!-- Botón Editar -->
                                <a href="/productos/${producto.id}/editar" class="btn btn-outline-primary w-50">
                                    <i class="fas fa-edit"></i> Editar
                                </a>

                                <!-- Botón Eliminar -->

                                <form id="eliminarForm${producto.id}" action="/productos/${producto.id}/eliminar" method="post" class="w-50">
                                    <button type="button" class="btn btn-outline-danger w-100" onclick="eliminarProducto(${producto.id})">
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



    <!-- Pedidos Section -->
    <div id="pedidosSection" class="section">
        <h1 class="mb-4">Gestión de Pedidos</h1>

        <#attempt>
            <#if ordenes?? && ordenes?has_content>
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle">
                        <thead class="table-primary text-center">
                        <tr>
                            <th>ID</th>
                            <th>Cliente</th>
                            <th>Fecha</th>
                            <th>Total</th>
                            <th>Estado Actual</th>
                            <th>Cambiar Estado</th>
                            <th>Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list ordenes as orden>
                            <tr class="text-center">
                                <td>#${orden.id!''}</td>
                                <td>${orden.usuario.nombre!''} ${orden.usuario.apellido!''}</td>

                                <td>
                                    <#if orden.fechaFormateada??>
                                        ${orden.fechaFormateada}
                                    <#else>
                                        -
                                    </#if>
                                </td>

                                <td>$${orden.total?string(",##0.00")}</td>

                                <td>
                                    <span class="badge
                                        <#if (orden.estado!'PENDIENTE')?upper_case == 'COMPLETADA'>
                                            bg-success
                                        <#elseif (orden.estado!'PENDIENTE')?upper_case == 'CANCELADA'>
                                            bg-danger
                                        <#else>
                                            bg-warning
                                        </#if>">
                                        ${orden.estado!'PENDIENTE'}
                                    </span>
                                </td>

                                <td>
                                    <form action="/admin/orden/${orden.id}/estado" method="post" class="d-flex gap-2 justify-content-center">
                                        <select name="estado" class="form-select form-select-sm w-auto">
                                            <option value="PENDIENTE" <#if orden.estado == "PENDIENTE">selected</#if>>Pendiente</option>
                                            <option value="COMPLETADA" <#if orden.estado == "COMPLETADA">selected</#if>>Completada</option>
                                            <option value="CANCELADA" <#if orden.estado == "CANCELADA">selected</#if>>Cancelada</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-primary">
                                            <i class="fas fa-save"></i>
                                        </button>
                                    </form>
                                </td>

                                <td>
                                    <a href="/orden/${orden.id}" class="btn btn-outline-secondary btn-sm">
                                        <i class="fas fa-eye"></i> Ver
                                    </a>
                                </td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <div class="alert alert-info text-center">
                    No hay pedidos registrados aún.
                </div>
            </#if>
            <#recover>
                <div class="alert alert-danger text-center">
                    Error al cargar los pedidos. Por favor, intente más tarde.
                </div>
        </#recover>
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

    function editarProducto(id) {
        window.location.href = '/productos/' + id + '/editar';
    }
    function eliminarProducto(id) {
        if (confirm('¿Estás seguro de que deseas eliminar este producto?')) {
            document.getElementById('eliminarForm' + id).submit();
        }
    }
</script>

</body>
</html>
