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
    var categoria:String?
    var genero:String?
    var estado: String?
    var latitud: String?
    var longitud: String?
    var imagen1: String?
    var imagen2: String?
    var imagen3: String?
    var usuario: String?
    var id: String?
    var intercambiado: Int?
    
    init(dictionary: [AnyHashable: Any]) {
        self.titulo = dictionary["titulo"] as? String
        self.descripcion = dictionary["descripcion"] as? String
        self.marca = dictionary["marca"] as? String
        self.talla = dictionary["talla"] as? String
        self.categoria = dictionary["categoria"] as? String
        self.genero = dictionary["genero"] as? String
        self.estado = dictionary["estado"] as? String
        self.latitud = dictionary["latitud"] as? String
        self.longitud = dictionary["longitud"] as? String
        self.imagen1 = dictionary["imagen1"] as? String
        self.imagen2 = dictionary["imagen2"] as? String
        self.imagen3 = dictionary["imagen3"] as? String
        self.usuario = dictionary["usuario"] as? String
        self.intercambiado = dictionary["intercambiado"] as? Int
    }
}
