<#include "layout.ftl">

<h2>🔐 Iniciar sesión</h2>

<#if error??>
<p style="color: red;">${error}</p>
</#if>

<form method="post" action="/login" class="formulario">
    <label>Nombre de usuario:
        <input type="text" name="username" required>
    </label>

    <label>Contraseña:
        <input type="password" name="password" required>
    </label>

    <button type="submit">Entrar</button>
</form>

<p>¿No tienes cuenta? <a href="/register">Regístrate aquí</a></p>

</main></body></html>
