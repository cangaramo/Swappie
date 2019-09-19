//
//  ProductosController+Filtros.swift
//  TFM
//
//  Created by Clarisa Angaramo on 18/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ProductosController {
    
    
    //Filter
    func filterContentForSearchText(talla:String, estados:[String], distancia:Int) {
        
        let buscar_productos = productos
        
        //Primero filtro
        var filtroEstadoProductos = buscar_productos
        if (!estados.isEmpty){
            filtroEstadoProductos = buscar_productos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    for estado in estados {
                        
                        if (producto.estado != nil) {
                            if ( producto.estado! == estado ){
                                match = true
                            }
                        }
                        
                    }
                    return match
            })
        }
        
        //Segundo filtro
        var filtroTallaProductos = filtroEstadoProductos
        if (!talla.isEmpty){
            filtroTallaProductos = filtroEstadoProductos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    if ( producto.talla! == talla ){
                        match = true
                    }
                    return match
            })
        }
        
        
        //Tercer filtro
        print (distancia)
        let distancia_busqueda = distancia
        var currentLocation:CLLocation?
        
        //Ubicacion actual
        if (latitud_usuario != "" && longitud_usuario != "" ){
            let lat = Double(latitud_usuario)
            let lng = Double (longitud_usuario)
            currentLocation = CLLocation(latitude: lat!, longitude: lng!)
        }
        
        var filtroUbicacionProductos = filtroTallaProductos
        if (distancia_busqueda != 0 && currentLocation != nil){
            filtroUbicacionProductos = filtroTallaProductos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    
                    if (producto.latitud != "" && producto.longitud != "") {
                        let lat = Double(producto.latitud!)!
                        let lng = Double( producto.longitud!)!
                        let location = CLLocation(latitude: lat, longitude: lng)
                        
                        let distance = currentLocation!.distance(from: location)
                        
                        let distance_km = distance/1000
                        
                        if (Int(distance_km) < distancia_busqueda) {
                            match = true
                        }
                    }
                    
                    return match
            })
        }
        
        filteredProductos = filtroUbicacionProductos
        
        filtering = true
        self.collectionView!.reloadData()
        
        if (self.filteredProductos.isEmpty) {
            self.mensajeView?.isHidden = false
        }
        else {
            self.mensajeView?.isHidden = true
        }
    }
    
    func devolverFiltros(talla:String, estados:[String], distancia:Int){
        
        self.talla_seccionada = talla
        self.estados_seleccionados = estados
        self.distancia_seleccionada = distancia
        
        if (!talla.isEmpty || !estados.isEmpty || distancia != 0){
            
            if (latitud_usuario == "" || longitud_usuario == ""){
                filterContentForSearchText(talla:talla, estados:estados, distancia: 0)
            }
            else {
                filterContentForSearchText(talla:talla, estados:estados, distancia: distancia)
            }
            
        }
        else {
            filtering = false
            self.collectionView!.reloadData()
        }
        
    }
    
    @IBAction func abrirFiltros(){
        //Detail Producto Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filtrosController = storyboard.instantiateViewController(withIdentifier: "filtrosController") as! FiltrosController
        filtrosController.devolverFiltros = self.devolverFiltros
        filtrosController.talla_seccionada = self.talla_seccionada
        filtrosController.estados_seleccionados = self.estados_seleccionados
        filtrosController.distancia_seleccionada = self.distancia_seleccionada
        navigationController?.pushViewController(filtrosController,animated: true)
    }
    
}
