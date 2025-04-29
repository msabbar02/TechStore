/**
 * Scripts comunes para la aplicación TechStore
 */
/**
 * Scripts comunes para la aplicación TechStore
 */

document.addEventListener('DOMContentLoaded', function() {
    // Configuración para ocultar mensajes automáticamente
    const mensajesExito = document.querySelectorAll('.fade-out');
    mensajesExito.forEach(mensaje => {
        setTimeout(() => {
            mensaje.style.display = 'none';
        }, 5000);
    });
    
    // Inicializar pestañas en el dashboard si existen
    const tabLinks = document.querySelectorAll('.tab');
    if (tabLinks.length > 0) {
        tabLinks.forEach(tab => {
            tab.addEventListener('click', function() {
                // Remover clase activa de todas las pestañas
                document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
                
                // Agregar clase activa a la pestaña seleccionada
                this.classList.add('active');
                
                // Mostrar el contenido de la pestaña
                const tabId = this.getAttribute('data-tab');
                document.getElementById(tabId).classList.add('active');
            });
        });
    }
    
    // Validación de formularios
    const formularios = document.querySelectorAll('form[data-validate="true"]');
    formularios.forEach(form => {
        form.addEventListener('submit', function(event) {
            let isValid = true;
            
            // Validar campos requeridos
            const camposRequeridos = form.querySelectorAll('[required]');
            camposRequeridos.forEach(campo => {
                if (!campo.value.trim()) {
                    isValid = false;
                    mostrarError(campo, 'Este campo es obligatorio');
                } else {
                    ocultarError(campo);
                }
            });
            
            // Validar contraseñas
            const password = form.querySelector('[name="password"]');
            const confirmPassword = form.querySelector('[name="confirmPassword"]');
            if (password && confirmPassword && password.value !== confirmPassword.value) {
                isValid = false;
                mostrarError(confirmPassword, 'Las contraseñas no coinciden');
            }
            
            if (!isValid) {
                event.preventDefault();
            }
        });
    });
    
    function mostrarError(campo, mensaje) {
        const errorSpan = document.createElement('span');
        errorSpan.className = 'error-message';
        errorSpan.textContent = mensaje;
        
        // Eliminar mensaje de error existente
        const errorExistente = campo.nextElementSibling;
        if (errorExistente && errorExistente.classList.contains('error-message')) {
            errorExistente.remove();
        }
        
        campo.parentNode.insertBefore(errorSpan, campo.nextSibling);
        campo.classList.add('error');
    }
    
    function ocultarError(campo) {
        const errorExistente = campo.nextElementSibling;
        if (errorExistente && errorExistente.classList.contains('error-message')) {
            errorExistente.remove();
        }
        campo.classList.remove('error');
    }
});
document.addEventListener('DOMContentLoaded', function() {
    // Configuración para ocultar mensajes automáticamente
    const mensajesExito = document.querySelectorAll('.fade-out');
    mensajesExito.forEach(mensaje => {
        setTimeout(() => {
            mensaje.style.display = 'none';
        }, 5000);
    });
    
    // Inicializar pestañas en el dashboard si existen
    const tabLinks = document.querySelectorAll('.tab');
    if (tabLinks.length > 0) {
        tabLinks.forEach(tab => {
            tab.addEventListener('click', function() {
                // Remover clase activa de todas las pestañas
                document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
                
                // Agregar clase activa a la pestaña seleccionada
                this.classList.add('active');
                
                // Mostrar el contenido de la pestaña
                const tabId = this.getAttribute('data-tab');
                document.getElementById(tabId).classList.add('active');
            });
        });
    }
    
    // Validación de formularios
    const formularios = document.querySelectorAll('form[data-validate="true"]');
    formularios.forEach(form => {
        form.addEventListener('submit', function(event) {
            let isValid = true;
            
            // Validar campos requeridos
            const camposRequeridos = form.querySelectorAll('[required]');
            camposRequeridos.forEach(campo => {
                if (!campo.value.trim()) {
                    isValid = false;
                    mostrarError(campo, 'Este campo es obligatorio');
                } else {
                    ocultarError(campo);
                }
            });
            
            // Validar contraseñas
            const password = form.querySelector('[name="password"]');
            const confirmPassword = form.querySelector('[name="confirmPassword"]');
            if (password && confirmPassword && password.value !== confirmPassword.value) {
                isValid = false;
                mostrarError(confirmPassword, 'Las contraseñas no coinciden');
            }
            
            if (!isValid) {
                event.preventDefault();
            }
        });
    });
    
    function mostrarError(campo, mensaje) {
        const errorSpan = document.createElement('span');
        errorSpan.className = 'error-message';
        errorSpan.textContent = mensaje;
        
        // Eliminar mensaje de error existente
        const errorExistente = campo.nextElementSibling;
        if (errorExistente && errorExistente.classList.contains('error-message')) {
            errorExistente.remove();
        }
        
        campo.parentNode.insertBefore(errorSpan, campo.nextSibling);
        campo.classList.add('error');
    }
    
    function ocultarError(campo) {
        const errorExistente = campo.nextElementSibling;
        if (errorExistente && errorExistente.classList.contains('error-message')) {
            errorExistente.remove();
        }
        campo.classList.remove('error');
    }
});
