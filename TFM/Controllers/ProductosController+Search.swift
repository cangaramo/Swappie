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
    
    //Start search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    //Cancel search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    //Search button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        //Refresh
        filtering = false
        self.collectionView!.reloadData()
    }
    
    
    //Search function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let keyword:String = searchText
        
        if (!keyword.isEmpty){
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
            filtering = false
        }
        
        self.collectionView!.reloadData()
        
        if (self.filteredProductos.isEmpty) {
            self.mensajeView?.isHidden = false
        }
        else {
            self.mensajeView?.isHidden = true
        }
    }
}
