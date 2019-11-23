//
//  WelcomeController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import UIKit
import Firebase

class BienvenidoController: ViewController{
    
    @IBOutlet var iniciarSesionButton:UIButton?
    @IBOutlet var registrarseButton:UIButton?
    
    override func viewDidLoad(){
        
        //Añadir acciones
        iniciarSesionButton!.addTarget(self, action: #selector(irAIniciarSesion), for: .touchUpInside)
        registrarseButton!.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)
        
        //Navigation controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        //Comprobar si el usuario esta loggeado
        checkIfUserIsLoggedIn()
    }
    
    //Comprobar usuario
    func checkIfUserIsLoggedIn() {
        //Si no existe usuario -> Mostrar pantalla de Login/Register
        if Auth.auth().currentUser?.uid == nil {
        }
        //Si existe -> Mostrar menu
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabMenu = (storyboard.instantiateViewController(withIdentifier: "tabMenu") as? UITabBarController) {
                self.present(tabMenu, animated: true, completion: nil)
            } 
        }
    }
    
    //Iniciar sesion
    @objc func irAIniciarSesion(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let iniciarSesionController = storyboard.instantiateViewController(withIdentifier :"iniciarSesionController") as! IniciarSesionController

        let navController = UINavigationController(rootViewController: iniciarSesionController)
        present(navController, animated: true, completion: nil)
    }
    
    //Registrarse
    @objc func irARegistro(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registroController = storyboard.instantiateViewController(withIdentifier :"registroController") as! RegistroController
        
        let navController = UINavigationController(rootViewController: registroController)
        present(navController, animated: true, completion: nil)
        
    }
    
}
