//
//  IntercambioViewController+CollectionView.swift
//  TFM
//
//  Created by Clarisa Angaramo on 04/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

extension DetailIntercambioController:
UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    /* Collection view */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        
        return CGSize(width: size, height:250)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            "intercambioHeader", for: indexPath) as! IntercambioUsuarioHeder
        
        if (collectionView == self.collectionView) {
           header.usuario_id = self.usuario_other
            let anyadirProductoButton = header.anyadirProductoButton
            anyadirProductoButton!.addTarget(self, action: #selector(self.anyadir), for: .touchUpInside)
           
            header.usuarioImageView?.isUserInteractionEnabled = true
            let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verSuPerfil))
            header.usuarioImageView?.addGestureRecognizer(mytapGestureRecognizer)
          
        }
        else {
            header.usuario_id = self.usuario_self
           
            header.usuarioImageView?.isUserInteractionEnabled = true
            let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verMiPerfil))
            header.usuarioImageView?.addGestureRecognizer(mytapGestureRecognizer)
           
        }
        
        return header
    }
    
    @objc func verSuPerfil(_ sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usuarioController = storyboard.instantiateViewController(withIdentifier: "usuarioController") as! UsuarioController
        usuarioController.usuario = usuario_other_full
        navigationController?.pushViewController(usuarioController,animated: true)
        
    }
    
    @objc func verMiPerfil(_ sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usuarioController = storyboard.instantiateViewController(withIdentifier: "usuarioController") as! UsuarioController
        usuarioController.usuario = usuario_self_full
        navigationController?.pushViewController(usuarioController,animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == self.collectionView) {
            return productos_other.count
        }
        else {
            return productos_self.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.collectionView) {
            let producto = productos_other[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId3", for: indexPath) as! ProductoCell
            cell.producto = producto
            return cell
        }
            
        else {
            let producto = productos_self[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId4", for: indexPath) as! ProductoCell
            cell.producto = producto
            
            let borrarButton = cell.borrarButton
            borrarButton!.tag = indexPath.row
            borrarButton!.addTarget(self, action: #selector(borrarProducto), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    
    @objc func handleReloadTable () {
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
        })
    }
    
    @objc func handleReloadTable2 () {
        DispatchQueue.main.async(execute: {
            self.collectionView2!.reloadData()
        })
    }
    
    
}
