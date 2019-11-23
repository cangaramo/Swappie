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
    @IBOutlet var ubicacionIcono:UIImageView?
    
    var usuario:Usuario? {
        
        didSet{
            
            if (usuario!.imagen != "") {
                self.perfilImageView?.loadImageUsingCacheWithUrlString(usuario!.imagen!)
            }
            if (usuario!.nombre != "") {
                self.nombreLabel!.text = usuario?.nombre
            }
            
            //Ubicacion
            if (usuario!.ubicacion != "") {
                self.ubicacionIcono?.isHidden = false
                self.ubicacionLabel!.isHidden = false
                self.ubicacionLabel!.text = usuario!.ubicacion
            }
            else {
                self.ubicacionIcono?.isHidden = true
                self.ubicacionLabel!.isHidden = true
            }
            
            //Descripcion
            if (usuario!.descripcion != "") {
                self.descripcionLabel?.isHidden = false
                self.descripcionLabel!.text = usuario!.descripcion
            }
            else {
                self.descripcionLabel?.isHidden = true
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
