<#import "layout.ftl" as layout>

<@layout.layout title="Dashboard - TechStore">
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

        .btn-secondary {
            background-color: #0ea5e9;
            color: white;
        }

        .btn-danger {
            background-color: #dc2626;
            color: white;
        }
    </style>

    <div class="dashboard-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Dashboard Administrativo</h1>
        </div>
        
        <div class="dashboard-actions">
            <a href="/productos/nuevo" class="btn btn-primary" style="display: inline-flex; align-items: center; padding: 0.75rem 1.5rem; font-size: 1rem;">
                <i class="fas fa-plus" style="margin-right: 0.5rem;"></i> Agregar Nuevo Producto
            </a>
            <p style="margin-top: 0.5rem; color: var(--text-light); font-size: 0.9rem;">
                Haga clic en el botón para añadir un nuevo producto al catálogo
            </p>
        </div>

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
                                <a href="/productos/${producto.id}/editar" class="btn btn-secondary">
                                    <i class="fas fa-edit"></i> Editar
                                </a>
                                <form action="/productos/${producto.id}/eliminar" method="post" 
                                      style="display: inline-block;">
                                    <button type="submit" class="btn btn-danger" 
                                            onclick="return confirm('¿Estás seguro?')">
                                        <i class="fas fa-trash"></i> Eliminar
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </#list>
            <#else>
                <p class="no-productos">No hay productos disponibles</p>
            </#if>
        </div>
    </div>
</@layout.layout>