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

class ProductosController: UIViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var collectionView:UICollectionView?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 5.0,
                                             bottom: 50.0,
                                             right: 5.0)
    
    //Search bar
    @IBOutlet weak var searchBar: UISearchBar!

    
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
    var latitud_producto = ""
    var longitud_producto = ""
    
    override func viewDidLoad() {
        print("Productos")
        
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        let light_gray = UIColor(rgb:0xffffff)
        searchBar.backgroundColor = light_gray
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        
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
        
        print (categoria_seleccionada)
        obtenerProductos()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    //Start search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    //Cancel search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    //Search button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        //Refresh
        filtering = false
        self.collectionView!.reloadData()
    }
    
    
    
    //Search function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let keyword:String = searchText
        
        if (!keyword.isEmpty){
            let buscar_productos = productos
            
            filteredProductos = buscar_productos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    if ( producto.titulo!.contains(keyword) || producto.marca!.contains(keyword) || producto.categoria!.contains(keyword) || producto.descripcion!.contains(keyword) ){
                        match = true
                    }
                    return match
            })
            
            filtering = true
        }
        else {
            filtering = false
        }
        
        self.collectionView!.reloadData()
    }
    
    func obtenerProductos() {
        Database.database().reference().child("productos")
            .observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let producto = Producto(dictionary: dictionary)
                    print (producto)
                    print (producto.latitud)
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
                    
                }
                
            }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable () {
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        latitud_producto = String(locValue.latitude)
        longitud_producto = String(locValue.longitude)
        
    }
    
    //Filter
    func filterContentForSearchText(talla:String, estados:[String], distancia:Int) {
        
        let buscar_productos = productos
        
        //Primero filtro
        var filtroEstadoProductos = buscar_productos
        if (!estados.isEmpty){
            filtroEstadoProductos = buscar_productos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    for estado in estados {
                        if ( producto.estado! == estado ){
                            match = true
                        }
                    }
                    return match
            })
        }
        
        //Segundo filtro
        var filtroTallaProductos = filtroEstadoProductos
        if (!talla.isEmpty){
            filtroTallaProductos = filtroEstadoProductos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    if ( producto.talla! == talla ){
                        match = true
                    }
                    return match
            })
        }
        
        
        //Tercer filtro
        print (distancia)
        let distancia_busqueda = distancia
        var currentLocation:CLLocation?
        
        //Ubicacion actual
        if (latitud_producto != "" && longitud_producto != "" ){
            let lat = Double(latitud_producto)
            let lng = Double (longitud_producto)
            currentLocation = CLLocation(latitude: lat!, longitude: lng!)
        }
        
        var filtroUbicacionProductos = filtroTallaProductos
        if (distancia_busqueda != 0 && currentLocation != nil){
            filtroUbicacionProductos = filtroTallaProductos.filter(
                { (producto:Producto) -> Bool in
                    
                    var match = false
                    
                    if (producto.latitud != "" && producto.longitud != "") {
                        let lat = Double(producto.latitud!)!
                        let lng = Double( producto.longitud!)!
                        let location = CLLocation(latitude: lat, longitude: lng)
                        
                        let distance = currentLocation!.distance(from: location)
                        
                        let distance_km = distance/1000
                        
                        if (Int(distance_km) < distancia_busqueda) {
                            match = true
                        }
                    }
                    
                    return match
            })
        }
        
        filteredProductos = filtroUbicacionProductos
        
        filtering = true
        self.collectionView!.reloadData()
    }
    
    func devolverFiltros(talla:String, estados:[String], distancia:Int){

        self.talla_seccionada = talla
        self.estados_seleccionados = estados
        self.distancia_seleccionada = distancia
        
        if (!talla.isEmpty || !estados.isEmpty || distancia != 0){
            print ("Filtrar")
            filterContentForSearchText(talla:talla, estados:estados, distancia: distancia)
        }
        else {
            filtering = false
            self.collectionView!.reloadData()
        }
        
    }
    
    
    @IBAction func abrirFiltros(){
        print ("filtrar")
        //Detail Producto Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filtrosController = storyboard.instantiateViewController(withIdentifier: "filtrosController") as! FiltrosController
        filtrosController.devolverFiltros = self.devolverFiltros
        filtrosController.talla_seccionada = self.talla_seccionada
        filtrosController.estados_seleccionados = self.estados_seleccionados
        navigationController?.pushViewController(filtrosController,animated: true)
    }
    
    /* Collection view */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height:250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (filtering){
            return filteredProductos.count
        }
        else {
            return productos.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var producto = productos[indexPath.item]
        
        if (filtering){
            producto = filteredProductos[indexPath.item]
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProductoCell
        
        cell.producto = producto
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Detail Producto Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailProductoController = storyboard.instantiateViewController(withIdentifier: "detailProductoController") as! DetailProductoController
        
        //Pasar producto
        let producto = productos[indexPath.item]
        detailProductoController.producto = producto
        navigationController?.pushViewController(detailProductoController,animated: true)
    }
}

// MARK: - Collection View Flow Layout Delegate
/*
extension ProductosController  {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}*/
