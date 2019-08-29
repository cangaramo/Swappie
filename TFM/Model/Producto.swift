//
//  Producto.swift
//  TFM
//
//  Created by Clarisa Angaramo on 28/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

class Producto: NSObject {
    var titulo: String?
    var descripcion: String?
    var marca: String?
    var talla:String?
    var imagen1: String?
    var imagen2: String?
    var imagen3: String?
    var usuario: String?
    var id: String?
    
    init(dictionary: [AnyHashable: Any]) {
        self.titulo = dictionary["titulo"] as? String
        self.descripcion = dictionary["descripcion"] as? String
        self.marca = dictionary["marca"] as? String
        self.talla = dictionary["talla"] as? String
        self.imagen1 = dictionary["imagen1"] as? String
        self.imagen2 = dictionary["imagen2"] as? String
        self.imagen3 = dictionary["imagen3"] as? String
        self.usuario = dictionary["usuario"] as? String
    }
}
