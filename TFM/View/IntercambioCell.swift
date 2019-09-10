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
            
           // self.usuario1Label!.text = intercambio!.usuario1
            self.estadoLabel!.text = intercambio!.estado
            
            print ("intercambiooooo")
            print (intercambio!.estado!)
            if (intercambio!.estado! == "Aceptado"){
                self.estadoLabel?.superview!.backgroundColor = UIColor(rgb:0x5446d9)
            }
            if (intercambio!.estado! == "Cancelado"){
                self.estadoLabel?.superview!.backgroundColor = UIColor(rgb:0xf45b55)
            }
            if (intercambio!.estado! == "Pendiente") {
                self.estadoLabel?.superview!.superview!.backgroundColor = UIColor(rgb:0xd5d3f2)
            }
            
            //Find user
            let usuario_id = intercambio!.con_usuario
            
            Database.database().reference().child("usuarios").child(usuario_id!)
                .observeSingleEvent(
                    of: .value,
                    with: {
                        (snapshot) in
                        print (snapshot)
                        
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

