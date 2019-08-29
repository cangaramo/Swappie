//
//  PerfilController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

import UIKit

class MiPerfilController: UIViewController {
    
    var user:Usuario? {
        
        didSet{
            print ("user gurdado")
            print (user!.nombre)
        }
    }
    
    override func viewDidLoad() {
        print("Welcome")
    }
    
}
