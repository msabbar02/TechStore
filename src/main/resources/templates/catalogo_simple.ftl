<#import "layout.ftl" as layout>

<@layout.layout title="Catálogo de Productos - TechStore">
    <style>
        .dashboard-container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .dashboard-actions {
            margin-bottom: 2rem;
        }

        .productos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        .producto-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .producto-card:hover {
            transform: translateY(-5px);
        }

        .producto-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .producto-info {
            padding: 1.25rem;
        }

        .producto-info h3 {
            margin: 0 0 0.5rem 0;
            font-size: 1.25rem;
            color: #1e293b;
        }

        .precio {
            font-size: 1.5rem;
            font-weight: bold;
            color: #2563eb;
            margin: 1rem 0;
        }

        .acciones {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background-color: #2563eb;
            color: white;
        }

        .btn-success {
            background-color: #10b981;
            color: white;
        }

        .btn-secondary {
            background-color: #0ea5e9;
            color: white;
        }

        .btn-danger {
            background-color: #dc2626;
            color: white;
        }

        .mensaje-exito {
            background-color: #d1fae5;
            color: #065f46;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            border-left: 4px solid #10b981;
        }
    </style>

    <div class="dashboard-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Catálogo de Productos</h1>
            <a href="/carrito" class="btn btn-primary">
                <i class="fas fa-shopping-cart"></i> Ver Carrito
            </a>
        </div>

        <#if mensaje??>
            <div class="mensaje-exito">
                <i class="fas fa-check-circle me-2"></i> ${mensaje}
            </div>
        </#if>

        <div class="productos-grid">
            <#if productos?? && productos?size gt 0>
                <#list productos as producto>
                    <div class="producto-card">
                        <img src="${producto.imagenUrl!'/img/default-product.jpg'}"
                             alt="${producto.nombre}"
                             class="producto-img">
                        <div class="producto-info">
                            <h3>${producto.nombre}</h3>
                            <p>${producto.descripcion}</p>
                            <p class="precio">$${producto.precio?string(",##0.00")}</p>
                            <div class="acciones">
                                <button onclick="agregarAlCarrito(${producto.id}, event)" class="btn btn-success">
                                    <i class="fas fa-shopping-cart"></i> Añadir al carrito
                                </button>
                                <a href="/productos/${producto.id}/detalle" class="btn btn-secondary">
                                    <i class="fas fa-info-circle"></i> Detalles
                                </a>
                            </div>
                        </div>
                    </div>
                </#list>
            <#else>
                <p class="no-productos">No hay productos disponibles</p>
            </#if>
        </div>
    </div>

    <script>
        function agregarAlCarrito(id) {
            fetch(`/carrito/${id}/anadir`, {
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
                    // Actualizar contador de carrito si existe
                    actualizarContadorCarrito();
                    alert('¡Producto agregado al carrito!');
                } else {
                    alert('Error al agregar el producto: ' + (data.error || 'Error desconocido'));
                    console.error('Error detallado:', data);
                }
            })
            .catch(error => {
                console.error('Error completo:', error);
                alert('Error al procesar la solicitud: ' + error.message);
            });
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
        
        // Actualizar contador al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            actualizarContadorCarrito();
        });
    </script>
</@layout.layout>