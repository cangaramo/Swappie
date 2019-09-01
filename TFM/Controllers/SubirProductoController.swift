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

class SubirProductoController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var tituloTextField:UITextField?
    @IBOutlet var descripcionTexView:UITextView?
    @IBOutlet var descripcionContainer:UIView?
    @IBOutlet var marcaTextField:UITextField?
    @IBOutlet var tallaTextField:UITextField?
    @IBOutlet var categoriaTextField:UITextField?
    @IBOutlet var subirProductoButton:UIButton?
    @IBOutlet var previewImage1:UIImageView?
    @IBOutlet var previewImage2:UIImageView?
    @IBOutlet var previewImage3:UIImageView?
    
    var uiPicker : UIPickerView!

    var current_pick_image = 1;
    var selected_images: [UIImage] = []
    var url_images: [String] = []
    
    let salutations = ["XXS", "XS", "S", "M", "L", "XL", "XXL"]
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        setViews()
        setUIPicker()
        setImagePickers()
        
        tituloTextField?.delegate = self
        marcaTextField?.delegate = self
        tallaTextField?.delegate = self
        categoriaTextField?.delegate = self
        
        tituloTextField!.tag = 0
        descripcionTexView!.tag = 1
        marcaTextField!.tag = 2
        categoriaTextField!.tag = 3
        tallaTextField!.tag = 4
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: tituloTextField!, border_color: border_color)
        addBorder(textField: marcaTextField!, border_color: border_color)
        addBorder(textField: tallaTextField!, border_color: border_color)
        addBorder(textField: categoriaTextField!, border_color: border_color)
        addBorder(textField: descripcionContainer!, border_color: border_color)
        
        
        self.hideKeyboardWhenTappedAround()
        
        /* Subir producto */
        subirProductoButton!.addTarget(self, action: #selector(subirProducto), for: .touchUpInside)
    }
    
    /* Métodos */
    func animateTextField(textField: UIView, up: Bool)
    {
        let movementDistance:CGFloat = -150
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func addBorder(textField: UIView, border_color: UIColor){
        let width = CGFloat(1.0)
        let border = CALayer()
        border.borderColor = border_color.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    /* Text fields */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let border_color = UIColor(rgb: 0x5446D9)
        addBorder(textField: textField, border_color: border_color)
        
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textField, border_color: border_color)
        
        self.animateTextField(textField: textField, up:false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch (textField.tag){
        case 0:
            descripcionTexView?.becomeFirstResponder()
            break
        case 1:
            marcaTextField?.becomeFirstResponder()
            break
        case 2:
            categoriaTextField?.becomeFirstResponder()
            break
        case 3:
            tallaTextField?.becomeFirstResponder()
            break
        default:
             textField.resignFirstResponder()
        }
        
        // Do not add a line break
        return false
    }
    
    func setViews(){
        descripcionTexView!.delegate = self
        descripcionTexView?.text = "Añade una descripción"
        descripcionTexView!.textColor = UIColor.lightGray
    }
    
    /* Text view */
    func textViewDidBeginEditing(_ textView: UITextView) {
        /*
        if descripcionTexView!.textColor == UIColor.lightGray {
            descripcionTexView!.text = nil
            descripcionTexView!.textColor = UIColor.black
        }*/
        
        let border_color = UIColor(rgb: 0x5446D9)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTexView!.textColor == UIColor.lightGray {
            descripcionTexView!.text = nil
            descripcionTexView!.textColor = UIColor.black
        }
        
        self.animateTextField(textField: textView, up:true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        /*
        if descripcionTexView!.text.isEmpty {
            descripcionTexView!.text = "Añade una descripción"
            descripcionTexView!.textColor = UIColor.lightGray
        }*/
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTexView!.text.isEmpty {
            descripcionTexView!.text = "Añade una descripción"
            descripcionTexView!.textColor = UIColor.lightGray
        }
        
        self.animateTextField(textField: textView, up:false)
    }
    

    //Primero subir las imagenes y despues guardar producto
    @objc func subirProducto(){
        subirImagenes()
    }
    
    var timer: Timer?
    
    /* SUBIR IMAGES A STORAGE */
    func subirImagenes(){
        
        for selected_image in selected_images {
            
            let productImage = selected_image
            
            //Generar random String
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("productos_imagenes").child("\(imageName).png")
        
            if let uploadData = productImage.jpegData(compressionQuality: 0.1)
            {
                storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        guard let url = url else { return }
                        self.url_images.append(url.absoluteString)
                        
                        self.timer?.invalidate()
                        print("Cancelar timer")
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.guardarProducto), userInfo: nil, repeats: false)
                        print("schedule Guardar")
                        
                    })
                    
                })
            }
        }
    }
    
    /* GUARDAR PRODUCTO */
    @objc func guardarProducto () {
        
        //Get images
        var image1 = ""
        var image2 = ""
        var image3 = ""
        
        if url_images.indices.contains(0) {
            image1 = url_images[0]
        }
        if url_images.indices.contains(1) {
            image2 = url_images[1]
        }
        if url_images.indices.contains(2) {
            image3 = url_images[2]
        }
        
        //Get text fields
        guard let titulo = tituloTextField!.text,
            let descripcion = descripcionTexView!.text,
            let marca = marcaTextField!.text,
            let talla = tallaTextField!.text
        else {
                print("Form is not valid")
                return
        }
        
        //FIREBASE
        let ref = Database.database().reference().child("productos")
        let childRef = ref.childByAutoId()
        
        //Usuario ID
        let user_id = Auth.auth().currentUser!.uid
        
        //Producto valores
        let values = ["titulo": titulo,
                      "descripcion": descripcion,
                      "marca": marca,
                      "talla": talla,
                      "usuario": user_id,
                      "imagen1": image1,
                      "imagen2": image2,
                      "imagen3": image3] as [String : Any]
        
        //Anyadir primero a PRODUCTOS
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            //Producto ID
            guard let productoId = childRef.key else { return }
            
            //Anyadir a USER-PRODUCTS
            let userProductsRef = Database.database().reference().child("usuario-productos").child(user_id).child(productoId)
            userProductsRef.setValue(1)
            
            //self.tabBarController!.selectedIndex = 0
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.cerrarTab), userInfo: nil, repeats: false)
            
        }
    }
    
    /* DISMISS */
    @objc func cerrarTab(){
        handleCancel()
    }
    
}


