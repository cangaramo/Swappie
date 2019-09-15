//
//  ProductoCell.swift
//  TFM
//
//  Created by Clarisa Angaramo on 28/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProductoCell: UICollectionViewCell {
    
    @IBOutlet var marcaLabel:UILabel?
    @IBOutlet var tallaLabel:UILabel?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var borrarButton: UIButton?
    
    @IBOutlet var containerView: UIView?
    @IBOutlet var intercambiadoView: UIView?
    @IBOutlet var checkImageView: UIImageView?
    
    var producto:Producto? {
        
        didSet{
            
            self.marcaLabel!.text = producto!.marca
            self.tallaLabel!.text = "Talla " + producto!.talla!
            self.imageView?.loadImageUsingCacheWithUrlString(producto!.imagen1!)
        }
    }
    
}

