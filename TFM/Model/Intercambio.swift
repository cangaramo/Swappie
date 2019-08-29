//
//  Intercambio.swift
//  TFM
//
//  Created by Clarisa Angaramo on 06/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

class Intercambio: NSObject {
    var con_usuario: String?
    //var usuario2: String?
    var estado: String?
    var id: String?
    
    override init(){
        
    }
    
    init(dictionary: [AnyHashable: Any]) {
        //self.usuario1 = dictionary["usuario1"] as? String ?? ""
        //self.usuario2 = dictionary["usuario2"] as? String ?? ""
        self.con_usuario = dictionary["con_usuario"] as? String ?? ""
        self.estado = dictionary["estado"] as? String ?? ""
    }
}
