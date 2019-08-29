//
//  IntercambioViewController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 04/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DetailIntercambioController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var collectionView2: UICollectionView?
    
    var productos = [Producto]()
    var usuarioProductosArray = [UsuarioProductos]()
    
    var usuario1:String?
    var usuario2:String?
    var productos1 = [Producto]()
    var productos2 = [Producto]()
    
    var usuario:Usuario?
    var intercambioId:String?
    var timer: Timer?
    
    override func viewDidLoad() {
        //obtenerProductos()
        //obtenerIntercambio()
        obtenerProductos1()
        obtenerProductos2()
    }
    
    func obtenerProductos1(){
        print ("hola")
      
        //let usuario1_id = usuario!.id
        let usuario1_id = Auth.auth().currentUser!.uid
        print (intercambioId!)
        let refIntercambio = Database.database().reference().child("intercambios").child(intercambioId!)
        let usuario1Ref = refIntercambio.child(usuario1_id)
        
        usuario1Ref.observe(.childAdded, with: { (snapshot) in
            print ("producto key")
            
            print (snapshot.key)
            
            let producto_id = snapshot.key
            let productoReference = Database.database().reference().child("productos").child(producto_id)
            
            //Single
            productoReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let productoReal = Producto(dictionary: dictionary)
                    productoReal.id = snapshot.key
                    
                    self.productos1.append(productoReal)
                    
                    //Background thread
                    
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.seeProductos1), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil) 
        })
    }
    
    
    @objc func seeProductos1(){
        print ("??")
        for producto1 in productos1 {
            print (producto1.titulo)
        }
        self.handleReloadTable()
    }
    
    @objc func seeProductos2(){
        print ("??")
        for producto1 in productos1 {
            print (producto1.titulo)
        }
        self.handleReloadTable()
    }
    
    func obtenerProductos2(){
        print ("usuario 2")
        
        let usuario2_id = usuario!.id
    
        let refIntercambio = Database.database().reference().child("intercambios").child(intercambioId!)
        let usuario2Ref = refIntercambio.child(usuario2_id!)
        
        usuario2Ref.observe(.childAdded, with: { (snapshot) in
            print ("producto key")
            
            print (snapshot.key)
            
            let producto_id = snapshot.key
            let productoReference = Database.database().reference().child("productos").child(producto_id)
            
            //Single
            productoReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let productoReal = Producto(dictionary: dictionary)
                    productoReal.id = snapshot.key
                    
                    self.productos2.append(productoReal)
                    
                    //Background thread
                    
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.seeProductos2), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil)
        })
    }
    
    func obtenerIntercambio(){
        
        let refIntercambio = Database.database().reference().child("intercambios").child(intercambioId!)
        
        refIntercambio.observe(.childAdded, with: { (snapshot) in
            
            let usuarioId = snapshot.key
            let usuarioProducto = UsuarioProductos()
            usuarioProducto.usuario = usuarioId
            
            let usuarioRef = refIntercambio.child(usuarioId)
            print ("Snapshot")
    
            
            usuarioRef.observe(.childAdded, with: { (snapshot) in
                print ("producto key")
                print (snapshot.key)
                
                
                let producto_id = snapshot.key
                
                usuarioProducto.productos.append(producto_id)
                
                
                let productoReference = Database.database().reference().child("productos").child(producto_id)
                
                //Single
                productoReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        let productoReal = Producto(dictionary: dictionary)
                        productoReal.id = snapshot.key
                        
                        usuarioProducto.productosreal.append(productoReal)
                        
                        self.handleReloadTable()
                        
                        //Background thread
                        
                        self.timer?.invalidate()
                        print("we just canceled our timer")
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.seeArray), userInfo: nil, repeats: false)
                        print("schedule a table reload in 0.1 sec")
                        
                    }
                    
                }, withCancel: nil)
            
                
            })
            
            self.usuarioProductosArray.append(usuarioProducto)
        })
        
        
    }
    
    
    @objc func seeArray(){
        print (self.usuarioProductosArray)
        
        for usuarioProductos in usuarioProductosArray {
            let user = usuarioProductos.usuario
            let productos = usuarioProductos.productos
            let productosreal = usuarioProductos.productosreal
            print (user)
            print (productos)
            print (productosreal)
            
            for productoreal in productosreal {
                print (productoreal.talla)
            }
        }
        
        self.handleReloadTable()
    }
    
    func obtenerProductos() {
        
        //Buscamos ese usuario en Usuario-productos
        let id = usuario!.id
        let ref = Database.database().reference().child("usuario-productos").child(id!)
        
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
                    /*
                     self.timer?.invalidate()
                     print("we just canceled our timer")
                     
                     self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                     print("schedule a table reload in 0.1 sec")*/
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
}
