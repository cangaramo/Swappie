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
    
    @IBOutlet var containerViewHeight: NSLayoutConstraint?
    @IBOutlet var collectionViewHeight: NSLayoutConstraint?
    @IBOutlet var collectionView2Height: NSLayoutConstraint?
    
    @IBOutlet var enviarButton: UIButton?
    
    var sugerir:Bool = false
    var aceptado:Bool = false

    var intercambioId:String?
    
    var usuario_other:String?
    var usuario_self:String?
    
    var productos_self = [Producto]()
    var productos_other = [Producto]()
    
    var productos_other_nuevos = [Producto]()
    var productos_other_viejos = [Producto]()
    var productos_self_viejos = [Producto]()
        
    var timer: Timer?
    var timer2: Timer?
    
    override func viewDidLoad() {
        usuario_self = Auth.auth().currentUser!.uid
        obtenerProductosSelf()
        obtenerProductosOther()
        comprobarEstado()
    }
    
    func comprobarEstado(){
        let intercambioUsuario1 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_self!).child(intercambioId!)
        
        intercambioUsuario1.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let estado = value!["estado"] as! String
            if (estado == "Aceptado") {
                self.aceptado = true
                self.enviarButton?.setTitle("Aceptado", for: .normal)
                self.enviarButton?.isEnabled = false
                
            }
            else {
                self.aceptado = false
            }
        })
    }

    /* Collección arriba */
    func obtenerProductosOther(){
        
        let usuario_id = self.usuario_other
    
        let refIntercambio = Database.database().reference().child("intercambios").child(intercambioId!)
        let usuarioOtherRef = refIntercambio.child(usuario_id!)
        
        usuarioOtherRef.observe(.childAdded, with: { (snapshot) in
            
            let producto_id = snapshot.key
            let productoReference = Database.database().reference().child("productos").child(producto_id)
            
            //Single
            productoReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let productoReal = Producto(dictionary: dictionary)
                    productoReal.id = snapshot.key
                    
                    self.productos_other.append(productoReal)
                    
                    //Background thread
                    
                    self.timer2?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.seeProductosOther), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil)
        })
    }
    
    @objc func seeProductosOther(){
        self.handleReloadTable()
         actualizarConstraints()
    }
    
    
    /* Colleción de abajo */
    func obtenerProductosSelf(){
       
        let usuario_id = self.usuario_self
        
        let refIntercambio = Database.database().reference().child("intercambios").child(intercambioId!)
        let usuarioSelfRef = refIntercambio.child(usuario_id!)
        
        usuarioSelfRef.observe(.childAdded, with: { (snapshot) in
           
            let producto_id = snapshot.key
            let productoReference = Database.database().reference().child("productos").child(producto_id)
            
            //Single
            productoReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let productoReal = Producto(dictionary: dictionary)
                    productoReal.id = snapshot.key
                    
                    self.productos_self.append(productoReal)
                    
                    //Background thread
                    
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.seeProductosSelf), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil)
        })
    }
    
    @objc func seeProductosSelf(){
        self.handleReloadTable2()
        actualizarConstraints()
    }

    //Ir a AnyadirProductos Controller
    @objc func anyadir (){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let anyadirProductosController = storyboard.instantiateViewController(withIdentifier: "anyadirProductosController") as! AnyadirProductosController
        anyadirProductosController.usuario_id =  self.usuario_other
        anyadirProductosController.productos_seleccionados = self.productos_other
        anyadirProductosController.anyadirProductos = self.anyadirProductos
        navigationController?.pushViewController(anyadirProductosController,animated: true)
    }
    
    /* Obtener los productos seleccionados */
    func anyadirProductos(productos_seleccionados:[Producto]){
        
        productosAnyadir(productos_seleccionados: productos_seleccionados)
        productosBorrar(productos_seleccionados: productos_seleccionados)
    
        //Actualizar collection
        productos_other = productos_seleccionados
        self.collectionView?.reloadData()
        actualizarConstraints()
        
        cambioRealizado()
    }
    
    /* Borrar producto */
    @objc func borrarProducto (sender: UIButton) {
        let buttonIndex = sender.tag
        let producto = productos_self[buttonIndex]
        productos_self_viejos.append(producto)
        
        productos_self.remove(at: buttonIndex)
        self.handleReloadTable2()
        
        cambioRealizado()
    }
    
    //Productos a anyadir
    func productosAnyadir(productos_seleccionados: [Producto]){
        for producto_seleccionado in productos_seleccionados{
            var nuevo = true
            for producto_other in productos_other {
                if (producto_seleccionado.id == producto_other.id){
                    nuevo = false
                }
            }
            if (nuevo) {
                productos_other_nuevos.append(producto_seleccionado)
            }
        }
    }
    
    //Productos a borrar
    func productosBorrar(productos_seleccionados: [Producto]){
        for producto_other in productos_other {
            var viejo = true
            for producto_seleccionado in productos_seleccionados {
                if (producto_seleccionado.id == producto_other.id){
                    viejo = false
                }
            }
            if (viejo) {
                productos_other_viejos.append(producto_other)
            }
        }
    }
    
    
    /* Actualizar Firebase DB */
    @IBAction func actualizarIntercambio(){
       
        /* Sugerir intercambio */
        if (sugerir){
            let refIntercambio = Database.database().reference().child("intercambios").child(intercambioId!)
            
            /* Otro usuario */
            let usuarioOtherRef = refIntercambio.child(self.usuario_other!)
            
            //Remove old values
            for producto_viejo in productos_other_viejos {
                let producto_id = producto_viejo.id!
                usuarioOtherRef.child(producto_id).removeValue();
            }
            
            //Add children
            for producto_nuevo in productos_other_nuevos {
                let producto_id = producto_nuevo.id!
                usuarioOtherRef.child(producto_id).setValue(1)
            }
            
            /* Mi usuario */
            let usuarioSelfRef = refIntercambio.child(self.usuario_self!)
            
            //Remove old values
            for producto_viejo in productos_self_viejos {
                let producto_id = producto_viejo.id!
                usuarioSelfRef.child(producto_id).removeValue();
            }
            
            /* Marcar al usuario actual como ESPERANDO y al otro usuario como PENDIENTE */
            let intercambioUsuario1 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_self!).child(intercambioId!)
            intercambioUsuario1.child("estado").setValue("Esperando")
            
            let intercambioUsuario2 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_other!).child(intercambioId!)
            intercambioUsuario2.child("estado").setValue("Pendiente")
        }
        
        //Aceptar intercambio
        else {
            
            /* Marcar el usuario actual como ACEPTADO */
            let intercambioUsuario1 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_self!).child(intercambioId!)
            intercambioUsuario1.child("estado").setValue("Aceptado")
            
            
            let intercambioUsuario2 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_other!).child(intercambioId!)
            intercambioUsuario2.child("estado").setValue("Aceptado")
            
        }
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func cambioRealizado(){
        enviarButton?.setTitle("Sugerir intercambio", for: .normal)
        sugerir = true
    }
    
    
    @IBAction func abrirChat(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "chatController") as! ChatController
        let usuario_chat = Usuario()
        usuario_chat.id = usuario_other
        chatController.usuario_other = usuario_chat
        navigationController?.pushViewController(chatController,animated: true)
    }
    
    /* Actualizar constraints */
    func actualizarConstraints(){
        
        let heightNavbar = CGFloat (100)
        let heightBottomBAR = CGFloat (80)
        
        let rows = ((productos_other.count+1)/2)
        let heightCollectionView = CGFloat ((250 * rows) + 100)
        
        let rows2 = ((productos_self.count+1)/2)
        let heightCollection2View = CGFloat ((250 * rows2) + 90)
        
        collectionViewHeight!.constant = heightCollectionView
        collectionView2Height!.constant = heightCollection2View
        containerViewHeight!.constant = heightCollectionView + heightCollection2View + heightNavbar + heightBottomBAR
        
        self.collectionView!.layoutIfNeeded()
    }
}
