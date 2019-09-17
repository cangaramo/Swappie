//
//  SubirProductoController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation

class SubirProductoController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var tituloTextField:UITextField?
    @IBOutlet var descripcionTexView:UITextView?
    @IBOutlet var descripcionContainer:UIView?
    @IBOutlet var marcaTextField:UITextField?
    @IBOutlet var tallaTextField:UITextField?
    @IBOutlet var categoriaTextField:UITextField?
    @IBOutlet var estadoTextField:UITextField?
    @IBOutlet var subirProductoButton:UIButton?
    @IBOutlet var previewImage1:UIImageView?
    @IBOutlet var previewImage2:UIImageView?
    @IBOutlet var previewImage3:UIImageView?
    @IBOutlet var errorMensaje:UILabel?
    
    var uiPicker : UIPickerView!

    var current_pick_image = 1;
    var selected_images: [UIImage] = []
    var url_images: [String] = []
    
    let tallas = ["XXS", "XS", "S", "M", "L", "XL", "XXL"]
    let estados = ["Sin estrenar", "Apenas usado", "En muy buen estado", "Bastante usado"]
    
    var genero:String = ""
    var categoriaId:String? = ""
    
    let locationManager = CLLocationManager()
    var latitud_producto = ""
    var longitud_producto = ""
    
    var timer: Timer?

    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        setUIPicker()
        setImagePickers()
        
        self.hideKeyboardWhenTappedAround()
        
        //Description Text View
        descripcionTexView!.delegate = self
        descripcionTexView?.text = "Añade una descripción"
        descripcionTexView!.textColor = UIColor.lightGray
        
        tituloTextField?.delegate = self
        marcaTextField?.delegate = self
        tallaTextField?.delegate = self
        categoriaTextField?.delegate = self
        estadoTextField?.delegate = self
        
        tituloTextField!.tag = 0
        descripcionTexView!.tag = 1
        marcaTextField!.tag = 2
        categoriaTextField!.tag = 3
        tallaTextField!.tag = 4
        estadoTextField!.tag = 5
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: tituloTextField!, border_color: border_color)
        addBorder(textField: marcaTextField!, border_color: border_color)
        addBorder(textField: tallaTextField!, border_color: border_color)
        addBorder(textField: categoriaTextField!, border_color: border_color)
        addBorder(textField: estadoTextField!, border_color: border_color)
        addBorder(textField: descripcionContainer!, border_color: border_color)
        
        // Localizacion
        checkLocationServices()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Subir producto
        subirProductoButton!.addTarget(self, action: #selector(subirProducto), for: .touchUpInside)

    }
    
    /* LOCALIZACION */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        latitud_producto = String(locValue.latitude)
        longitud_producto = String(locValue.longitude)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                break
            case .denied:
                //Mostrar alerta para activar permisos
                subirProductoButton?.isEnabled = false
                subirProductoButton?.backgroundColor = UIColor(rgb:0xC9CCD1)
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
            "Se necesitan permisos de Localización para publicar un producto", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /* CATEGORIAS*/
    
    // Obtener los productos seleccionados
    func seleccionarCategoria(categoria_id:String, categoria_nombre:String, genero: String){

        //Genero
        self.genero = genero
        
        //Categoria
        if (categoria_nombre == "Ver todo" ){
            categoriaTextField!.text = "Otro"
            self.categoriaId = "otro"
        }
        else {
            categoriaTextField!.text = categoria_nombre
            self.categoriaId = categoria_id
        }
    }
    
    // Ir a Categorias Controller
    func irACategorias(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let seleccionarCategoriaController = storyboard.instantiateViewController(withIdentifier: "seleccionarCategoriaController") as! SeleccionarCategoriaController
        seleccionarCategoriaController.seleccionarCategoria = self.seleccionarCategoria
        navigationController?.pushViewController(seleccionarCategoriaController,animated: true)
    }
    
    
    /* DISMISS */
    @objc func cerrarTab(){
        handleCancel()
    }
    
}


