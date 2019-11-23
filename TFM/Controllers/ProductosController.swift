//
//  ProductosController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

import UIKit
import Firebase
import MapKit

class ProductosController: UIViewController {
    
    //Collection View
    @IBOutlet var collectionView:UICollectionView?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 5.0,
                                             bottom: 50.0,
                                             right: 5.0)
    
    //Search bar
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet var mensajeView:UIView?
    
    //Todos los mensajes
    var productos = [Producto]()
    
    var categoria_seleccionada:String?
    var genero_seleccionado:String?
    
    //Search
    var filteredProductos = [Producto]()
    var filtering:Bool = false
    
    //Filtros
    var talla_seccionada = ""
    var estados_seleccionados = [String]()
    var distancia_seleccionada = 100
    
    let locationManager = CLLocationManager()
    var latitud_usuario = ""
    var longitud_usuario = ""
    
    override func viewDidLoad() {
        
        //Searchc bar
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        let light_gray = UIColor(rgb:0xffffff)
        searchBar.backgroundColor = light_gray
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.backgroundColor = UIColor(rgb:0xf9f9f9)
        textFieldInsideUISearchBar?.font =  UIFont(name: "Raleway-Regular", size: 14)
        
        //Productos
        obtenerProductos()
        mensajeView?.isHidden = true
        
        //Location
        checkLocationServices()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func obtenerProductos() {
        
        print (categoria_seleccionada)

        
        var hayProductos = false
        
        Database.database().reference().child("productos")
            .observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let producto = Producto(dictionary: dictionary)
                    producto.id = snapshot.key
                    
                    //Mostrar solo los que pertenecen a esa categoria
                    if (producto.genero == self.genero_seleccionado){
                        if (producto.categoria == self.categoria_seleccionada || self.categoria_seleccionada == "_todo") {
            
                            hayProductos = true
                            self.productos.append(producto)
                            
                            //Configurar timer
                            self.timer?.invalidate()
                            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                        }
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    //print ("fin")
                    if (self.productos.isEmpty) {
                       print ("empty)")
                        self.mensajeView?.isHidden = false
                    }
                    else {
                        print("not empty")
                    }
                })
                
                
            }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable () {
        //Hilo principal
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
            if (self.productos.isEmpty) {
                self.mensajeView?.isHidden = false
            }

        })
    }
    
    
}


