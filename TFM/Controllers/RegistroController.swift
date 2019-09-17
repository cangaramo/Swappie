//
//  RegistroController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import UIKit
import Firebase


class RegistroController: ViewController, UITextFieldDelegate{
    
    @IBOutlet var nombreTextField:UITextField?
    @IBOutlet var contrasenaTextField:UITextField?
    @IBOutlet var emailTextField:UITextField?
    @IBOutlet var registroButton:UIButton?
    @IBOutlet var mensajeError:UILabel?
    
    override func viewDidLoad(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        registroButton!.addTarget(self, action: #selector(registrarUsuario), for: .touchUpInside)
        
        nombreTextField?.delegate = self
        emailTextField?.delegate = self
        contrasenaTextField?.delegate = self
        
        nombreTextField!.tag = 1
        emailTextField!.tag = 2
        contrasenaTextField!.tag = 3
        
        
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: emailTextField!, border_color: border_color)
        addBorder(textField: nombreTextField!, border_color: border_color)
        addBorder(textField: contrasenaTextField!, border_color: border_color)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    /* Métodos */
    func animateTextField(textField: UIView, up: Bool)
    {
        let movementDistance:CGFloat = -100
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
        case 1:
            emailTextField?.becomeFirstResponder()
            break
        case 2:
            contrasenaTextField!.becomeFirstResponder()
            break
        case 3:
            textField.resignFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        
        // Do not add a line break
        return false
    }
    
    
    @objc func registrarUsuario(){
        
        //Get text fields
        guard let email = emailTextField!.text,
            let contrasena = contrasenaTextField!.text,
            let nombre = nombreTextField!.text else {
                mensajeError!.text = "Introduce usuario y contraseña"
                print("Form is not valid")
                return
        }
        
        if (email == "" || contrasena == "" || nombre == ""){
            mensajeError!.text = "Introduce usuario y contraseña"
        }
        else {
            
            //Crear usuario
            Auth.auth().createUser(withEmail: email, password: contrasena, completion: { (res, error) in
                
                if let error = error {

                    if (error.localizedDescription == "The email address is badly formatted.") {
                        self.mensajeError!.text = "Email inválido"
                    }
                    
                    else if (error.localizedDescription == "The password must be 6 characters long or more."){
                        self.mensajeError!.text = "Contraseña debe tener al menos 6 caracteres"
                    }
                    
                    return
                }
                guard let uid = res?.user.uid else {
                    return
                }
                let values = ["nombre": nombre, "email": email, "descripcion": "", "ubicacion": "", "genero": "", "imagen": ""]
                
                //successfully authenticated user
                let ref = Database.database().reference()
                let usersReference = ref.child("usuarios").child(uid)
                
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    //Mostrar menu
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let tabMenu = (storyboard.instantiateViewController(withIdentifier: "tabMenu") as? UITabBarController) {
                        self.present(tabMenu, animated: true, completion: nil)
                    }
                    
                })
                
            })
        }
        
        
    }
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
 
}
