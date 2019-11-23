//
//  SeleccionarCategoriaCell.swift
//  TFM
//
//  Created by Clarisa Angaramo on 02/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

class SeleccionarCategoriaCell: UITableViewCell {
    
    @IBOutlet var categoriaTextLabel: UILabel?
    
    var categoria:Categoria? {
        
        didSet {
            
            self.categoriaTextLabel?.text = categoria?.nombre
            
            if (categoria?.nombre == "Ver todo") {
                self.categoriaTextLabel?.text = "Otro"
            }
            
        }
    }
    
}
