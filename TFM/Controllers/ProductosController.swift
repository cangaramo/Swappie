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

class ProductosController: UIViewController, CLLocationManagerDelegate {
    
    //Esto acaso lo uso?
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
    var distancia_seleccionada = 0
    
    let locationManager = CLLocationManager()
    var latitud_usuario = ""
    var longitud_usuario = ""
    
    override func viewDidLoad() {
        print("Productos")
        
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        let light_gray = UIColor(rgb:0xffffff)
        searchBar.backgroundColor = light_gray
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        
        mensajeView?.isHidden = true
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white 
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0, green: 255, blue: 255, alpha: 0)
        /*
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true*/
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
       // textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.backgroundColor = UIColor(rgb:0xf9f9f9)
        
        //textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(12)
        textFieldInsideUISearchBar?.font =  UIFont(name: "Raleway-Regular", size: 14)
        
        obtenerProductos()
        
        checkLocationServices()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            //Mostrar alerta para activar permisos
            mostrarMensaje()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        }
        
    }
    
    func mostrarMensaje(){
        let alertController = UIAlertController(title: "Es necesario activar permisos de Localización", message:
            "Se necesitan permisos de Localización para buscar productos cerca de ti", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        latitud_usuario = String(locValue.latitude)
        longitud_usuario = String(locValue.longitude)
        
    }
    
    func obtenerProductos() {
        Database.database().reference().child("productos")
            .observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let producto = Producto(dictionary: dictionary)
                    producto.id = snapshot.key
                    
                    //Mostrar solo los que pertenecen a esa categoria
                    if (producto.genero == self.genero_seleccionado){
                        if (producto.categoria == self.categoria_seleccionada || self.categoria_seleccionada == "_todo") {
                            self.productos.append(producto)
                            
                            //Background thread
                            self.timer?.invalidate()
                            print("we just canceled our timer")
                            
                            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                            print("schedule a table reload in 0.1 sec")
                        }
                    }
                    
                    self.handleReloadTable()
                    
                }
                
            }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable () {
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
            
            if (self.productos.isEmpty) {
                self.mensajeView?.isHidden = false
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
}


