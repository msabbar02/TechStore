<#import "../layout.ftl" as layout>

<@layout.layout title="Editar Producto - TechStore" showNavbar=false>
    <style>
        .header-simple {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            border-radius: 8px;
        }
        
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            padding: 2rem;
        }

        .form-title {
            margin-bottom: 2rem;
            font-size: 1.5rem;
            color: #1e293b;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 1rem;
        }
        
        .btn-volver {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            background-color: #2563eb;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }
        
        .btn-volver:hover {
            background-color: #1d4ed8;
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

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-textarea {
            min-height: 120px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }

        .btn-primary {
            background-color: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
        }

        .btn-secondary {
            background-color: #e2e8f0;
            color: #1e293b;
        }

        .btn-secondary:hover {
            background-color: #cbd5e1;
        }

        .form-hint {
            font-size: 0.875rem;
            color: #64748b;
            margin-top: 0.25rem;
        }

        .preview-container {
            margin-top: 1rem;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .img-preview {
            max-width: 100%;
            max-height: 200px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            padding: 0.25rem;
            margin-top: 0.5rem;
        }
        
        .file-input {
            width: 0.1px;
            height: 0.1px;
            opacity: 0;
            overflow: hidden;
            position: absolute;
            z-index: -1;
        }
        
        .file-input-label {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: #2563eb;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-weight: 500;
        }
        
        .file-input-label:hover {
            background-color: #1d4ed8;
        }
        
        #file-name {
            font-size: 0.875rem;
            color: #64748b;
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>

    <div class="header-simple">
        <h2>Editar Producto</h2>
        <a href="/dashboard" class="btn-volver">
            <i class="fas fa-arrow-left" style="margin-right: 0.5rem;"></i> Volver al Dashboard
        </a>
    </div>
    
    <div class="form-container">
        <h1 class="form-title">Editar Producto</h1>

        <form action="/productos/${producto.id}/actualizar" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="nombre" class="form-label">Nombre del producto*</label>
                <input type="text" id="nombre" name="nombre" class="form-input" 
                       value="${producto.nombre}" required>
            </div>
        
            <div class="form-group">
                <label for="descripcion" class="form-label">Descripción*</label>
                <textarea id="descripcion" name="descripcion" class="form-input form-textarea" required>${producto.descripcion}</textarea>
            </div>
        
            <div class="form-group">
                <label for="precio" class="form-label">Precio*</label>
                <input type="number" id="precio" name="precio" step="0.01" min="0" class="form-input" 
                       value="${producto.precio?string(",##0.00")}" required>
                <span class="form-hint">Ingrese el precio sin el símbolo de moneda</span>
            </div>
        
            <div class="form-group">
                <label for="imagen" class="form-label">Imagen del producto</label>
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <label for="imagen" class="file-input-label">
                        <i class="fas fa-upload"></i> Cambiar imagen
                    </label>
                    <input type="file" id="imagen" name="imagen" accept="image/*" class="file-input" onchange="previewImage(this)">
                    <span id="file-name">Imagen actual</span>
                </div>
                <span class="form-hint">Formatos aceptados: JPG, PNG, GIF. Tamaño máximo: 5MB. Deje vacío para mantener la imagen actual.</span>
                
                <div class="preview-container">
                    <img id="imgPreview" src="${producto.imagenUrl!'/img/default-product.jpg'}" 
                         class="img-preview" style="display: block;" alt="Vista previa de la imagen">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    <i class="fas fa-save" style="margin-right: 0.5rem;"></i> Actualizar Producto
                </button>
            </div>
        </form>
    </div>

    <script>
        function previewImage(input) {
            const imgPreview = document.getElementById('imgPreview');
            const fileName = document.getElementById('file-name');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // Actualizar el nombre del archivo
                fileName.textContent = file.name;
                
                // Crear un objeto URL para la vista previa
                const reader = new FileReader();
                reader.onload = function(e) {
                    imgPreview.src = e.target.result;
                    imgPreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                fileName.textContent = 'Ningún archivo seleccionado';
                // No ocultamos la imagen si no hay selección, mantenemos la imagen actual
            }
        }
    </script>
</@layout.layout>
