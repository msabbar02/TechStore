<!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>${title!"TechStore"}</title>
        <link rel="stylesheet" href="/css/style.css">
    </head>
    <body>
    <header>
        <h1>🛒 TechStore</h1>
        <div class="navbar">
            <#if usuario??>
                <img src="${usuario.fotoPerfil!"https://via.placeholder.com/40"}" class="perfil-img" onclick="document.getElementById('menu').classList.toggle('visible')">
                <div id="menu" class="perfil-menu">
                    <p>${usuario.nombre} ${usuario.apellido}</p>
                    <a href="/perfil">Perfil</a>
                    <a href="/logout">Cerrar sesión</a>
                </div>
                <form method="get" action="/index" class="filtros">
                    <input type="text" name="nombre" placeholder="Buscar por nombre">
                    <input type="number" step="0.01" name="precioMin" placeholder="Precio mínimo">
                    <input type="number" step="0.01" name="precioMax" placeholder="Precio máximo">
                    <button type="submit">Filtrar</button>
                </form>
            </#if>
        </div>
    </header>
    <main>