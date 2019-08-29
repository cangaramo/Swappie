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
        print ("registrar usuario")
        
        //Get text fields
        guard let email = emailTextField!.text,
            let password = contrasenaTextField!.text,
            let name = nombreTextField!.text else {
                print("Form is not valid")
                return
        }
        
        //Crear usuario
        Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
            
            if let error = error {
                print(error)
                return
            }
            guard let uid = res?.user.uid else {
                return
            }
            
            let values = ["name": name, "email": email]
            
            //successfully authenticated user
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print(err)
                    return
                }
                //let user = User(dictionary: values)
                //self.messagesController?.setupNavBarWithUser(user)
                //self.messagesController?.fetchUserAndSetupNavBarTitle()
                //self.messagesController?.navigationItem.title = values["name"] as? String
                //self.dismiss(animated: true, completion: nil)
            
                /*
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let productosController = storyboard.instantiateViewController(withIdentifier :"productosController") as! ProductosController
                
                self.present(productosController, animated: true, completion: nil) */
                
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
