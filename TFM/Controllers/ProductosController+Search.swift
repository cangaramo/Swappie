//
//  ProductosController+Search.swift
//  TFM
//
//  Created by Clarisa Angaramo on 18/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension ProductosController: UISearchBarDelegate {
    
    //Comenzar busqueda
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    //Cancelar busqueda
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    //Botón buscar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        //Refresh
        filtering = false
        self.collectionView!.reloadData()
    }
    
    
    //Realizar busqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let keyword:String = searchText
        
        if (!keyword.isEmpty){
            print ("keyword")
            let buscar_productos = productos
            
            filteredProductos = buscar_productos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    if ( producto.titulo!.contains(keyword) || producto.marca!.contains(keyword) || producto.categoria!.contains(keyword) || producto.descripcion!.contains(keyword) ){
                        match = true
                    }
                    return match
            })
            
            filtering = true
        }
        else {
            print ("no keyword")
            filteredProductos = productos
            filtering = false
        }
        
        self.collectionView!.reloadData()
        
        print(filteredProductos)
        
        if (self.filteredProductos.isEmpty) {
            print("empty")
            self.mensajeView?.isHidden = false
        }
        else {
            print("not empty")
            self.mensajeView?.isHidden = true
        }
    }
}
