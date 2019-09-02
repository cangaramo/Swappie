//
//  PerfilController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class MiPerfilController: UIViewController {
    
    var usuario:Usuario?
    @IBOutlet var perfilImageView: UIImageView?
    @IBOutlet var perfilLabel: UILabel?
    @IBOutlet var emailLabel: UILabel?
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Obtener usuario actual
        if let current_user_id =  Auth.auth().currentUser?.uid {
            
            //Obtener la info del usuario
            let ref = Database.database().reference().child("usuarios").child(current_user_id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    //Crear usuario
                    print (dictionary)
                    self.usuario = Usuario(dictionary: dictionary)
                    self.usuario!.id = snapshot.key
                    
                    //Añadir info
                    self.perfilLabel?.text = self.usuario!.nombre
                    self.emailLabel?.text = self.usuario!.email
                    if (self.usuario!.imagen != "") {
                        self.perfilImageView!.loadImageUsingCacheWithUrlString(self.usuario!.imagen!)
                    }
                
                }
                
            }, withCancel: nil)
        }
    }
    
    override func viewDidLoad() {
        print("Welcome")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    @IBAction func verPerfil(){
        print ("Ver perfil")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usuarioController = storyboard.instantiateViewController(withIdentifier: "usuarioController") as! UsuarioController
        usuarioController.usuario = usuario
        navigationController?.pushViewController(usuarioController,animated: true)
    }
    
    @IBAction func cerrarSesion(){
        print ("Cerrar sesion")
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editarPerfil(){
        print ("editar perfil")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        if let editarPerfil = (storyboard.instantiateViewController(withIdentifier: "editarPerfil") as? EditarPerfilController) {
            editarPerfil.usuario = usuario
            self.present(editarPerfil, animated: true, completion: nil)
        }
        /*
        let usuarioController = storyboard.instantiateViewController(withIdentifier: "editarPerfil") as! EditarPerfilController
        usuarioController.usuario = usuario
        navigationController?.pushViewController(usuarioController,animated: true)*/
        
    }
    
}
