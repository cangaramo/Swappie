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
    
    var usuario:Usuario?
    
    var usuario_id:String? {
        
        didSet {
            
            Database.database().reference().child("usuarios").child(usuario_id!)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            self.usuario = Usuario(dictionary: dictionary)
                            self.usuario!.id = snapshot.key
                            print (snapshot.key)
                            self.usuarioLabel!.text = "Productos de " + self.usuario!.nombre!
                            
                            if (self.usuario!.imagen != "") {
                                self.usuarioImageView!.loadImageUsingCacheWithUrlString(self.usuario!.imagen!)
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
