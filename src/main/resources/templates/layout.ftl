<#macro layout title="" showNavbar=true>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title!"TechStore"}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Estilos personalizados -->
    <link href="/css/styles.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --secondary-color: #0ea5e9;
            --accent-color: #f97316;
            --dark-color: #1e293b;
            --light-color: #f8fafc;
            --danger-color: #dc2626;
            --warning-color: #f59e0b;
            --background-color: #f8fafc;
            --card-bg: #ffffff;
            --text-color: #1e293b;
            --text-light: #64748b;
            --border-color: #e2e8f0;
            --navbar-height: 70px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.12);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.1);
        }
        
        /* Reset y estilos base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #f5f5f7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: var(--text-color);
            line-height: 1.6;
        }
        
        main {
            flex: 1;
            padding: 1rem 0;
        }
        
        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            padding: 0.75rem 1rem;
        }
        
        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .navbar-brand i {
            font-size: 1.75rem;
        }
        
        .nav-link {
            color: var(--dark-color);
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: color 0.2s ease;
        }
        
        .nav-link:hover {
            color: var(--primary-color);
        }
        
        .nav-link.active {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
        }
        
        .dropdown-menu {
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            border-radius: 0.5rem;
        }
        
        .dropdown-item {
            padding: 0.5rem 1rem;
            font-weight: 500;
        }
        
        .dropdown-item:hover {
            background-color: #f5f5f7;
        }
        
        footer {
            background-color: white;
            padding: 2rem 0;
            border-top: 1px solid #e5e7eb;
            margin-top: auto;
        }
        
        .cart-icon-container {
            position: relative;
            margin-right: 1rem;
        }
        
        #cart-counter {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: var(--danger-color);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: none;
            justify-content: center;
            align-items: center;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        /* Estilos adicionales para el responsive */
        @media (max-width: 768px) {
            .navbar {
                padding: 0 1rem;
            }
            
            .navbar-links {
                gap: 0.5rem;
            }
            
            .nav-link {
                padding: 0.5rem 0.75rem;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <#if showNavbar>
    <header>
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <a class="navbar-brand" href="/">
                    <i class="fas fa-laptop text-primary"></i> TechStore
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-between" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="/">Inicio</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/catalogo_simple">Catálogo</a>
                        </li>
                        <#if usuario?? && usuario.rol == "admin">
                            <li class="nav-item">
                                <a class="nav-link" href="/dashboard">Dashboard</a>
                            </li>
                        </#if>
                    </ul>
                    <ul class="navbar-nav ms-auto">
                        <#if usuario??>
                            <li class="nav-item">
                                <a class="nav-link cart-icon-container" href="/carrito">
                                    <i class="fas fa-shopping-cart"></i>
                                    <span id="cart-counter"></span>
                                </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user-circle me-1"></i> ${usuario.nombre}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="/perfil">Mi Perfil</a></li>
                                    <li><a class="dropdown-item" href="/ordenes">Mis Pedidos</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <form action="/logout" method="post" class="dropdown-item p-0">
                                            <button type="submit" class="btn btn-link dropdown-item text-danger">
                                                <i class="fas fa-sign-out-alt me-1"></i> Cerrar Sesión
                                            </button>
                                        </form>
                                    </li>
                                </ul>
                            </li>
                        <#else>
                            <li class="nav-item">
                                <a class="nav-link" href="/login">Iniciar Sesión</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/registro">Registrarse</a>
                            </li>
                        </#if>
                    </ul>
                </div>
            </div>
        </nav>
    </header>
    </#if>

    <main>
        <#nested>
    </main>

    <#if showNavbar>
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>TechStore</h5>
                    <p>Tu tienda de tecnología de confianza</p>
                </div>
                <div class="col-md-4">
                    <h5>Enlaces</h5>
                    <ul class="list-unstyled">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/catalogo_simple">Productos</a></li>
                        <li><a href="/contacto">Contacto</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Contacto</h5>
                    <address>
                        <p><i class="fas fa-map-marker-alt me-2"></i> Calle Principal 123</p>
                        <p><i class="fas fa-phone me-2"></i> +1234567890</p>
                        <p><i class="fas fa-envelope me-2"></i> info@techstore.com</p>
                    </address>
                </div>
            </div>
            <div class="row mt-4">
                <div class="col-12 text-center">
                    <p class="mb-0">&copy; 2023 TechStore. Todos los derechos reservados.</p>
                </div>
            </div>
        </div>
    </footer>
    </#if>

    <!-- jQuery y Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Scripts para actualizar contador del carrito -->
    <script>
        $(document).ready(function() {
            // Obtener contador del carrito
            function actualizarContadorCarrito() {
                $.ajax({
                    url: '/api/carrito/contador',
                    method: 'GET',
                    success: function(data) {
                        if (data > 0) {
                            $('#cart-counter').text(data).css('display', 'flex');
                        } else {
                            $('#cart-counter').hide();
                        }
                    }
                });
            }
            
            // Actualizar contador al cargar la página
            actualizarContadorCarrito();
            
            // Actualizar cada 30 segundos
            setInterval(actualizarContadorCarrito, 30000);
        });
    </script>
</body>
</html>
</#macro>
                        <p><i class="fas fa-envelope me-2"></i> info@techstore.com</p>
                    </address>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p>&copy; 2023 TechStore. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script para actualizar contador de carrito -->
    <script>
        // Función para actualizar el contador del carrito
        function actualizarContadorCarrito() {
            fetch('/carrito/contador')
                .then(response => response.json())
                .then(data => {
                    const contador = document.getElementById('cart-counter');
                    if (contador) {
                        if (data.cantidad > 0) {
                            contador.style.display = 'flex';
                            contador.textContent = data.cantidad;
                        } else {
                            contador.style.display = 'none';
                        }
                    }
                })
                .catch(error => console.error('Error al actualizar contador:', error));
        }
        
        // Actualizar contador al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            // Solo ejecutar si hay un usuario logueado (verificar si existe el contador)
            if (document.getElementById('cart-counter')) {
                actualizarContadorCarrito();
            }
        });
    </script>
