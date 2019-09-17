//
//  PerfilHeader.swift
//  TFM
//
//  Created by Clarisa Angaramo on 04/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

class PerfilHeder: UICollectionReusableView {
    
    @IBOutlet var nombreLabel:UILabel?
    @IBOutlet var perfilImageView:UIImageView?
    @IBOutlet var ubicacionLabel:UILabel?
    @IBOutlet var descripcionLabel:UILabel?
    @IBOutlet var perfilView:UIView?
    @IBOutlet var numeroProductos:UILabel?
    
    var usuario:Usuario? {
        
        didSet{
            
            
            if (usuario!.imagen != "") {
                self.perfilImageView?.loadImageUsingCacheWithUrlString(usuario!.imagen!)
            }
            if (usuario!.nombre != "") {
                self.nombreLabel!.text = usuario?.nombre
            }
            if (usuario!.ubicacion != "") {
                self.ubicacionLabel!.text = usuario!.ubicacion
            }
            if (usuario!.descripcion != "") {
                self.descripcionLabel!.text = usuario!.descripcion
                print (usuario!.descripcion)
            }
        }
    }
    
  
    func getHeaderHeight() -> CGFloat{
        
        let labelHeight = descripcionLabel?.frame.height
                
        let headerHeight = CGFloat (180 + labelHeight!)
        print (headerHeight)
        return headerHeight
    }
    
    
}
