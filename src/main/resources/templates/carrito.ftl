<#import "layout.ftl" as layout>

<@layout.layout title="Carrito de Compras - TechStore">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }

        .carrito-container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        h1 {
            color: #1e293b;
            margin-bottom: 2rem;
        }

        .carrito-tabla {
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .carrito-tabla th,
        .carrito-tabla td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .carrito-tabla th {
            background-color: #f8fafc;
            font-weight: 600;
        }

        .producto-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }

        .cantidad-input {
            width: 80px;
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            text-align: center;
        }

        .btn {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-eliminar {
            background-color: #dc2626;
            color: white;
        }

        .btn-actualizar {
            background-color: #0ea5e9;
            color: white;
        }

        .btn-seguir-comprando {
            background-color: #2563eb;
            color: white;
            margin-right: 1rem;
        }

        .btn-finalizar {
            background-color: #059669;
            color: white;
        }

        .total {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            text-align: right;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .acciones {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
        }

        @media (max-width: 768px) {
            .carrito-tabla {
                display: block;
                overflow-x: auto;
            }

            .acciones {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="carrito-container">
        <h1><i class="fas fa-shopping-cart"></i> Carrito de Compras</h1>
        
        <#if items?? && items?size gt 0>
            <table class="carrito-tabla">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Nombre</th>
                        <th>Precio</th>
                        <th>Cantidad</th>
                        <th>Subtotal</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <#list items as item>
                        <tr>
                            <td>
                                <img src="${item.producto.imagenUrl!'/img/default-product.jpg'}" 
                                     alt="${item.producto.nombre}" 
                                     class="producto-img">
                            </td>
                            <td>${item.producto.nombre}</td>
                            <td>$${item.producto.precio?string(",##0.00")}</td>
                            <td>
                                <form action="/carrito/${item.producto.id}/actualizar" method="post" style="display: inline;">
                                    <input type="number" name="cantidad" 
                                           value="${item.cantidad}" 
                                           min="1" 
                                           class="cantidad-input"
                                           onchange="this.form.submit()">
                                </form>
                            </td>
                            <td>$${(item.producto.precio * item.cantidad)?string(",##0.00")}</td>
                            <td>
                                <form action="/carrito/${item.producto.id}/eliminar" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-eliminar">
                                        <i class="fas fa-trash"></i> Eliminar
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </#list>
                </tbody>
            </table>
            
            <div class="total">
                Total: $${total?string(",##0.00")}
            </div>

            <div class="acciones">
                <a href="/index" class="btn btn-seguir-comprando">
                    <i class="fas fa-arrow-left"></i> Seguir comprando
                </a>
                <form action="/carrito/finalizar" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-finalizar" id="btnFinalizarCompra">
                        <i class="fas fa-check"></i> Finalizar Compra
                    </button>
                </form>
                
                <script>
                    document.getElementById('btnFinalizarCompra').addEventListener('click', function(e) {
                        e.preventDefault();
                        const form = this.closest('form');
                        
                        fetch(form.action, {
                            method: 'POST',
                            headers: {
                                'X-Requested-With': 'XMLHttpRequest'
                            }
                        })
                        .then(response => {
                            if (response.ok) {
                                // Redireccionar a la página de pedidos
                                window.location.href = '/ordenes';
                            } else {
                                throw new Error('Error al finalizar la compra');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Error al finalizar la compra. Por favor, inténtelo de nuevo.');
                        });
                    });
                                    
                                    // Manejar botón de finalizar compra
                                    const btnFinalizarCompra = document.getElementById('btnFinalizarCompra');
                                    if (btnFinalizarCompra) {
                        btnFinalizarCompra.addEventListener('click', function() {
                            // Mostrar animación de carga
                            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Procesando...';
                            this.disabled = true;
                            
                            fetch('/carrito/finalizar', {
                                method: 'POST',
                                headers: {
                                    'X-Requested-With': 'XMLHttpRequest'
                                }
                            })
                            .then(response => {
                                if (response.ok) {
                                    // Actualizar contador del carrito
                                    const contador = document.querySelector('.cart-counter');
                                    if (contador) {
                                        contador.style.display = 'none';
                                    }
                                    
                                    // Redirigir a la página de órdenes
                                    window.location.href = '/ordenes';
                                } else {
                                    throw new Error('Error al procesar la compra');
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                this.innerHTML = '<i class="fas fa-check"></i> Finalizar Compra';
                                this.disabled = false;
                                
                                // Mostrar mensaje de error
                                const mensajeError = document.createElement('div');
                                mensajeError.style.backgroundColor = '#fee2e2';
                                mensajeError.style.color = '#dc2626';
                                mensajeError.style.padding = '1rem';
                                mensajeError.style.borderRadius = '8px';
                                mensajeError.style.marginTop = '1rem';
                                mensajeError.innerHTML = '<i class="fas fa-exclamation-circle"></i> Error al procesar la compra. Por favor, inténtelo de nuevo.';
                                
                                // Insertar después del botón
                                this.parentNode.insertAdjacentElement('afterend', mensajeError);
                                
                                // Auto-eliminar después de 5 segundos
                                setTimeout(() => {
                                    mensajeError.remove();
                                }, 5000);
                            });
                        });
                                    }
                                });
                            </script>
                        </@layout.layout>
                </script>
            </div>
                    <#else>
            <div style="text-align: center; padding: 3rem;">
                <p style="margin-bottom: 1rem;">No hay productos en el carrito</p>
                <a href="/index" class="btn btn-seguir-comprando">
                    <i class="fas fa-arrow-left"></i> Ir al catálogo
                </a>
            </div>
        </#if>
    </div>
        </@layout.layout>