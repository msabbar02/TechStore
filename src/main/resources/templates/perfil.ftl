<#import "layout.ftl" as layout>

<@layout.layout title="Mi Perfil - TechStore">
    <style>
        .perfil-container {
            max-width: 800px;
            margin: 2rem auto;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        
        .perfil-header {
            background-color: #2563eb;
            color: white;
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .perfil-header h2 {
            margin: 0;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .perfil-body {
            padding: 2rem;
        }
        
        .perfil-foto {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e0e0e0;
            margin-bottom: 1rem;
        }
        
        .perfil-info {
            display: flex;
            gap: 2rem;
        }
        
        .perfil-foto-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-right: 2rem;
            border-right: 1px solid #e0e0e0;
        }
        
        .perfil-form-section {
            flex: 2;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #1e293b;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 1rem;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .form-control[readonly] {
            background-color: #f8fafc;
            cursor: not-allowed;
        }
        
        .text-muted {
            color: #64748b;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        .alert {
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .alert-success {
            background-color: #dcfce7;
            color: #15803d;
            border: 1px solid #86efac;
        }
        
        .alert-danger {
            background-color: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fca5a5;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 2rem;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
        }
        
        .btn-primary {
            background-color: #2563eb;
            color: white;
        }
        
        .btn-secondary {
            background-color: #64748b;
            color: white;
        }
        
        .btn-danger {
            background-color: #dc2626;
            color: white;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .perfil-info {
                flex-direction: column;
            }
            
            .perfil-foto-section {
                padding-right: 0;
                border-right: none;
                border-bottom: 1px solid #e0e0e0;
                padding-bottom: 2rem;
                margin-bottom: 2rem;
            }
            
            .form-actions {
                flex-direction: column;
                gap: 1rem;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>

    <div class="perfil-container">
        <div class="perfil-header">
            <h2><i class="fas fa-user-circle"></i> Mi Perfil</h2>
            <a href="${(usuario.rol == 'admin')?then('/dashboard','/index')}" class="btn btn-secondary" style="padding: 0.5rem 1rem; background-color: rgba(255,255,255,0.2);">
                <i class="fas fa-arrow-left"></i> Volver
            </a>
        </div>
        
        <div class="perfil-body">
            <#if mensaje??>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${mensaje}
                </div>
            </#if>
            <#if error??>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </#if>
            
            <div class="perfil-info">
                <div class="perfil-foto-section">
                    <img src="${usuario.fotoPerfil!'/img/default-avatar.png'}" alt="Foto de perfil" class="perfil-foto"
                         onerror="this.src='/img/default-avatar.png'">
                    <h3>${usuario.nombre!''} ${usuario.apellido!''}</h3>
                    <p class="text-muted">${(usuario.rol!'usuario')?capitalize}</p>
                </div>
                
                <div class="perfil-form-section">
                    <form action="/perfil" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="redirectTo" value="${(usuario.rol == 'admin')?then('/dashboard','/index')}">
                        
                        <div class="form-group">
                            <label for="nombre" class="form-label">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" value="${usuario.nombre!''}" 
                                  class="form-control" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="apellido" class="form-label">Apellido:</label>
                            <input type="text" id="apellido" name="apellido" value="${usuario.apellido!''}" 
                                  class="form-control" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="direccion" class="form-label">Dirección:</label>
                            <input type="text" id="direccion" name="direccion" value="${usuario.direccion!''}" 
                                  class="form-control">
                            <small class="text-muted">Esta dirección se utilizará para tus envíos</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="username" class="form-label">Nombre de usuario:</label>
                            <input type="text" id="username" name="username" value="${usuario.username!''}" 
                                  class="form-control" readonly>
                            <small class="text-muted">El nombre de usuario no se puede cambiar</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="fotoPerfil" class="form-label">Foto de perfil:</label>
                            <input type="file" id="fotoPerfil" name="fotoPerfil" class="form-control" 
                                  accept="image/jpeg,image/png,image/gif">
                            <small class="text-muted">Formatos permitidos: JPG, PNG, GIF (máx. 2MB)</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="newPassword" class="form-label">Nueva contraseña:</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-control">
                            <small class="text-muted">Dejar en blanco para mantener la contraseña actual</small>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Guardar cambios
                            </button>
                            <a href="${(usuario.rol == 'admin')?then('/dashboard','/index')}" class="btn btn-danger">
                                <i class="fas fa-times"></i> Cancelar
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</@layout.layout>