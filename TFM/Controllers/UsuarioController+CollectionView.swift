//
//  UsuarioController+CollectionView.swift
//  TFM
//
//  Created by Clarisa Angaramo on 03/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import Firebase
import UIKit

extension UsuarioController:
UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate{
    
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            "perfilHeader", for: indexPath) as! PerfilHeder
        
        header.usuario = self.usuario
        headerHeight = header.getHeaderHeight()
        self.view.layoutIfNeeded()
        header.layoutIfNeeded()
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let height = headerHeight
        return CGSize(width:collectionView.bounds.width , height: CGFloat(height))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let producto = productos[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId2", for: indexPath) as! ProductoCell
        
        cell.producto = producto
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Detail Producto Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailProductoController = storyboard.instantiateViewController(withIdentifier: "detailProductoController") as! DetailProductoController
        
        //Pasar producto
        let producto = productos[indexPath.item]
        detailProductoController.producto = producto
        navigationController?.pushViewController(detailProductoController,animated: true)
    }
    
    @objc func handleReloadTable () {
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
        })
    }
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        lastOffsetY = scrollView.contentOffset.y
    }
 

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
    
    //func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
       let hide = scrollView.contentOffset.y > self.lastOffsetY
        
        if (hide){
            /*
            perfilView!.isHidden = true
            self.notHiddenConstraint.isActive = false
            self.hiddenConstraint.isActive = true */
            self.navigationItem.title = usuario!.nombre

            /*
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.6) {
                self.view.layoutIfNeeded()
            }*/
        }
        else {
            /*
            self.notHiddenConstraint.isActive = true
            self.hiddenConstraint.isActive = false */
            self.navigationItem.title = ""
            
            /*
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.6, animations: {
                self.view.layoutIfNeeded()
            }, completion: {res in
                //Do something
                self.perfilView!.isHidden = false
            })*/
        }
    }
}
