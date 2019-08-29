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

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        //Seleccionar "Perfil" en menu
        if (self.selectedIndex == 2) {
            
            print ("2")
            //
            
            //Obtener usuario actual
            if let current_user_id =  Auth.auth().currentUser?.uid {
                
                //Obtener la info del usuario
                let ref = Database.database().reference().child("users").child(current_user_id)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        //Crear usuario
                        let current_user = User(dictionary: dictionary)
                        current_user.id = current_user_id
                        
                        //Pasar usuario al PerfilController
                        let perfilTab = self.viewControllers![2] as! PerfilController
                        perfilTab.user = current_user
                      
                        
                       // let navController = UINavigationController(rootViewController: registroController)
                        //present(navController, animated: true, completion: nil)
                    }
                    
                }, withCancel: nil)
            }
        }

    }
    
}
