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

class SubirProductoController: UIViewController {
    
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
    
    var subiendoProducto = false
    
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
        
        //Text fields
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
        
        //Toolbar        
        let cerrarToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        cerrarToolbar.barStyle = .default
        cerrarToolbar.tintColor = UIColor(rgb:0x0f45b55)
        cerrarToolbar.barTintColor = UIColor.white
        cerrarToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(esconderKeyboard))]
        cerrarToolbar.sizeToFit()
        
        tituloTextField!.inputAccessoryView = cerrarToolbar
        descripcionTexView!.inputAccessoryView = cerrarToolbar
        marcaTextField!.inputAccessoryView = cerrarToolbar
        categoriaTextField!.inputAccessoryView = cerrarToolbar
        
        // Localizacion
        checkLocationServices()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Acction subir producto
        subirProductoButton?.setBackgroundColor(color: UIColor(rgb: 0x5446D9), forState: UIControl.State.highlighted)
        subirProductoButton?.setBackgroundColor(color: UIColor(rgb: 0x5446D9), forState: UIControl.State.focused)
        subirProductoButton!.addTarget(self, action: #selector(subirProducto), for: .touchUpInside)
    }
    
  
    @objc func esconderKeyboard() {
        view.endEditing(true)

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


