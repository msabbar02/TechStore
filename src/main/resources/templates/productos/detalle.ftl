<#import "../layout.ftl" as layout>

<@layout.layout title="Detalle de Producto - TechStore">
    <style>
        .producto-detalle {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        
        .producto-header {
            display: flex;
            align-items: flex-start;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .producto-img-container {
            flex: 0 0 40%;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        
        .producto-img {
            width: 100%;
            height: auto;
            object-fit: cover;
        }
        
        .producto-info {
            flex: 1;
        }
        
        .producto-titulo {
            margin: 0 0 1rem 0;
            font-size: 2rem;
            color: #1e293b;
        }
        
        .producto-precio {
            font-size: 2rem;
            font-weight: bold;
            color: #2563eb;
            margin: 1rem 0;
        }
        
        .producto-descripcion {
            margin: 1rem 0;
            color: #4b5563;
            line-height: 1.6;
        }
        
        .producto-stock {
            display: inline-block;
            background-color: #ecfdf5;
            color: #065f46;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-weight: 500;
            margin: 1rem 0;
        }
        
        .acciones {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
        }
        
        .btn-success {
            background-color: #10b981;
            color: white;
        }
        
        .btn-primary {
            background-color: #2563eb;
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        
        .cantidad-container {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .cantidad-label {
            font-weight: 500;
        }
        
        .cantidad-input {
            width: 80px;
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            text-align: center;
        }
        
        .volver-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #4b5563;
            text-decoration: none;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        
        .volver-link:hover {
            color: #2563eb;
        }
        
        .caracteristicas {
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }
        
        .caracteristicas h3 {
            margin-bottom: 1rem;
            font-size: 1.5rem;
            color: #1e293b;
        }
        
        .especificaciones-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
        }
        
        .especificacion-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem;
            background-color: #f8fafc;
            border-radius: 8px;
        }
        
        .especificacion-item i {
            color: #2563eb;
        }
    </style>

    <a href="/catalogo_simple" class="volver-link">
        <i class="fas fa-arrow-left"></i> Volver al catálogo
    </a>

    <div class="producto-detalle">
        <div class="producto-header">
            <div class="producto-img-container">
                <img src="${producto.imagenUrl!'/img/default-product.jpg'}" 
                     alt="${producto.nombre}" 
                     class="producto-img">
            </div>
            <div class="producto-info">
                <h1 class="producto-titulo">${producto.nombre}</h1>
                <p class="producto-descripcion">${producto.descripcion}</p>
                <p class="producto-precio">$${producto.precio?string(",##0.00")}</p>
                <span class="producto-stock">En stock</span>
                
                <div class="cantidad-container">
                    <label for="cantidad" class="cantidad-label">Cantidad:</label>
                    <input type="number" id="cantidad" class="cantidad-input" value="1" min="1">
                </div>
                
                <div class="acciones">
                    <button onclick="agregarAlCarritoDesdeDetalle(${producto.id})" class="btn btn-success">
                        <i class="fas fa-shopping-cart"></i> Añadir al carrito
                    </button>
                    <a href="/carrito" class="btn btn-primary">
                        <i class="fas fa-shopping-bag"></i> Ver carrito
                    </a>
                </div>
            </div>
        </div>
        
        <div class="caracteristicas">
            <h3>Características del producto</h3>
            <div class="especificaciones-list">
                <div class="especificacion-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Alta calidad garantizada</span>
                </div>
                <div class="especificacion-item">
                    <i class="fas fa-truck"></i>
                    <span>Envío rápido</span>
                </div>
                <div class="especificacion-item">
                    <i class="fas fa-shield-alt"></i>
                    <span>Garantía de 1 año</span>
                </div>
                <div class="especificacion-item">
                    <i class="fas fa-exchange-alt"></i>
                    <span>Devoluciones permitidas dentro de 30 días</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Evitar múltiples clics
        let agregandoAlCarrito = false;
        
        function agregarAlCarritoDesdeDetalle(id) {
            // Evitar que se envíe el mismo producto varias veces
            if (agregandoAlCarrito) return;
            agregandoAlCarrito = true;
            
            // Obtener el botón que se clickeó
            const boton = document.querySelector('.btn-success');
            const textoOriginal = boton.innerHTML;
            
            // Obtener la cantidad seleccionada
            const cantidad = document.getElementById('cantidad').value;
            
            // Cambiar el texto del botón mientras se procesa
            boton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Agregando...';
            boton.disabled = true;
            
            // Actualizar inmediatamente el contador para dar feedback instantáneo
            const contador = document.getElementById('cart-counter');
            if (contador) {
                let cantidadActual = parseInt(contador.textContent || "0");
                cantidadActual += parseInt(cantidad);
                contador.style.display = 'flex';
                contador.textContent = cantidadActual;
            }
            
            // Mostrar notificación instantánea
            mostrarNotificacion('Agregando producto al carrito...', 'procesando');
            
            fetch(`/carrito/${id}/anadir?cantidad=${cantidad}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error en la respuesta del servidor');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    // Actualizar contador con el valor real
                    actualizarContadorCarrito();
                    
                    // Mostrar notificación de éxito
                    mostrarNotificacion('¡Producto agregado al carrito!', 'exito');
                    
                    // Cambiar texto del botón a "Agregado"
                    boton.innerHTML = '<i class="fas fa-check"></i> Agregado';
                    boton.style.backgroundColor = '#10b981';
                    
                    // Restaurar texto original después de 1.5 segundos
                    setTimeout(() => {
                        boton.innerHTML = textoOriginal;
                        boton.style.backgroundColor = '';
                        boton.disabled = false;
                        agregandoAlCarrito = false;
                    }, 1500);
                } else {
                    // Mostrar error
                    mostrarNotificacion('Error al agregar producto', 'error');
                    boton.innerHTML = textoOriginal;
                    boton.disabled = false;
                    agregandoAlCarrito = false;
                    console.error('Error detallado:', data);
                }
            })
            .catch(error => {
                console.error('Error completo:', error);
                mostrarNotificacion('Error al procesar la solicitud', 'error');
                boton.innerHTML = textoOriginal;
                boton.disabled = false;
                agregandoAlCarrito = false;
            });
        }
        
        function mostrarNotificacion(mensaje, tipo) {
            // Eliminar notificaciones anteriores
            const notificacionesExistentes = document.querySelectorAll('.notificacion-flotante');
            notificacionesExistentes.forEach(n => n.remove());
            
            // Crear nueva notificación
            const notificacion = document.createElement('div');
            notificacion.className = 'notificacion-flotante';
            
            // Estilos según el tipo
            let colorFondo, colorTexto, icono;
            if (tipo === 'exito') {
                colorFondo = '#d1fae5';
                colorTexto = '#065f46';
                icono = 'fa-check-circle';
            } else if (tipo === 'error') {
                colorFondo = '#fee2e2';
                colorTexto = '#b91c1c';
                icono = 'fa-exclamation-circle';
            } else { // procesando
                colorFondo = '#e0f2fe';
                colorTexto = '#0369a1';
                icono = 'fa-spinner fa-spin';
            }
            
            // Aplicar estilos
            notificacion.style.cssText = `
                position: fixed;
                top: 80px;
                right: 20px;
                padding: 12px 20px;
                background-color: ${colorFondo};
                color: ${colorTexto};
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                z-index: 9999;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
                animation: slideIn 0.3s ease;
            `;
            
            notificacion.innerHTML = `<i class="fas ${icono}"></i> ${mensaje}`;
            document.body.appendChild(notificacion);
            
            // Eliminar después de 2 segundos para notificaciones de éxito y error
            if (tipo !== 'procesando') {
                setTimeout(() => {
                    notificacion.style.animation = 'slideOut 0.3s ease forwards';
                    setTimeout(() => {
                        if (notificacion.parentNode) {
                            notificacion.parentNode.removeChild(notificacion);
                        }
                    }, 300);
                }, 2000);
            }
        }
        
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
                .catch(error => console.error('Error:', error));
        }
        
        // Agregar estilos de animación
        const estilos = document.createElement('style');
        estilos.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(estilos);
        
        // Actualizar contador al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            actualizarContadorCarrito();
        });
    </script>
</@layout.layout>
