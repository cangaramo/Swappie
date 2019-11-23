//
//  UsuarioController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 30/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UsuarioController: ViewController {
    
    @IBOutlet var collectionView:UICollectionView?
    var lastOffsetY :CGFloat = 0
    var headerHeight:CGFloat = 200
    
    @IBOutlet var mensajeView:UIView?
    
    var productos = [Producto]()
    var timer: Timer?
    
    var usuario:Usuario? 
    
    override func viewDidLoad() {
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.mensajeView?.isHidden = true
        obtenerProductos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //collectionView?.reloadData()
    }
    
    func obtenerProductos() {
        
        let id = usuario!.id
        
        //Buscamos ese usuario en Usuario-Productos
        let refProductos = Database.database().reference().child("usuario-productos")
        refProductos.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //El usuario tiene intercambios
            if (snapshot.hasChild(id!)) {
                self.mensajeView?.isHidden = true
            }
            //El usuario no tiene productos
            else {
                self.mensajeView?.isHidden = false
            }
            
        }, withCancel: nil)
        
        //Loop producto
        let ref = Database.database().reference().child("usuario-productos").child(id!)
        ref.observe(.childAdded, with: { (snapshot) in
            
            //Cogemos el producto id
            let messageId = snapshot.key
            let messagesReference = Database.database().reference().child("productos").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let producto = Producto(dictionary: dictionary)
                    producto.id = snapshot.key
                    self.productos.append(producto)
                    
                    //Configurar timer
                     self.timer?.invalidate()
                     self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
}
