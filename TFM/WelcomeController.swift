//
//  WelcomeController.swift
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
        
        guard let email = emailTextField!.text, let password = contrasenaTextField!.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            //successfully logged in our user
            print ("sucess")
            
            //self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            // self.dismiss(animated: true, completion: nil)
            
        })
    }
    
}
