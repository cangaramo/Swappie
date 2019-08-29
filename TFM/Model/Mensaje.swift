//
//  Mensaje.swift
//  TFM
//
//  Created by Clarisa Angaramo on 08/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Mensaje: NSObject {
    
    var remitenteId: String?
    var texto: String?
    var fecha: NSNumber?
    var destinatarioId: String?
    
    init(dictionary: [String: Any]) {
        self.remitenteId = dictionary["remitenteId"] as? String
        self.texto = dictionary["texto"] as? String
        self.destinatarioId = dictionary["destinatarioId"] as? String
        self.fecha = dictionary["fecha"] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return remitenteId == Auth.auth().currentUser?.uid ? destinatarioId : remitenteId
    }
}
