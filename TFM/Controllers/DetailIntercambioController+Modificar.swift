//
//  DetailIntercambioController+Modificar.swift
//  TFM
//
//  Created by Clarisa Angaramo on 19/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension DetailIntercambioController {
    
    /* MODIFICAR LISTA DE PRODUCTOS */
    
    //Ir a AnyadirProductos Controller
    @objc func anyadir (){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let anyadirProductosController = storyboard.instantiateViewController(withIdentifier: "anyadirProductosController") as! AnyadirProductosController
        anyadirProductosController.usuario_id =  self.usuario_other
        anyadirProductosController.productos_seleccionados = self.productos_other
        anyadirProductosController.anyadirProductos = self.anyadirProductos
        navigationController?.pushViewController(anyadirProductosController,animated: true)
    }
    
    // Obtener los productos seleccionados
    func anyadirProductos(productos_seleccionados:[Producto]){
        
        productosAnyadir(productos_seleccionados: productos_seleccionados)
        productosBorrar(productos_seleccionados: productos_seleccionados)
        
        //Actualizar collection
        productos_other = productos_seleccionados
        self.collectionView?.reloadData()
        actualizarConstraints()
        
        cambioRealizado()
    }
    
    
    //Productos a anyadir
    func productosAnyadir(productos_seleccionados: [Producto]){
        for producto_seleccionado in productos_seleccionados{
            var nuevo = true
            for producto_other in productos_other {
                if (producto_seleccionado.id == producto_other.id){
                    nuevo = false
                }
            }
            if (nuevo) {
                productos_other_nuevos.append(producto_seleccionado)
            }
        }
    }
    
    //Productos a borrar
    func productosBorrar(productos_seleccionados: [Producto]){
        for producto_other in productos_other {
            var viejo = true
            for producto_seleccionado in productos_seleccionados {
                if (producto_seleccionado.id == producto_other.id){
                    viejo = false
                }
            }
            if (viejo) {
                productos_other_viejos.append(producto_other)
            }
        }
    }
    
    func cambioRealizado(){
        enviarButton?.setTitle("Sugerir intercambio", for: .normal)
        sugerir = true
    }
    
    @objc func borrarProducto (sender: UIButton) {
        let buttonIndex = sender.tag
        let producto = productos_self[buttonIndex]
        productos_self_viejos.append(producto)
        
        productos_self.remove(at: buttonIndex)
        self.handleReloadTable2()
        
        cambioRealizado()
    }
}
