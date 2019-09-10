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

class DetailProductoController: UIViewController, MKMapViewDelegate {
    
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
            
            print (producto!.latitud)
            print (producto!.longitud)
            
        }
        
       
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear */
        
       // self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)

        //self.navigationController?.navigationBar.backgroundColor = UIColor.white
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
                    //self.intercambiarButton.isHidden = true
                    self.intercambiarButton.setTitle("Ver intercambio", for: .normal)
                    self.intercambio_existe_id = snapshot.key
                }
            })
        }
        
        showItem()
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.mapaTapped))
        mapView!.addGestureRecognizer(tap2)
        mapView!.delegate = self
    }
    
    @objc func mapaTapped(){
        
        if (producto!.latitud != "" && producto!.longitud != "" ){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapController = storyboard.instantiateViewController(withIdentifier: "mapController") as! MapController
            mapController.producto_latitud = Double(producto!.latitud!)
            mapController.producto_longitud = Double(producto!.longitud!)
            navigationController?.pushViewController(mapController,animated: true)
        }
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "marker40")
        }
        
        return annotationView
    }
    
    
    func showItem (){
        // 1
        if (producto!.latitud != "" && producto!.longitud != "" ){
        
            let loc_lat = Double(producto!.latitud!)
            let loc_long = Double(producto!.longitud!)
            let location = CLLocationCoordinate2D(latitude: loc_lat!,
                                                  longitude: loc_long!)
            /* let location = CLLocationCoordinate2D(latitude: 51.60154930320717,
             longitude: -0.10170358233163292) */
            
            
            // 2
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView!.setRegion(region, animated: true)
            
            //3
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Big Ben"
            annotation.subtitle = "London"
            mapView!.addAnnotation(annotation)
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
    
    
    
    @IBAction func verMapa(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapController = storyboard.instantiateViewController(withIdentifier: "mapController") as! MapController
        navigationController?.pushViewController(mapController,animated: true)
    }
    
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
