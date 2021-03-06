//
//  IntercambioCell.swift
//  TFM
//
//  Created by Clarisa Angaramo on 06/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class IntercambioCell: UITableViewCell {
    
    @IBOutlet var usuario1Label:UILabel?
    @IBOutlet var usuarioImageView:UIImageView?
    @IBOutlet var estadoLabel:UILabel?
    
    var intercambio:Intercambio? {
        
        didSet{
            
            self.estadoLabel!.text = intercambio!.estado
            
            if (intercambio!.estado! == "Aceptado" || intercambio!.estado! == "Realizado"){
                self.estadoLabel?.superview!.backgroundColor = UIColor(rgb:0x5446d9)
            }
            else if (intercambio!.estado! == "Cancelado"){
                self.estadoLabel?.superview!.backgroundColor = UIColor(rgb:0xf45b55)
            }
            else if (intercambio!.estado! == "Pendiente") {
                self.estadoLabel?.superview!.superview!.backgroundColor = UIColor(rgb:0xd5d3f2)
            }
            
            //Find user
            let usuario_id = intercambio!.con_usuario
            
            Database.database().reference().child("usuarios").child(usuario_id!)
                .observeSingleEvent(
                    of: .value,
                    with: {
                        (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            let usuario = Usuario(dictionary: dictionary)
                            self.usuario1Label!.text = usuario.nombre
                            
                            if (usuario.imagen != "") {
                                self.usuarioImageView!.loadImageUsingCacheWithUrlString(usuario.imagen!)
                            }
                            else {
                                self.usuarioImageView!.image = UIImage(named:"avatar")
                            }
                            
                        }
                        
                },
                    withCancel: nil
            )
        }
    }
    
}

