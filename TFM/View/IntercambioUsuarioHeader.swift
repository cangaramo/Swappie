//
//  IntercambioHeader.swift
//  TFM
//
//  Created by Clarisa Angaramo on 04/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

import UIKit

class IntercambioUsuarioHeder: UICollectionReusableView {
 
    @IBOutlet var usuarioLabel:UILabel?
    @IBOutlet var usuarioImageView:UIImageView?
    
    var usuario_id:String? {
        
        didSet {
            self.usuarioLabel!.text = "Usuario"
        }
        
    }
    
}
