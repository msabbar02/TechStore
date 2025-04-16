<#include "layout.ftl">

<h2>Iniciar sesión</h2>

<#if error??>
<p class="error">${error}</p>
</#if>

<form method="post" action="/login">
    <input type="text" name="username" placeholder="Usuario" required>
    <input type="password" name="password" placeholder="Contraseña" required>
    <input type="submit" value="Entrar">
</form>

<p>¿No tienes cuenta? <a href="/register">Regístrate aquí</a></p>

</main>
</body>
</html>
