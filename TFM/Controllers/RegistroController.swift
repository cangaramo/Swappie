//
//  RegistroController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import UIKit
import Firebase


class RegistroController: ViewController{
    
    @IBOutlet var nombreTextField:UITextField?
    @IBOutlet var contrasenaTextField:UITextField?
    @IBOutlet var emailTextField:UITextField?
    @IBOutlet var registroButton:UIButton?
    
    override func viewDidLoad(){
        registroButton!.addTarget(self, action: #selector(registrarUsuario), for: .touchUpInside)
    }
    
    @objc func registrarUsuario(){
        
        //Get text fields
        guard let email = emailTextField!.text,
            let contrasena = contrasenaTextField!.text,
            let nombre = nombreTextField!.text else {
                print("Form is not valid")
                return
        }
        
        //Crear usuario
        Auth.auth().createUser(withEmail: email, password: contrasena, completion: { (res, error) in
            
            if let error = error {
                print(error)
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
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
 
}