</body>
</html>
</#macro>
        .nav-link {
            color: var(--text-color);
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link:hover {
            background-color: var(--background-color);
            color: var(--primary-color);
        }

        /* Profile dropdown */
        .profile-dropdown {
            position: relative;
        }

        .profile-img {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            cursor: pointer;
            border: 2px solid var(--primary-color);
            transition: transform 0.3s ease;
            object-fit: cover;
        }

        .profile-img:hover {
            transform: scale(1.05);
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: 120%;
            background-color: var(--card-bg);
            min-width: 250px;
            border-radius: 12px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .profile-dropdown .dropdown-content {
            display: none;
        }
        
        .profile-dropdown:hover .dropdown-content,
        .profile-dropdown:focus .dropdown-content,
        .profile-dropdown:focus-within .dropdown-content {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.875rem 1.25rem;
            color: var(--text-color);
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .dropdown-item i {
            font-size: 1.1rem;
            color: var(--text-light);
        }

        .dropdown-item:hover {
            background-color: var(--background-color);
            color: var(--primary-color);
        }

        /* Main content */
        .main-content {
            margin-top: var(--navbar-height);
            padding: 2rem;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Animaciones */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <#if showNavbar>
        <nav class="navbar">
            <#if usuario?? && usuario.rol == "admin">
                <a href="/dashboard" class="navbar-brand">
                    <i class="fas fa-laptop"></i> TechStore Admin
                </a>
            <#else>
                <a href="/index" class="navbar-brand">
                    <i class="fas fa-laptop"></i> TechStore
                </a>
            </#if>
            
            <div class="navbar-links">
                <#if usuario??>
                    <#if usuario.rol == "admin">
                        <a href="/dashboard" class="nav-link">
                            <i class="fas fa-chart-line"></i> Dashboard
                        </a>
                        <a href="/productos/nuevo" class="nav-link">
                            <i class="fas fa-plus"></i> Nuevo Producto
                        </a>
                    <#else>
                        <a href="/carrito" class="nav-link cart-icon" title="Ver mi carrito de compras" style="position: relative; padding-right: 15px;" id="carrito-link">
                            <i class="fas fa-shopping-cart"></i> Carrito
                            <span id="cart-counter" class="cart-counter" style="position: absolute; top: -8px; right: -8px; background-color: #f97316; color: white; border-radius: 50%; width: 22px; height: 22px; font-size: 12px; display: none; align-items: center; justify-content: center; font-weight: bold; box-shadow: 0 2px 4px rgba(0,0,0,0.2); animation: pulse 1.5s infinite;">
                            </span>
                            <style>
                                @keyframes pulse {
                                    0% { transform: scale(1); }
                                    50% { transform: scale(1.1); }
                                    100% { transform: scale(1); }
                                }
                            </style>
                        </a>
                        <a href="/ordenes" class="nav-link" title="Ver mis pedidos">
                            <i class="fas fa-box"></i> Mis Pedidos
                        </a>
                    </#if>
                    
                    <div class="profile-dropdown" tabindex="0">
                        <img src="${usuario.fotoPerfil!'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp'}" 
                             alt="Profile" 
                             class="profile-img">
                        <div class="dropdown-content" onclick="event.stopPropagation();">
                            <div class="dropdown-item" style="border-bottom: 1px solid #eee; display: block;">
                                <div style="display: flex; align-items: center;">
                                    <i class="fas fa-user-circle" style="margin-right: 10px;"></i>
                                    <div>
                                        <strong>${usuario.username}</strong><br>
                                        <small>${usuario.rol}</small>
                                    </div>
                                </div>
                            </div>
                            <a href="/perfil" class="dropdown-item">
                                <i class="fas fa-user"></i> Mi Perfil
                            </a>
                            <#if usuario.rol != "admin">
                            <a href="/ordenes" class="dropdown-item">
                                <i class="fas fa-box"></i> Mis Pedidos
                            </a>
                            </#if>
                            <form action="/logout" method="post" style="display: inline-block; width: 100%;">
                                <button type="submit" class="dropdown-item" style="width: 100%; border: none; background: none; cursor: pointer; color: #dc2626; text-align: left; display: flex; align-items: center;">
                                    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                                </button>
                            </form>
                        </div>
                    </div>
                <#else>
                    <a href="/login" class="nav-link">Iniciar Sesión</a>
                    <a href="/register" class="nav-link">Registrarse</a>
                </#if>
            </div>
        </nav>
    </#if>
<#macro layout title="" showNavbar=true>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    
    <!-- Precargar recursos críticos -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">
    
    <!-- CSS crítico primero (inline) -->
    <style>
        body {background-color:#f5f5f7;font-family:'Segoe UI',sans-serif;min-height:100vh;display:flex;flex-direction:column;margin:0}
        .navbar {background-color:#fff;box-shadow:0 2px 4px rgba(0,0,0,.05);padding:.75rem 1rem}
        main {flex:1;padding:1rem 0}
        .loading-overlay {position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(255,255,255,.7);display:flex;justify-content:center;align-items:center;z-index:9999;visibility:hidden;opacity:0;transition:opacity .3s,visibility .3s}
        .loading-overlay.active {visibility:visible;opacity:1}
        .loader {border:5px solid #f3f3f3;border-top:5px solid #2563eb;border-radius:50%;width:40px;height:40px;animation:spin 1s linear infinite}
        @keyframes spin{0%{transform:rotate(0)}100%{transform:rotate(360deg)}}
    </style>
    
    <!-- Bootstrap CSS cargado con prioridad -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    
    <!-- CSS no crítico después -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" defer>
    
    <!-- Estilos adicionales de la aplicación -->
    <style>
        /* Estilos de navbar */
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: #2563eb;
        }
        .cart-icon {
            position: relative;
            margin-right: 1rem;
        }
        .cart-counter {
            position: absolute;
            top: -10px;
            right: -10px;
            background-color: #e11d48;
            color: white;
            font-size: 0.7rem;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .dropdown-menu {
            min-width: 280px;
            padding: 1rem;
        }
        .user-info {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 0.75rem;
        }
        
        /* Footer */
        .footer {
            background-color: #1e293b;
            color: #e2e8f0;
            padding: 2rem 0;
            margin-top: 2rem;
        }
        .footer-links {
            list-style: none;
            padding: 0;
        }
        .footer-links li {
            margin-bottom: 0.5rem;
        }
        .footer-links a {
            color: #e2e8f0;
            text-decoration: none;
        }
        .footer-links a:hover {
            color: #fff;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Overlay de carga para operaciones asíncronas -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loader"></div>
    </div>

    <#if showNavbar>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="/">TechStore</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/productos">Productos</a>
                    </li>
                    <#if usuario?? && usuario.rol == "admin">
                    <li class="nav-item">
                        <a class="nav-link" href="/dashboard">Dashboard</a>
                    </li>
                    </#if>
                </ul>
                
                <div class="d-flex align-items-center">
                    <a href="/carrito" class="cart-icon me-3" id="carritoLink">
                        <i class="fas fa-shopping-cart fs-5"></i>
                        <span class="cart-counter" id="cartCounter">0</span>
                    </a>
                    
                    <#if usuario??>
                    <div class="dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <img src="${usuario.fotoPerfil!'/img/default-avatar.png'}" alt="${usuario.nombre}" class="avatar">
                        </a>
                        <div class="dropdown-menu dropdown-menu-end">
                            <div class="user-info">
                                <img src="${usuario.fotoPerfil!'/img/default-avatar.png'}" alt="${usuario.nombre}" class="avatar">
                                <div>
                                    <div class="fw-bold">${usuario.nombre} ${usuario.apellido!''}</div>
                                    <div class="text-secondary">${usuario.username}</div>
                                </div>
                            </div>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/perfil">
                                <i class="fas fa-user me-2"></i> Mi Perfil
                            </a>
                            <a class="dropdown-item" href="/pedidos">
                                <i class="fas fa-box me-2"></i> Mis Pedidos
                            </a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Cerrar Sesión
                            </a>
                        </div>
                    </div>
                    <#else>
                    <a href="/login" class="btn btn-outline-primary me-2">Iniciar Sesión</a>
                    <a href="/registro" class="btn btn-primary">Registrarse</a>
                    </#if>
                </div>
            </div>
        </div>
    </nav>
    </#if>

    <main class="container py-4">
        <#nested>
    </main>

    <#if showNavbar>
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5>TechStore</h5>
                    <p>Tu tienda de tecnología de confianza, con los mejores precios y la mayor calidad.</p>
                </div>
                <div class="col-md-2 mb-4">
                    <h5>Enlaces</h5>
                    <ul class="footer-links">
                        <li><a href="/">Inicio</a></li>
                        <li><a href="/productos">Productos</a></li>
                        <li><a href="/contacto">Contacto</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4">
                    <h5>Categorías</h5>
                    <ul class="footer-links">
                        <li><a href="/productos?categoria=laptops">Laptops</a></li>
                        <li><a href="/productos?categoria=smartphones">Smartphones</a></li>
                        <li><a href="/productos?categoria=tablets">Tablets</a></li>
                        <li><a href="/productos?categoria=accesorios">Accesorios</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4">
                    <h5>Contacto</h5>
                    <address>
                        <p><i class="fas fa-map-marker-alt me-2"></i> Calle Principal 123, Ciudad</p>
                        <p><i class="fas fa-phone me-2"></i> +1 234 567 890</p>
                        <p><i class="fas fa-envelope me-2"></i> info@techstore.com</p>
                    </address>
                </div>
            </div>
            <hr class="mt-3 mb-4" style="border-color: #475569;">
            <div class="text-center">
                <p>&copy; 2023 TechStore. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>
    </#if>

    <!-- Scripts cargados al final para mejor rendimiento -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous" defer></script>
    
    <!-- Scripts de la aplicación -->
    <script>
        // Cargar contador del carrito de forma asíncrona
        document.addEventListener('DOMContentLoaded', function() {
            // Función para actualizar el contador del carrito
            function actualizarContadorCarrito() {
                fetch('/api/carrito/contador')
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Error al obtener contador');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            document.getElementById('cartCounter').textContent = data.cantidad;
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    });
            }
            
            // Ejecutar al cargar la página
            actualizarContadorCarrito();
            
            // Controlar overlay de carga
            window.showLoading = function() {
                document.getElementById('loadingOverlay').classList.add('active');
            };
            
            window.hideLoading = function() {
                document.getElementById('loadingOverlay').classList.remove('active');
            };
            
            // Mejorar experiencia en formularios de envío
            document.querySelectorAll('form[method="post"]').forEach(form => {
                form.addEventListener('submit', function() {
                    window.showLoading();
                });
            });
        });
    </script>
</body>
</html>
</#macro>
    <main class="main-content">
        <#nested>
    </main>

    <script>
        <#if mensaje??>
            alert('${mensaje}');
        </#if>
        
        // Inicializar el contador del carrito al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            // Obtener el contador del carrito
            const cartCounter = document.querySelector('.cart-counter');
            
            if (cartCounter) {
                // Hacer una solicitud para obtener la cantidad actual
                fetch('/carrito/contador', {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.cantidad > 0) {
                        cartCounter.textContent = data.cantidad;
                        cartCounter.style.display = 'flex';
                    }
                })
                .catch(error => {
                    console.error('Error al obtener la cantidad del carrito:', error);
                });
            }
            
            // Configurar el menú desplegable del perfil
            const profileDropdown = document.querySelector('.profile-dropdown');
            if (profileDropdown) {
                profileDropdown.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const dropdownContent = this.querySelector('.dropdown-content');
                    if (dropdownContent) {
                        dropdownContent.style.display = dropdownContent.style.display === 'block' ? 'none' : 'block';
                    }
                });
                
                // Cerrar el menú al hacer clic fuera
                document.addEventListener('click', function() {
                    const dropdownContent = profileDropdown.querySelector('.dropdown-content');
                    if (dropdownContent) {
                        dropdownContent.style.display = 'none';
                    }
                });
            }
        });
    </script>
</body>
</html>
</#macro>