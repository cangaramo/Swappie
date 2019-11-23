//
//  TabbarController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import Firebase

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //1. Productos
        let productosNavigationController = storyboard.instantiateViewController(withIdentifier :"productosNavigationController") as! UINavigationController
        productosNavigationController.tabBarItem.title = ""
        productosNavigationController.tabBarItem.image = UIImage(named:"search")
        
        //2. Perfil
        let miPerfilNavigationController = storyboard.instantiateViewController(withIdentifier :"miPerfilNavigationController") as! UINavigationController
        miPerfilNavigationController.tabBarItem.title = ""
        miPerfilNavigationController.tabBarItem.image = UIImage(named:"profile")
        
        //3. Subir productos (action item)
        let subirProductosController = storyboard.instantiateViewController(withIdentifier :"subirProductosController") as! SubirProductoController
        subirProductosController.tabBarItem.title = ""
        subirProductosController.tabBarItem.image = UIImage(named:"new")
        
        //4. Intercambios
        let intercambiosNavigationController = storyboard.instantiateViewController(withIdentifier :"intercambiosNavigationController") as! UINavigationController
        intercambiosNavigationController.tabBarItem.image = UIImage(named:"exchange")
        
        //5. Mensajes
        let mensajesNavigationController = storyboard.instantiateViewController(withIdentifier :"mensajesNavigationController") as! UINavigationController
        mensajesNavigationController.tabBarItem.image = UIImage(named:"messages")

        //Tab Bar
        viewControllers = [productosNavigationController, intercambiosNavigationController, subirProductosController, mensajesNavigationController, miPerfilNavigationController ]
        for tabBarItem in tabBar.items! {
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //Mostrar Subir Productos como acción (OVER FULL SCREEN)
        if viewController.isKind(of: SubirProductoController.self) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier :"subirProductoNavigation") as! UINavigationController
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
}
