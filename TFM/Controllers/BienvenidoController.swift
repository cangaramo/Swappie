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
        iniciarSesionButton!.addTarget(self, action: #selector(irAIniciarSesion), for: .touchUpInside)
        registrarseButton!.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)
    }
    
    @objc func irAIniciarSesion(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let iniciarSesionController = storyboard.instantiateViewController(withIdentifier :"iniciarSesionController") as! IniciarSesionController

        let navController = UINavigationController(rootViewController: iniciarSesionController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func irARegistro(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registroController = storyboard.instantiateViewController(withIdentifier :"registroController") as! RegistroController
        
        let navController = UINavigationController(rootViewController: registroController)
        present(navController, animated: true, completion: nil)
        
    }
    
}
