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
    
    var productos = [Producto]()
    var timer: Timer?
    
    var headerHeight:CGFloat = 200
    
    var usuario:Usuario? 
    
    override func viewDidLoad() {
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
       
        
        obtenerProductos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    
    func obtenerProductos() {
        
        //Buscamos ese usuario en Usuario-productos
        let id = usuario!.id
        let ref = Database.database().reference().child("usuario-productos").child(id!)
        
        //Loop producto
        ref.observe(.childAdded, with: { (snapshot) in
            
            //Cogemos el producto id
            let messageId = snapshot.key
            
            let messagesReference = Database.database().reference().child("productos").child(messageId)
            
            //Single
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    
                    let producto = Producto(dictionary: dictionary)
                    producto.id = snapshot.key
                    self.productos.append(producto)
                    
                    //Background thread
                    
                     self.timer?.invalidate()
                     print("we just canceled our timer")
                     
                     self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                     print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
}
