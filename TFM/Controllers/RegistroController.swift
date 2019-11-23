//
//  RegistroController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import UIKit
import Firebase

class RegistroController: ViewController {
    
    @IBOutlet var nombreTextField:UITextField?
    @IBOutlet var contrasenaTextField:UITextField?
    @IBOutlet var emailTextField:UITextField?
    @IBOutlet var registroButton:UIButton?
    @IBOutlet var mensajeError:UILabel?
    
    override func viewDidLoad(){
        
        //Navigation controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        registroButton!.addTarget(self, action: #selector(registrarUsuario), for: .touchUpInside)
        
        /* TEXT FIELDS */
        nombreTextField?.delegate = self
        emailTextField?.delegate = self
        contrasenaTextField?.delegate = self
        
        //Añadir tags
        nombreTextField!.tag = 1
        emailTextField!.tag = 2
        contrasenaTextField!.tag = 3
        
        //Añadir borde
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: emailTextField!, border_color: border_color)
        addBorder(textField: nombreTextField!, border_color: border_color)
        addBorder(textField: contrasenaTextField!, border_color: border_color)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func registrarUsuario(){
        
        //Recoger datos de text fields
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
                
                //Añadir usuario a la BD
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
