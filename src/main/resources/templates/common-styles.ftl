<style>
  :root {
    --primary-color: #2563eb;
    --primary-dark: #1d4ed8;
    --secondary-color: #0ea5e9;
    --text-dark: #1e293b;
    --text-light: #64748b;
    --text-muted: #94a3b8;
    --bg-white: #ffffff;
    --bg-gray: #f8fafc;
    --bg-light: #f1f5f9;
    --border-color: #e2e8f0;
    --success-color: #10b981;
    --danger-color: #ef4444;
    --warning-color: #f59e0b;
    --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  }

  /* Reset básico */
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  body {
    font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: var(--text-dark);
    line-height: 1.6;
    background-color: var(--bg-gray);
  }

  a {
    text-decoration: none;
    color: var(--primary-color);
    transition: color 0.3s;
  }

  a:hover {
    color: var(--primary-dark);
  }

  /* Barra de navegación */
  .navbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 1rem 2rem;
    background-color: var(--bg-white);
    box-shadow: var(--shadow);
    position: sticky;
    top: 0;
    z-index: 100;
  }

  .navbar-brand {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--primary-color);
  }

  .navbar-nav {
    display: flex;
    align-items: center;
    gap: 1.5rem;
  }

  .nav-link {
    color: var(--text-dark);
    font-weight: 500;
    transition: color 0.3s;
    display: flex;
    align-items: center;
    gap: 0.3rem;
  }

  .nav-link:hover {
    color: var(--primary-color);
  }

  .nav-link i {
    font-size: 1.1rem;
  }

  /* Botones */
  .btn {
    display: inline-block;
    font-weight: 500;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    user-select: none;
    padding: 0.5rem 1rem;
    border-radius: 0.375rem;
    transition: all 0.3s ease;
    cursor: pointer;
    font-size: 0.875rem;
  }

  .btn-primary {
    background-color: var(--primary-color);
    color: white;
    border: none;
  }

  .btn-primary:hover {
    background-color: var(--primary-dark);
  }

  .btn-secondary {
    background-color: var(--secondary-color);
    color: white;
    border: none;
  }

  .btn-secondary:hover {
    background-color: #0b9bda;
  }

  .btn-success {
    background-color: var(--success-color);
    color: white;
    border: none;
  }

  .btn-success:hover {
    background-color: #0ca376;
  }

  .btn-danger {
    background-color: var(--danger-color);
    color: white;
    border: none;
  }

  .btn-danger:hover {
    background-color: #dc2626;
  }

  /* Contenedores */
  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
  }

  /* Tarjetas */
  .card {
    background-color: var(--bg-white);
    border-radius: 0.5rem;
    box-shadow: var(--shadow);
    overflow: hidden;
  }

  .card-header {
    padding: 1rem 1.5rem;
    background-color: var(--bg-light);
    border-bottom: 1px solid var(--border-color);
  }

  .card-body {
    padding: 1.5rem;
  }

  .card-footer {
    padding: 1rem 1.5rem;
    background-color: var(--bg-light);
    border-top: 1px solid var(--border-color);
  }

  /* Alertas */
  .alert {
    padding: 1rem;
    border-radius: 0.5rem;
    margin-bottom: 1rem;
  }

  .alert-success {
    background-color: #ecfdf5;
    color: var(--success-color);
    border: 1px solid #a7f3d0;
  }

  .alert-danger {
    background-color: #fee2e2;
    color: var(--danger-color);
    border: 1px solid #fecaca;
  }

  .alert-warning {
    background-color: #fffbeb;
    color: var(--warning-color);
    border: 1px solid #fef3c7;
  }

  /* Formularios */
  .form-group {
    margin-bottom: 1rem;
  }

  .form-label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
  }

  .form-control {
    display: block;
    width: 100%;
    padding: 0.5rem 0.75rem;
    font-size: 1rem;
    line-height: 1.5;
    color: var(--text-dark);
    background-color: var(--bg-white);
    background-clip: padding-box;
    border: 1px solid var(--border-color);
    border-radius: 0.375rem;
    transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  }

  .form-control:focus {
    border-color: var(--primary-color);
    outline: 0;
    box-shadow: 0 0 0 0.25rem rgba(37, 99, 235, 0.25);
  }

  /* Utilidades */
  .text-center {
    text-align: center;
  }

  .mb-1 {
    margin-bottom: 0.25rem;
  }

  .mb-2 {
    margin-bottom: 0.5rem;
  }

  .mb-3 {
    margin-bottom: 1rem;
  }

  .mb-4 {
    margin-bottom: 1.5rem;
  }

  .mt-1 {
    margin-top: 0.25rem;
  }

  .mt-2 {
    margin-top: 0.5rem;
  }

  .mt-3 {
    margin-top: 1rem;
  }

  .mt-4 {
    margin-top: 1.5rem;
  }

  /* Responsive */
  @media (max-width: 768px) {
    .navbar {
      padding: 1rem;
      flex-direction: column;
      align-items: flex-start;
    }

    .navbar-nav {
      margin-top: 1rem;
      width: 100%;
      flex-direction: column;
      align-items: flex-start;
    }

    .container {
      padding: 1rem;
    }
  }
</style>
