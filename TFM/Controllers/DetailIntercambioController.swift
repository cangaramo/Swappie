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
    @IBOutlet var cancelarButton: UIButton?
    
    @IBOutlet var infoMensaje:UIView?
    
    var sugerir:Bool = false
    var aceptado:Bool = false
    var realizado:Bool = false

    var intercambioId:String?
    
    var usuario_other:String?
    var usuario_self:String?
    
    var usuario_self_full:Usuario?
    var usuario_other_full:Usuario?
    
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
        obtenerUsuarios()
        comprobarEstado()
        
        infoMensaje!.isHidden = true
    }
    
    func comprobarEstado(){
        let intercambioUsuario1 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_self!).child(intercambioId!)
        
        intercambioUsuario1.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let estado = value!["estado"] as! String
            if (estado == "Aceptado") {
                self.aceptado = true
                self.enviarButton?.setTitle("Intercambio realizado", for: .normal)
                self.cancelarButton?.isEnabled = false
                self.cancelarButton?.backgroundColor = UIColor(rgb:0xC9CCD1)
                self.cancelarButton?.setTitleColor(UIColor.white, for: .disabled)
                
            }
            else if (estado == "Cancelado") {
                self.cancelarButton?.setTitle("Cancelado", for: .normal)
                self.cancelarButton?.isEnabled = false
                self.cancelarButton?.backgroundColor = UIColor(rgb:0xC9CCD1)
                self.cancelarButton?.setTitleColor(UIColor.white, for: .disabled)
                self.enviarButton?.isEnabled = false
                self.enviarButton?.backgroundColor = UIColor(rgb:0xC9CCD1)
            }
            else if (estado == "Realizado"){
                self.cancelarButton?.isEnabled = false
                self.cancelarButton?.backgroundColor = UIColor(rgb:0xC9CCD1)
                self.cancelarButton?.setTitleColor(UIColor.white, for: .disabled)
                self.enviarButton?.isEnabled = false
                self.enviarButton?.setTitle("Realizado", for: .normal)
                self.enviarButton?.backgroundColor = UIColor(rgb:0xC9CCD1)
            }
            else {
                self.aceptado = false
            }
        })
    }

    /* Colección otro usuario */
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
    
    
    /* Mi colección */
    func obtenerProductosSelf(){
       
        let usuario_id = self.usuario_self
        
        let refIntercambio = Database.database().reference().child("intercambios").child(intercambioId!)
        let usuarioSelfRef = refIntercambio.child(usuario_id!)
        
        usuarioSelfRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if (snapshot.hasChildren()){
                self.infoMensaje!.isHidden = true
            }
            else {
                self.infoMensaje!.isHidden = false
            }
        })

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
    
    
    
    /* ACTUALIZAR INTERCAMBIO EN BD */
    @IBAction func actualizarIntercambio(){
        
        //Marcar como realizado
        if (aceptado) {
            /* Marcar el usuario actual como REALIZADO */
            let intercambioUsuario1 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_self!).child(intercambioId!)
            intercambioUsuario1.child("estado").setValue("Realizado")
            
            
            let intercambioUsuario2 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_other!).child(intercambioId!)
            intercambioUsuario2.child("estado").setValue("Realizado")
            
            marcarComoVendido()
        }
        
        /* Sugerir intercambio */
        else if (sugerir){
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
    
    // Marcar como vendido
    func marcarComoVendido(){
        
        let productos = Database.database().reference().child("productos")
        productos.observe(.childAdded, with: { (snapshot) in
            
            let producto_id = snapshot.key
            
            var vendido = false
            
            for producto_self in self.productos_self {
                if (producto_self.id == producto_id){
                    vendido = true
                }
            }
            
            for producto_other in self.productos_other {
                if (producto_other.id == producto_id){
                    vendido = true
                }
            }
            
            if (vendido) {
                let productoReference = productos.child(producto_id)
                productoReference.child("intercambiado").setValue(1)
            }
        })
    }
    
    
    /* Acciones */
    @IBAction func cancelarIntercambio(){
        
        /* Marcar el usuario actual como ACEPTADO */
        let intercambioUsuario1 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_self!).child(intercambioId!)
        intercambioUsuario1.child("estado").setValue("Cancelado")
        
        
        let intercambioUsuario2 = Database.database().reference().child("usuarios-intercambios").child(self.usuario_other!).child(intercambioId!)
        intercambioUsuario2.child("estado").setValue("Cancelado")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func abrirChat(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatController = storyboard.instantiateViewController(withIdentifier: "chatController") as! ChatController
        
        //let usuario_chat = Usuario()
       // usuario_chat.id = usuario_other
        //chatController.usuario_other = usuario_chat
        
        chatController.usuario_other = usuario_other_full
        
        
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
    
    func obtenerUsuarios(){
        
        Database.database().reference().child("usuarios").child(self.usuario_self!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.usuario_self_full = Usuario(dictionary: dictionary)
                    self.usuario_self_full!.id = snapshot.key
                }
            },
            withCancel: nil
        )
        
        Database.database().reference().child("usuarios").child(self.usuario_other!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.usuario_other_full = Usuario(dictionary: dictionary)
                    self.usuario_other_full!.id = snapshot.key
                }
            },
                                withCancel: nil
        )
    }
}
