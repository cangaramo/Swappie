//
//  ProductosController+CollectionView.swift
//  TFM
//
//  Created by Clarisa Angaramo on 16/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension ProductosController:
UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    /* Collection view */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height:250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (filtering){
            return filteredProductos.count
        }
        else {
            return productos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var producto = productos[indexPath.item]
        
        if (filtering){
            producto = filteredProductos[indexPath.item]
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProductoCell
        
        cell.producto = producto
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Pasar producto
        var producto = productos[indexPath.item]
        
        if (filtering){
            producto = filteredProductos[indexPath.item]
        }
        
        //Detail Producto Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailProductoController = storyboard.instantiateViewController(withIdentifier: "detailProductoController") as! DetailProductoController
        detailProductoController.producto = producto
        navigationController?.pushViewController(detailProductoController,animated: true)
    }
    
    
}
