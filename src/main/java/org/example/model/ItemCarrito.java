package org.example.model;

import java.math.BigDecimal;

public class ItemCarrito {
    private Producto producto;
    private int cantidad;
    private double precioUnitario;
    private static double subtotal;

    public ItemCarrito() {
    }

    public ItemCarrito(Producto producto, int cantidad) {
        this.producto = producto;
        this.cantidad = cantidad;
        this.precioUnitario = producto.getPrecio();
        this.calcularSubtotal();
    }

    // Getters y Setters
    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
        this.precioUnitario = producto.getPrecio();
        this.calcularSubtotal();
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
        this.calcularSubtotal();
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
        this.calcularSubtotal();
    }

    public static double getSubtotal() {
        return subtotal;
    }

    // Método para calcular el subtotal
    public void calcularSubtotal() {
        this.subtotal = this.precioUnitario * this.cantidad;
    }

    // Método para incrementar la cantidad
    public void incrementarCantidad() {
        this.cantidad++;
        this.calcularSubtotal();
    }

    // Método para decrementar la cantidad
    public boolean decrementarCantidad() {
        if (this.cantidad > 1) {
            this.cantidad--;
            this.calcularSubtotal();
            return true;
        }
        return false;
    }


}