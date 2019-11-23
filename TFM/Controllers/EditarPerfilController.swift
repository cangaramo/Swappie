//
//  EditarPerfilController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 30/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditarPerfilController: ViewController {
    
    @IBOutlet var avatarImageView:UIImageView?
    @IBOutlet var nombreTextField:UITextField?
    @IBOutlet var ubicacionTextField:UITextField?
    @IBOutlet var descripcionTextView:UITextView?
    @IBOutlet var descripcionContainer:UIView?
    @IBOutlet var generoTextField:UITextField?
    
    @IBOutlet var navigationBar:UINavigationBar?
    
    var usuario:Usuario?
    
    override func viewDidLoad() {
        
        self.navigationBar!.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar!.shadowImage = UIImage()
        self.navigationBar!.isTranslucent = true
        self.navigationBar!.backgroundColor = .clear
        
        setImagePicker()
        
        setUserData()
        
        //Text view
        descripcionTextView!.delegate = self
        descripcionTextView!.tag = 2
        descripcionTextView?.text = "Añade una descripción"
        descripcionTextView!.textColor = UIColor.lightGray
        
        //Text field
        nombreTextField!.delegate = self
        ubicacionTextField!.delegate = self
        generoTextField!.delegate = self
        
        nombreTextField!.tag = 0
        ubicacionTextField!.tag = 1
        generoTextField!.tag = 3
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: nombreTextField!, border_color: border_color)
        addBorder(textField: ubicacionTextField!, border_color: border_color)
        addBorder(textField: generoTextField!, border_color: border_color)
        addBorder(textField: descripcionContainer!, border_color: border_color)
        
        self.hideKeyboardWhenTappedAround()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "Raleway-Regular", size: 16 )!]
        self.navigationBar!.titleTextAttributes = textAttributes
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setUserData(){
        
        if (usuario!.imagen != "") {
            avatarImageView?.loadImageUsingCacheWithUrlString(usuario!.imagen!)
        }
        if (usuario!.nombre != "") {
            nombreTextField!.text = usuario!.nombre
        }
        if (usuario!.ubicacion != "") {
            ubicacionTextField!.text = usuario!.ubicacion
        }
        if (usuario!.descripcion != "") {
            descripcionTextView!.text = usuario!.descripcion
            descripcionTextView!.textColor = UIColor.black
        }
        if (usuario!.genero != "") {
            generoTextField!.text = usuario!.genero
        }
    }
    
    @IBAction func cancelar() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func guardar(){
        
        //Subir imagen a Firebase y despues actualizar usuario
        let image_placeholder = UIImage(named:"avatar")
        if (avatarImageView!.image != image_placeholder) {
            self.subirImagen()
        }
        //Actualizar usuario
        else {
            self.actualizarUsuario()
        }
    }
    
    func subirImagen(){
        
        let perfilImage = avatarImageView!.image!
            
        //Generar random String
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("fotos_de_perfil").child("\(imageName).png")
            
        if let uploadData = perfilImage.jpegData(compressionQuality: 0.1)
        {
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                    
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    guard let url = url else { return }
                    
                    //Foto subida correctamente: actualizar usuario
                    self.actualizarUsuario(imagen_url: url.absoluteString)
                })
            })
        }
    }
    
    func actualizarUsuario(imagen_url:String = ""){
        
        //Recoger valores
        let nombre = nombreTextField?.text ?? ""
        let ubicacion = ubicacionTextField?.text ?? ""
        var descripcion = descripcionTextView?.text ?? ""
        let genero = generoTextField?.text ?? ""
        if (descripcionTextView!.text == "Añade una descripcion") {
            descripcion = ""
        }
        
        let values = ["nombre": nombre, "email": usuario?.email, "descripcion": descripcion, "ubicacion": ubicacion, "genero": genero, "imagen": imagen_url]
        
        //Firebase
        let user_id = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let usersReference = ref.child("usuarios").child(user_id)
        
        usersReference.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            print("Usuario guardado")
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
}
