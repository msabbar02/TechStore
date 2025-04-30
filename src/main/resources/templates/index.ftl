<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechStore - Tu tienda de tecnología</title>

    <!-- Iconos y fuentes -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #ffffff;
            --secondary: #10b981;
            --background: #2d9bf4;
            --text-dark: #1e293b;
            --text-gray: #64748b;
            --white: #ffffff;
            --shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        * {
            margin: 0; padding: 0; box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background);
            color: var(--text-dark);
            line-height: 1.6;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        img {
            max-width: 100%;
            display: block;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Navbar */
        .navbar {
            background: var(--white);
            padding: 20px 0;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
        }

        .menu {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .btn-outline {
            border: 2px solid var(--primary);
            color: var(--primary);
            background: transparent;
        }

        .btn-outline:hover {
            background: var(--primary);
            color: var(--white);
        }

        /* Hero */
        .hero {
            background: url('https://images.unsplash.com/photo-1600267165783-1de93390edfc?crop=entropy&cs=tinysrgb&fit=crop&w=1400&q=80') center/cover no-repeat;
            padding: 100px 20px;
            color: var(--white);
            text-align: center;
        }

        .hero h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .hero p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            color: #f1f5f9;
        }

        .hero-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        /* Features */
        .features {
            background: var(--background);
            padding: 60px 20px;
        }

        .features h2 {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 50px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 30px;
        }

        .feature-card {
            background: var(--white);
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: var(--shadow);
            transition: transform 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 3rem;
            color: var(--secondary);
            margin-bottom: 15px;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .feature-description {
            font-size: 1rem;
            color: var(--text-gray);
        }

        /* Footer */
        .footer {
            background: var(--text-dark);
            color: var(--white);
            padding: 40px 20px;
            text-align: center;
            margin-top: 60px;
        }

        .footer-text {
            opacity: 0.7;
        }
    </style>
</head>

<body>

<!-- Navbar -->
<header class="navbar">
    <div class="container">
        <a href="/" class="logo">TechStore</a>
        <nav class="menu">
            <a href="/login" class="btn btn-outline">Iniciar Sesión</a>
            <a href="/registro" class="btn btn-primary">Crear Cuenta</a>
        </nav>
    </div>
</header>

<!-- Hero Section -->
    <section class="hero" style="background: linear-gradient(to right, #2563eb, #1d4ed8); padding: 80px 20px; color: white; overflow: hidden; position: relative;">
        <div class="container" style="text-align: center;">
            <h1 style="font-size: 3rem; font-weight: 700; margin-bottom: 20px;">
                Tecnología premium al alcance de un clic
            </h1>
            <p style="font-size: 1.2rem; margin-bottom: 50px; color: #e0f2fe;">
                Tablets, PCs, smartphones y auriculares de última generación. Solo en TechStore.
            </p>
        </div>

        <!-- Carrusel -->
        <div style="position: relative; width: 100%; overflow: hidden; margin-top: 40px;">
            <div class="carrusel-track" style="display: flex; width: calc(300px * 10); animation: scroll 30s linear infinite;">
                <!-- Imágenes específicas -->
                <img src="/img/img1.jpg" alt="Smartphone">
                <img src="/img/img2.jpg" alt="Smartphone">
                <img src="/img/img3.jpg" alt="ordenadror">
                <img src="/img/img4.jpg" alt="ordenadror">
            </div>
        </div>

        <style>
            @keyframes scroll {
                0% { transform: translateX(0); }
                100% { transform: translateX(-50%); }
            }
        </style>
    </section>





    <!-- Features Section -->
<section class="features">
    <div class="container">
        <h2>¿Qué ofrece TechStore?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🛒</div>
                <h3 class="feature-title">Compra Inteligente</h3>
                <p class="feature-description">
                    Accede a una plataforma intuitiva donde podrás buscar, comparar y adquirir los mejores productos tecnológicos en pocos clics.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">👤</div>
                <h3 class="feature-title">Gestión de Perfil</h3>
                <p class="feature-description">
                    Crea tu cuenta personal, actualiza tus datos, gestiona tus pedidos y visualiza tu historial de compras fácilmente.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📦</div>
                <h3 class="feature-title">Seguimiento de Pedidos</h3>
                <p class="feature-description">
                    Consulta el estado de tus órdenes en tiempo real: preparación, envío y entrega directa a tu hogar.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3 class="feature-title">Seguridad y Confianza</h3>
                <p class="feature-description">
                    Tus datos personales y pagos están protegidos con los mejores estándares de seguridad digital.
                </p>
            </div>
        </div>
    </div>
</section>


<!-- Footer -->
<!-- Footer actualizado -->
<footer class="footer">
    <div class="container">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 30px; margin-bottom: 40px;">

            <!-- Carta Developer 1 -->
            <div class="feature-card" style="background-color: #1e293b; color: white;">
                <div class="feature-icon">💻</div>
                <h3 class="feature-title">¿Eres Developer?</h3>
                <p class="feature-description">
                    TechStore está construido con tecnologías modernas como Java, MySQL, Hibernate y Freemarker.
                    Si amas el código limpio y las buenas prácticas, ¡te invitamos a colaborar o inspirarte en nuestro proyecto!
                </p>
            </div>

            <!-- Carta Developer 2 -->
            <div class="feature-card" style="background-color: #1e293b; color: white;">
                <div class="feature-icon">🚀</div>
                <h3 class="feature-title">¡Contribuye!</h3>
                <p class="feature-description">
                    ¿Tienes ideas para mejorar TechStore? Estamos abiertos a nuevas funcionalidades, optimizaciones y mejoras UX/UI.
                    ¡Súmate y haz crecer esta comunidad tecnológica!
                </p>
            </div>

        </div>

        <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; margin-bottom: 20px;">
            <a href="/about" class="btn btn-outline">Sobre Nosotros</a>
            <a href="/soporte" class="btn btn-outline">Soporte</a>
            <a href="/terminos" class="btn btn-outline">Términos y Condiciones</a>
            <a href="/privacidad" class="btn btn-outline">Política de Privacidad</a>
        </div>

        <p class="footer-text">© ${.now?string('yyyy')} TechStore. Todos los derechos reservados.</p>
    </div>
</footer>


</body>
</html>
