//
//  AnyadirProductosController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 07/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AnyadirProductosController:UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet var collectionView:UICollectionView?
    
    var usuario_id:String?
    var productos = [Producto]()
    
    var productos_seleccionados = [Producto]()
    
    var anyadirProductos : ( ([Producto] ) -> Void)?
    
    var timer:Timer?

    
    override func viewDidLoad() {

        obtenerProductos()
    }
    
    
    func obtenerProductos() {
        
        //Buscamos ese usuario en Usuario-productos
        let ref = Database.database().reference().child("usuario-productos").child(usuario_id!)
        
        //Loop producto
        ref.observe(.childAdded, with: { (snapshot) in
            
            //Cogemos el producto id y loop en Productos
            let messageId = snapshot.key
            
            let messagesReference = Database.database().reference().child("productos").child(messageId)
            
            //Single
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    
                    let producto = Producto(dictionary: dictionary)
                    producto.id = snapshot.key
                    self.productos.append(producto)
                    
                    self.handleReloadTable()
                    
                    //Background thread
                    
                     self.timer?.invalidate()
                     print("we just canceled our timer")
                     
                     self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                     print("schedule a table reload in 0.2 sec")
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    @objc func handleReloadTable () {
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
        })
    }
    
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
          //  cell.layer.borderWidth = 2
           // cell.layer.borderColor = UIColor(rgb: 0xEA9085).cgColor
            cell.containerView!.layer.borderColor = UIColor(rgb: 0xf45b55).cgColor
            cell.checkImageView?.isHidden = false
        }
        else {
           // cell.layer.borderWidth = 2
           // cell.layer.borderColor = UIColor.white.cgColor
            cell.containerView!.layer.borderColor = UIColor.white.cgColor
            cell.checkImageView?.isHidden = true
        }
    
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let producto = productos[indexPath.item]
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProductoCell
        /*
        cell.containerView!.layer.borderColor = UIColor(rgb: 0xEA9085).cgColor
        cell.containerView!.layer.borderColor = UIColor(rgb: 0xEA9085).cgColor
        cell.containerView!.layer.borderWidth = 3
        cell.containerView!.layer.cornerRadius = 10
        //cell.containerView!.layer.masksToBounds = true */
        
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
           // cell.layer.borderWidth = 2
           // cell.layer.borderColor = UIColor.white.cgColor
            cell.containerView!.layer.borderColor = UIColor.white.cgColor
            cell.checkImageView?.isHidden = true
            productos_seleccionados.remove(at: selected_index)
            
        }
        //Añadir
        else {
           // cell.layer.borderWidth = 2
           // cell.layer.borderColor = UIColor(rgb: 0xEA9085).cgColor
            cell.containerView!.layer.borderColor = UIColor(rgb: 0xf45b55).cgColor
            cell.checkImageView?.isHidden = false
            productos_seleccionados.append(producto)
        }
    }
    
    @IBAction func productosSeleccionados(){
        print ("productos seleccionados")
        print (productos_seleccionados)
        self.anyadirProductos!(productos_seleccionados)
        self.navigationController?.popViewController(animated: true)
    }
}
