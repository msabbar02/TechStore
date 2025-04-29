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
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Estilos personalizados -->
    <link href="/css/styles.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-dark: #ffffff;
            --secondary-color: #06b6d4;
            --accent-color: #f97316;
            --dark-color: #0f172a;
            --light-color: #f8fafc;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --success-color: #10b981;
            --background-color: #f9fafb;
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
            background-color: var(--background-color);
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: var(--text-color);
            line-height: 1.6;
        }

        main {
            flex: 1;
            padding: 1.5rem 0;
        }

        /* Navbar modernizada */
        .navbar {
            background-color: var(--card-bg);
            box-shadow: var(--shadow-md);
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: transform 0.3s ease;
        }

        .navbar-brand:hover {
            transform: scale(1.05);
        }

        .navbar-brand i {
            font-size: 1.75rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-link {
            color: var(--dark-color);
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link:hover {
            color: var(--primary-color);
            background-color: rgba(79, 70, 229, 0.05);
        }

        .nav-link.active {
            color: var(--primary-color);
            font-weight: 600;
        }

        .nav-link.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 20px;
            height: 3px;
            background-color: var(--primary-color);
            border-radius: 2px;
        }

        .dropdown-menu {
            border: none;
            box-shadow: var(--shadow-lg);
            border-radius: 0.75rem;
            padding: 0.5rem;
            margin-top: 0.5rem;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .dropdown-item {
            padding: 0.75rem 1rem;
            font-weight: 500;
            border-radius: 0.5rem;
            transition: all 0.2s ease;
        }

        .dropdown-item:hover {
            background-color: rgba(79, 70, 229, 0.05);
            color: var(--primary-color);
            transform: translateX(5px);
        }

        .cart-icon-container {
            position: relative;
            margin-right: 1rem;
            transition: transform 0.3s ease;
        }

        .cart-icon-container:hover {
            transform: scale(1.1);
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
            box-shadow: 0 2px 4px rgba(239, 68, 68, 0.3);
        }

        /* Footer renovado */
        footer {
            background-color: var(--card-bg);
            padding: 3rem 0 2rem;
            border-top: 1px solid var(--border-color);
            margin-top: auto;
            box-shadow: 0 -4px 6px -1px rgba(0,0,0,0.05);
        }

        footer h5 {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1.25rem;
            position: relative;
            display: inline-block;
        }

        footer h5::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 30px;
            height: 2px;
            background-color: var(--primary-color);
        }

        footer ul li {
            margin-bottom: 0.75rem;
        }

        footer ul li a {
            color: var(--text-light);
            transition: all 0.3s ease;
            text-decoration: none;
        }

        footer ul li a:hover {
            color: var(--primary-color);
            transform: translateX(5px);
            display: inline-block;
        }

        footer address p {
            color: var(--text-light);
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
        }

        footer address p i {
            color: var(--primary-color);
            margin-right: 0.75rem;
            width: 16px;
        }

        .social-icons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .social-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: rgba(79, 70, 229, 0.1);
            color: var(--primary-color);
            transition: all 0.3s ease;
        }

        .social-icon:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-3px);
        }

        /* Estilos adicionales para el responsive */
        @media (max-width: 768px) {
            .navbar {
                padding: 0.5rem 1rem;
            }

            .navbar-brand {
                font-size: 1.25rem;
            }

            .nav-link {
                padding: 0.5rem 0.75rem;
                font-size: 0.95rem;
            }

            footer {
                padding: 2rem 0 1.5rem;
                text-align: center;
            }

            footer h5::after {
                left: 50%;
                transform: translateX(-50%);
            }

            .social-icons {
                justify-content: center;
            }
        }
    </style>
</head>

<body>
<#if showNavbar>
    <header>
        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand" href="/">
                    <i class="fas fa-laptop"></i> TechStore
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
                                <a class="nav-link cart-icon-container" href="/carrito" title="Carrito de compras">
                                    <i class="fas fa-shopping-cart"></i>
                                    <span id="cart-counter"></span>
                                </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user-circle me-1"></i> ${usuario.nombre}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="/perfil"><i class="fas fa-id-card me-2"></i> Mi Perfil</a></li>
                                    <li><a class="dropdown-item" href="/ordenes"><i class="fas fa-box me-2"></i> Mis Pedidos</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <form action="/logout" method="post" class="dropdown-item p-0">
                                            <button type="submit" class="btn btn-link dropdown-item text-danger">
                                                <i class="fas fa-sign-out-alt me-2"></i> Cerrar Sesión
                                            </button>
                                        </form>
                                    </li>
                                </ul>
                            </li>
                        <#else>
                            <li class="nav-item me-2">
                                <a class="nav-link" href="/login"><i class="fas fa-sign-in-alt me-1"></i> Iniciar Sesión</a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-primary btn-sm rounded-pill px-3 py-2" href="/registro">
                                    <i class="fas fa-user-plus me-1"></i> Registrarse
                                </a>
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
                <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                    <h5>TechStore</h5>
                    <p>Tu tienda de tecnología de confianza con los mejores productos al mejor precio.</p>
                    <div class="social-icons">
                        <a href="#" class="social-icon" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon" title="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon" title="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                    <h5>Enlaces</h5>
                    <ul class="list-unstyled">
                        <li><a href="/"><i class="fas fa-home me-2"></i>Inicio</a></li>
                        <li><a href="/catalogo_simple"><i class="fas fa-laptop me-2"></i>Productos</a></li>
                        <li><a href="/contacto"><i class="fas fa-envelope me-2"></i>Contacto</a></li>
                        <li><a href="/nosotros"><i class="fas fa-users me-2"></i>Nosotros</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                    <h5>Ayuda</h5>
                    <ul class="list-unstyled">
                        <li><a href="/preguntas-frecuentes"><i class="fas fa-question-circle me-2"></i>FAQ</a></li>
                        <li><a href="/envios"><i class="fas fa-truck me-2"></i>Envíos</a></li>
                        <li><a href="/devoluciones"><i class="fas fa-undo me-2"></i>Devoluciones</a></li>
                        <li><a href="/terminos"><i class="fas fa-file-contract me-2"></i>Términos</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h5>Contacto</h5>
                    <address>
                        <p><i class="fas fa-map-marker-alt"></i> Calle Principal 123</p>
                        <p><i class="fas fa-phone"></i> +1234567890</p>
                        <p><i class="fas fa-envelope"></i> info@techstore.com</p>
                        <p><i class="fas fa-clock"></i> Lun-Vie: 9:00 - 18:00</p>
                    </address>
                </div>
            </div>
            <div class="row mt-4 pt-4 border-top">
                <div class="col-12 text-center">
                    <p class="mb-0">&copy; ${.now?string('yyyy')} TechStore. Todos los derechos reservados.</p>
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
            
            // Activar navegación actual
            $(".nav-link").each(function() {
                if (window.location.pathname === $(this).attr("href")) {
                    $(this).addClass("active");
                }
            });
        });
    </script>
</body>

</html>
</#macro>
