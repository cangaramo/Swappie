//
//  User.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

class Usuario: NSObject {
    var nombre: String?
    var email: String?
    var descripcion: String?
    var genero: String?
    var ubicacion: String?
    var imagen: String?
    var id: String?
    
    override init(){
        
    }
    
    init(dictionary: [AnyHashable: Any]) {
        self.nombre = dictionary["nombre"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.descripcion = dictionary["descripcion"] as? String ?? ""
        self.genero = dictionary["genero"] as? String ?? ""
        self.ubicacion = dictionary["ubicacion"] as? String ?? ""
        self.imagen = dictionary["imagen"] as? String ?? ""
    }
}
