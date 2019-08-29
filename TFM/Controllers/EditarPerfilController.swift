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

class EditarPerfilController: ViewController, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet var avatarImageView:UIImageView?
    @IBOutlet var nombreTextField:UITextField?
    @IBOutlet var ubicacionTextField:UITextField?
    @IBOutlet var descripcionTextView:UITextView?
    @IBOutlet var descripcionContainer:UIView?
    @IBOutlet var generoTextField:UITextField?
    
    var usuario:Usuario?
    
    override func viewDidLoad() {
        setViews()
        setUserData()
        setImagePicker()
        
        nombreTextField!.delegate = self
        ubicacionTextField!.delegate = self
        generoTextField!.delegate = self
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: nombreTextField!, border_color: border_color)
        addBorder(textField: ubicacionTextField!, border_color: border_color)
        addBorder(textField: generoTextField!, border_color: border_color)
        addBorder(textField: descripcionContainer!, border_color: border_color)
        
        
        self.hideKeyboardWhenTappedAround()
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil) */
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setViews(){
        //Descripcion
        descripcionTextView!.delegate = self
        descripcionTextView?.text = "Añade una descripción"
        descripcionTextView!.textColor = UIColor.lightGray
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        print ("keyboard")
        
     
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
    
/*
    @objc func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo! as [NSObject : AnyObject]
        let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        self.view.frame.origin.y += keyboardSize!.height
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo! as [NSObject : AnyObject]
        let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let offset  = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        if keyboardSize!.height == offset!.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize!.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize!.height - offset!.height
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    */
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let border_color = UIColor(rgb: 0xEA9085)
        addBorder(textField: textField, border_color: border_color)
        
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textField, border_color: border_color)
        
        self.animateTextField(textField: textField, up:false)
        
    }
    
    func animateTextField(textField: UIView, up: Bool)
    {
        let movementDistance:CGFloat = -130
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let border_color = UIColor(rgb: 0xEA9085)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTextView!.textColor == UIColor.lightGray {
            descripcionTextView!.text = nil
            descripcionTextView!.textColor = UIColor.black
        }
        
        self.animateTextField(textField: textView, up:true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: textView.superview!, border_color: border_color)
        
        if descripcionTextView!.text.isEmpty {
            descripcionTextView!.text = "Añade una descripción"
            descripcionTextView!.textColor = UIColor.lightGray
        }
        
        self.animateTextField(textField: textView, up:false)
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
                    print("Foto subida")
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
