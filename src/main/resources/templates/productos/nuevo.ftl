<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nuevo Producto - TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: #f8fafc;
            font-family: 'Poppins', sans-serif;
            padding: 2rem;
        }
        .card {
            border-radius: 16px;
            padding: 2rem;
            max-width: 600px;
            margin: 0 auto;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body>

<div class="card">
    <h1 class="mb-4 text-center">Añadir Nuevo Producto</h1>

    <form action="/productos/crear" method="post" enctype="multipart/form-data" id="nuevoForm">
    <div class="mb-3">
            <label class="form-label">Nombre del Producto</label>
            <input type="text" name="nombre" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Descripción</label>
            <textarea name="descripcion" class="form-control" rows="4"></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Precio</label>
            <input type="number" name="precio" step="0.01" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Existencias</label>
            <input type="number" name="existencias" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Imagen del Producto</label>
            <input type="file" name="imagenUrl" class="form-control">
        </div>

        <div class="d-flex gap-2">
            <button type="submit" class="btn btn-primary w-50">
                <i class="fas fa-plus"></i> Crear Producto
            </button>
            <a href="/dashboard" class="btn btn-outline-secondary w-50">
                <i class="fas fa-times"></i> Cancelar
            </a>
        </div>


    </form>

    <script>
        document.getElementById('nuevoForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);

            fetch(this.action, {
                method: 'POST',
                body: formData
            })
                .then(response => {
                    if (response.ok) {
                        window.location.href = '/dashboard';
                    } else {
                        throw new Error('Error al crear producto');
                    }
                })
                .catch(error => {
                    alert('Error al crear el producto: ' + error.message);
                });
        });
    </script>

</div>

</body>
</html>
