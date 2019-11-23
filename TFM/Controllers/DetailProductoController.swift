//
//  ProductoController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 28/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import AlamofireImage
import Firebase
import MapKit

class DetailProductoController: UIViewController {
    
    //Views
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet var tituloLabel: UILabel!
    @IBOutlet var marcaLabel: UILabel!
    @IBOutlet var tallaLabel: UILabel!
    @IBOutlet var perfilView: UIView!
    @IBOutlet var usuarioLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var descripcionLabel: UILabel!
    @IBOutlet var intercambiarButton: UIButton!
    @IBOutlet var mapView: MKMapView?
    @IBOutlet weak var borrarButton:UIBarButtonItem?
    
    var alamofireSource: [AlamofireSource] = []
    
    var intercambio_existe_id = ""

    var productoUsuario: Usuario?
    var producto:Producto? {
        
        didSet {
        
            //Images
            if producto?.imagen1 != "" {
                alamofireSource.append(AlamofireSource(urlString: producto!.imagen1!)!)
            }
            if producto?.imagen2 != "" {
                alamofireSource.append(AlamofireSource(urlString: producto!.imagen2!)!)
            }
            if producto?.imagen3 != "" {
                alamofireSource.append(AlamofireSource(urlString: producto!.imagen3!)!)
            }
        }
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Slideshow
        configurarSlideshow()
        
        // Producto
        tituloLabel.text = producto?.titulo
        tallaLabel.text = "‧  Talla " + producto!.talla!
        marcaLabel.text = producto?.marca
        descripcionLabel.text = producto?.descripcion
                
        // Usuario
        let usuario_id = producto?.usuario
        
        mostrarDatosUsuarios(usuario_id: usuario_id!)
                
        //Ocultar boton si es usuario actual
        let current_user_id =  Auth.auth().currentUser?.uid
        if (current_user_id == producto?.usuario) {
            intercambiarButton.isHidden = true
            borrarButton?.isEnabled = true
        }
            
        //Ocultar boton si ya se ha hecho un intercambio con ese usuario 
        else {
            
            borrarButton?.isEnabled = false
            borrarButton?.tintColor = .clear
            
            let usuario_producto = producto?.usuario
            let refUsuario = Database.database().reference().child("usuarios-intercambios").child(current_user_id!)
            refUsuario.observe(.childAdded, with: { (snapshot) in
                
                let intercambio = snapshot.value as! [String : AnyObject]
                let con_usuario = intercambio["con_usuario"] as! String
   
                if (con_usuario == usuario_producto ) {
                    self.intercambiarButton.setTitle("Ver intercambio", for: .normal)
                    self.intercambio_existe_id = snapshot.key
                }
            })
        }
        
        // Ir a Perfil de usuario
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        perfilView.addGestureRecognizer(tap)
        
        // Mostrar mapa
        showMap()
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.mapaTapped))
        mapView!.addGestureRecognizer(tap2)
        mapView!.delegate = self
    }
    
    func mostrarDatosUsuarios(usuario_id:String){
        
        Database.database().reference().child("usuarios").child(usuario_id)
            .observeSingleEvent(
                of: .value,
                with: {
                    (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.productoUsuario = Usuario(dictionary: dictionary)
                        self.productoUsuario!.id = snapshot.key
                        self.usuarioLabel.text = self.productoUsuario!.nombre
                        
                        if (self.productoUsuario!.imagen != "") {
                            self.avatarImageView.loadImageUsingCacheWithUrlString(self.productoUsuario!.imagen!)
                        }
                        else {
                            self.avatarImageView.image = UIImage(named:"avatar")
                        }
                    }
                    
            },
                withCancel: nil
        )
    }
    
    
    /* SLIDESHOW */
    func configurarSlideshow(){
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        //Controles
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        
        //Añadir imagenes
        slideshow.setImageInputs(alamofireSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailProductoController.didTapSlideShow))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTapSlideShow() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    //Ver Perfil del Usuario
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usuarioController = storyboard.instantiateViewController(withIdentifier: "usuarioController") as! UsuarioController
        usuarioController.usuario = productoUsuario
        navigationController?.pushViewController(usuarioController,animated: true)
    }
    
    /* Borrar producto */
    @IBAction func borrarProducto(){
        let producto_id = producto?.id
        
        //Borrar de Usuario-Productos
        let usuario_id = productoUsuario!.id
        let ref_user_prod = Database.database().reference().child("usuario-productos")
        ref_user_prod.child(usuario_id!).child(producto_id!).setValue(nil){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Error: \(error).")
            } else {
                
                //Borrar de Producto
                let ref_productos = Database.database().reference().child("productos")
                ref_productos.child(producto_id!).setValue(nil){
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Error: \(error).")
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    /* Intercambiar y Mostrar intercambio */
    @IBAction func intercambiar(){
        
        if (intercambiarButton.titleLabel!.text == "Intercambiar"){
            
            /* INTERCAMBIOS */
            let ref = Database.database().reference().child("intercambios")
            let intercambioRef = ref.childByAutoId()
            
            //Usuarios
            let usuario1 = Auth.auth().currentUser!.uid
            let usuario2 = productoUsuario!.id!
            
            //Producto valores
            let producto_ref = producto!.id
            
            //Añadir usuario y producro
            let userProductsRef = intercambioRef.child(usuario1)
            userProductsRef.setValue(1)
            
            //Añadir usuario
            let userProductsRef2 = intercambioRef.child(usuario2)
            userProductsRef2.child(producto_ref!).setValue(1)
            
            //Añadir intercambio a BD
            let refUsuarioIntercambio = Database.database().reference().child("usuarios-intercambios")
            let refInter1 = refUsuarioIntercambio.child(usuario1).child(intercambioRef.key!)
            refInter1.child("con_usuario").setValue(usuario2)
            refInter1.child("estado").setValue("Esperando")
            
            let refInter2 = refUsuarioIntercambio.child(usuario2).child(intercambioRef.key!)
            refInter2.child("con_usuario").setValue(usuario1)
            refInter2.child("estado").setValue("Pendiente")
            
            //Ir a intercambio
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let intercambioController = storyboard.instantiateViewController(withIdentifier: "intercambioController") as! DetailIntercambioController
            intercambioController.usuario_other = productoUsuario!.id
            intercambioController.intercambioId = intercambioRef.key
            navigationController?.pushViewController(intercambioController,animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailIntercambioController = storyboard.instantiateViewController(withIdentifier: "intercambioController") as! DetailIntercambioController
            
            //Pasar parametros
            let newUsuario = Usuario()
            newUsuario.id = productoUsuario!.id
            detailIntercambioController.usuario_other = newUsuario.id
            detailIntercambioController.intercambioId = intercambio_existe_id
            
            navigationController?.pushViewController(detailIntercambioController,animated: true)
        }
        
    }
    
}

extension DetailProductoController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
