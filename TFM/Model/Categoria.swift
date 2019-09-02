//
//  Categoria.swift
//  TFM
//
//  Created by Clarisa Angaramo on 02/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

class Categoria: NSObject {
    var nombre: String?
    var imagen: String?
    var categoriaID:String?
    
    init(dictionary: [AnyHashable: Any]) {
        self.nombre = dictionary["titulo"] as? String
        self.imagen = dictionary["imagen"] as? String
        self.categoriaID = dictionary["categoria"] as? String
    }
}
