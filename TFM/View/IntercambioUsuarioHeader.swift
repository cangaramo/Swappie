//
//  IntercambioHeader.swift
//  TFM
//
//  Created by Clarisa Angaramo on 04/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class IntercambioUsuarioHeder: UICollectionReusableView {
 
    @IBOutlet var usuarioLabel:UILabel?
    @IBOutlet var usuarioImageView:UIImageView?
    @IBOutlet var anyadirProductoButton:UIButton?
    
    var usuario_id:String? {
        
        didSet {
            
            Database.database().reference().child("usuarios").child(usuario_id!)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            let usuario = Usuario(dictionary: dictionary)
                            self.usuarioLabel!.text = usuario.nombre
                            
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
