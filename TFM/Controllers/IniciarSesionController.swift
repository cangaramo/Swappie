//
//  IniciarSesionController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import UIKit
import Firebase

class IniciarSesionController: ViewController {
    
    @IBOutlet var emailTextField:UITextField?
    @IBOutlet var contrasenaTextField:UITextField?
    @IBOutlet var inicioSesionButton:UIButton?
    @IBOutlet var mensajeError:UILabel?
    
    override func viewDidLoad(){
        
        //Navigation controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear 
        
        inicioSesionButton!.addTarget(self, action: #selector(iniciarSesion), for: .touchUpInside)
        
        /* Text fields */
        
        emailTextField?.delegate = self
        contrasenaTextField?.delegate = self
        
        //Tags
        emailTextField!.tag = 1
        contrasenaTextField!.tag = 2
        
        //Bordes
        let border_color = UIColor(rgb: 0xd3d3d3)
        addBorder(textField: emailTextField!, border_color: border_color)
        addBorder(textField: contrasenaTextField!, border_color: border_color)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func iniciarSesion(){
        
        //Si no rellena todos los campos
        guard let email = emailTextField!.text, let contrasena = contrasenaTextField!.text else {
            self.mensajeError?.text = "Introduce usuario y contraseña"
            return
        }
        
        //Autenticar usuario
        Auth.auth().signIn(withEmail: email, password: contrasena, completion: { (user, error) in
            
            if let error = error {
                print(error)
                self.mensajeError?.text = "Error o contraseña no válidos"
                return
            }
            
            //Inicio de sesion correcto -> Mostrar menu
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
