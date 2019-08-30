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
    
    
    var alamofireSource: [AlamofireSource] = []

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
        
        /* Navigation bar */
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        /* Slideshow */
        configurarSlideshow()
        
        /* Añadir info de producto */
        tituloLabel.text = producto?.titulo
        tallaLabel.text = "‧  Talla " + producto!.talla!
        marcaLabel.text = producto?.marca
        descripcionLabel.text = producto?.descripcion
        
        /* Añadir info de usuario */
       
        //Find user
        let usuario_id = producto?.usuario
        
        Database.database().reference().child("usuarios").child(usuario_id!)
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
        
        /* Perfil */
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        perfilView.addGestureRecognizer(tap)
                
         /* Ocultar boton si es usuario actual */
        let current_user_id =  Auth.auth().currentUser?.uid
        if (current_user_id == producto?.usuario) {
            intercambiarButton.isHidden = true
        }
        
        /* Ocultar boton si ya se ha hecho un intercambio con ese usuario */
        else {
            let usuario_producto = producto?.usuario
            let refUsuario = Database.database().reference().child("usuarios-intercambios").child(current_user_id!)
            refUsuario.observe(.childAdded, with: { (snapshot) in
                
                let intercambio = snapshot.value as! [String : AnyObject]
                let con_usuario = intercambio["con_usuario"] as! String
   
                if (con_usuario == usuario_producto ) {
                    self.intercambiarButton.isHidden = true
                }
            })
        }
        
    }
    
    /* SLIDESHOW */
    func configurarSlideshow(){
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        //Page control
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        
        //Add images
        slideshow.setImageInputs(alamofireSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailProductoController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        //Detail Producto Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usuarioController = storyboard.instantiateViewController(withIdentifier: "usuarioController") as! UsuarioController
        
        //Pasar producto
        usuarioController.usuario = productoUsuario
        navigationController?.pushViewController(usuarioController,animated: true)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    
    @IBAction func intercambiar(){
        
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
        
        /* USUARIO INTERCAMBIO */
        let refUsuarioIntercambio = Database.database().reference().child("usuarios-intercambios")
        let refInter1 = refUsuarioIntercambio.child(usuario1).child(intercambioRef.key!)
        //refInter1.setValue(usuario2)
        refInter1.child("con_usuario").setValue(usuario2)
        refInter1.child("estado").setValue("Esperando")
        
        let refInter2 = refUsuarioIntercambio.child(usuario2).child(intercambioRef.key!)
        //refInter2.setValue(usuario1)
         refInter2.child("con_usuario").setValue(usuario1)
        refInter2.child("estado").setValue("Pendiente")
        
        /* IR A INTERCAMBIO */
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let intercambioController = storyboard.instantiateViewController(withIdentifier: "intercambioController") as! DetailIntercambioController
        //intercambioController.usuario = productoUsuario
        intercambioController.usuario_other = productoUsuario!.id
        intercambioController.intercambioId = intercambioRef.key
        navigationController?.pushViewController(intercambioController,animated: true)
        
    }
    
}

extension DetailProductoController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
