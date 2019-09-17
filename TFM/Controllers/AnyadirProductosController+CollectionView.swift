//
//  AnyadirProductosController+CollectionView.swift
//  TFM
//
//  Created by Clarisa Angaramo on 17/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension AnyadirProductosController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height:250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let producto = productos[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId6", for: indexPath) as! ProductoCell
        
        cell.producto = producto
        
        /* Comprobar si el producto ya esta seleccionado */
        var seleccionado = false
        for producto_selected in productos_seleccionados {
            if (producto_selected.id == producto.id){
                seleccionado = true
            }
        }
        
        //Actualizar estilo de la celda
        if (seleccionado) {
            cell.containerView!.layer.borderColor = UIColor(rgb: 0xf45b55).cgColor
            cell.checkImageView?.isHidden = false
        }
        else {
            cell.containerView!.layer.borderColor = UIColor.white.cgColor
            cell.checkImageView?.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let producto = productos[indexPath.item]
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProductoCell
    
        /* Comprobar si el producto ya esta seleccionado */
        var seleccionado = false
        var selected_index = 0
        for (index, producto_selected) in productos_seleccionados.enumerated() {
            if (producto_selected.id == producto.id){
                seleccionado = true
                selected_index = index
            }
        }
        
        //Eliminar
        if (seleccionado) {
            cell.containerView!.layer.borderColor = UIColor.white.cgColor
            cell.checkImageView?.isHidden = true
            productos_seleccionados.remove(at: selected_index)
            
        }
        //Añadir
        else {
            cell.containerView!.layer.borderColor = UIColor(rgb: 0xf45b55).cgColor
            cell.checkImageView?.isHidden = false
            productos_seleccionados.append(producto)
        }
    }
}
