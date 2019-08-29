//
//  IniciarSesionController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import UIKit
import Firebase

class IniciarSesionController: ViewController{
    
    @IBOutlet var emailTextField:UITextField?
    @IBOutlet var contrasenaTextField:UITextField?
    @IBOutlet var inicioSesionButton:UIButton?
    
    override func viewDidLoad(){
        inicioSesionButton!.addTarget(self, action: #selector(iniciarSesion), for: .touchUpInside)
    }
    
    @objc func iniciarSesion(){
        
        guard let email = emailTextField!.text, let contrasena = contrasenaTextField!.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: contrasena, completion: { (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            //successfully logged in our user
            
            //Mostrar menu
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabMenu = (storyboard.instantiateViewController(withIdentifier: "tabMenu") as? UITabBarController) {
                self.present(tabMenu, animated: true, completion: nil)
            }

        })
    }
    
    @IBAction func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
