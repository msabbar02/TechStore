<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechStore - Tu tienda de tecnología</title>
    
    <!-- CSS minimalista y rápido -->
    <style>
        /* Variables básicas */
        :root {
            --blue: #2563eb;
            --dark-blue: #1d4ed8;
            --dark: #1e293b;
            --light: #f8fafc;
            --gray: #64748b;
            --border: #e2e8f0;
            --white: #ffffff;
            --shadow: 0 2px 10px rgba(0,0,0,0.1);
            --green: #10b981;
        }
        
        /* Reset y base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            line-height: 1.5;
            color: var(--dark);
            background-color: var(--light);
        }
        
        a {
            text-decoration: none;
            color: inherit;
        }
        
        img {
            max-width: 100%;
        }
        
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }
        
        /* Navbar */
        .navbar {
            background-color: var(--dark);
            color: var(--white);
            padding: 15px 0;
        }
        
        .navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--white);
        }
        
        .menu {
            display: flex;
            gap: 20px;
            align-items: center;
        }
        
        .menu-link {
            color: rgba(255,255,255,0.8);
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .menu-link:hover {
            color: var(--white);
        }
        
        .btn {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 4px;
            font-weight: 500;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: var(--blue);
            color: var(--white);
            border: none;
        }
        
        .btn-primary:hover {
            background-color: var(--dark-blue);
        }
        
        .btn-success {
            background-color: var(--green);
            color: var(--white);
            border: none;
        }
        
        .btn-success:hover {
            opacity: 0.9;
        }
        
        .btn-outline {
            border: 1px solid var(--blue);
            color: var(--blue);
            background: transparent;
        }
        
        .btn-outline:hover {
            background-color: var(--blue);
            color: var(--white);
        }
        
        /* Landing page */
        .hero {
            padding: 80px 0;
            text-align: center;
            background-color: var(--white);
            margin-bottom: 40px;
        }
        
        .hero-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: var(--dark);
        }
        
        .hero-description {
            font-size: 1.2rem;
            color: var(--gray);
            max-width: 700px;
            margin: 0 auto 30px;
        }
        
        .hero-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }
        
        .features {
            padding: 60px 0;
            background-color: var(--light);
        }
        
        .features-title {
            text-align: center;
            margin-bottom: 40px;
            font-size: 2rem;
            font-weight: 600;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }
        
        .feature-card {
            background-color: var(--white);
            border-radius: 8px;
            padding: 30px;
            box-shadow: var(--shadow);
            text-align: center;
        }
        
        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: var(--blue);
        }
        
        .feature-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .feature-description {
            color: var(--gray);
            font-size: 0.95rem;
        }
        
        .footer {
            background-color: var(--dark);
            color: var(--white);
            padding: 40px 0;
            text-align: center;
        }
        
        .footer-text {
            opacity: 0.8;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <header class="navbar">
        <div class="container">
            <a href="/" class="logo">TechStore</a>
            <nav class="menu">
                <a href="/login" class="btn btn-outline">Iniciar Sesión</a>
                <a href="/registro" class="btn btn-primary">Registrarse</a>
            </nav>
        </div>
    </header>
    
    <main>
        <section class="hero">
            <div class="container">
                <h1 class="hero-title">Bienvenido a TechStore</h1>
                <p class="hero-description">
                    Tu tienda de tecnología favorita con los mejores productos a los mejores precios.
                    Explora nuestro catálogo y encuentra lo que necesitas.
                </p>
                <div class="hero-buttons">
                    <a href="/login" class="btn btn-primary">Iniciar Sesión</a>
                    <a href="/registro" class="btn btn-outline">Crear Cuenta</a>
                </div>
            </div>
        </section>
        
        <section class="features">
            <div class="container">
                <h2 class="features-title">¿Por qué elegir TechStore?</h2>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">🔍</div>
                        <h3 class="feature-title">Catálogo Completo</h3>
                        <p class="feature-description">
                            Amplia variedad de productos tecnológicos para todas tus necesidades.
                        </p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">🛒</div>
                        <h3 class="feature-title">Compra Fácil</h3>
                        <p class="feature-description">
                            Proceso de compra sencillo y seguro para tu comodidad.
                        </p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">⚡</div>
                        <h3 class="feature-title">Envío Rápido</h3>
                        <p class="feature-description">
                            Recibe tus productos en tiempo récord, sin largas esperas.
                        </p>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <footer class="footer">
        <div class="container">
            <p class="footer-text">© ${.now?string('yyyy')} TechStore. Todos los derechos reservados.</p>
        </div>
    </footer>
</body>
</html>