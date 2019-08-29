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

class SubirProductoController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var tituloTextField:UITextField?
    @IBOutlet var descripcionTexView:UITextView?
    @IBOutlet var marcaTextField:UITextField?
    @IBOutlet var tallaTextField:UITextField?
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
        
        /* Subir producto */
        subirProductoButton!.addTarget(self, action: #selector(subirProducto), for: .touchUpInside)
    }
    
    func setViews(){
        descripcionTexView!.delegate = self
        descripcionTexView?.text = "Añade una descripción"
        descripcionTexView!.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descripcionTexView!.textColor == UIColor.lightGray {
            descripcionTexView!.text = nil
            descripcionTexView!.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descripcionTexView!.text.isEmpty {
            descripcionTexView!.text = "Añade una descripción"
            descripcionTexView!.textColor = UIColor.lightGray
        }
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


