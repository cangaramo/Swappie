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

class AnyadirProductosController:UIViewController {
    
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
                    
                     self.timer?.invalidate()
                     print("we just canceled our timer")
                     
                     self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
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
    
    
    @IBAction func productosSeleccionados(){
        self.anyadirProductos!(productos_seleccionados)
        self.navigationController?.popViewController(animated: true)
    }
}
