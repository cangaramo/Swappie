//
//  CategoriaCell.swift
//  TFM
//
//  Created by Clarisa Angaramo on 02/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

class CategoriaCell: UITableViewCell {
    
    @IBOutlet var categoriaImageView: UIImageView?
    @IBOutlet var categoriaTextLabel: UILabel?

    var categoria:Categoria? {
        
        didSet {
            
            //Message details
            self.categoriaTextLabel?.text = categoria?.nombre
            
            if let imagen = categoria!.imagen {
                if (imagen != "1") {
                    self.categoriaImageView!.loadImageUsingCacheWithUrlString(categoria!.imagen!)
                    
                }
            }

        }
    }

}
