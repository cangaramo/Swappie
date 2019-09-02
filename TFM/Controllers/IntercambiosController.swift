//
//  IntercambiosController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 05/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class IntercambiosController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var intercambios = [Intercambio]()
    
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        //obtenerIntercambios()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        obtenerIntercambios()
    }
    
    /*
    @IBAction func abrirIntercambio (){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailIntercambioController = storyboard.instantiateViewController(withIdentifier: "intercambioController") as! DetailIntercambioController
        
        //Pasar parametros
        let newUsuario = Usuario()
        newUsuario.id = "IutcS1G3ReWDQ1DeD2kHnC60A4K2"
        detailIntercambioController.usuario = newUsuario
        detailIntercambioController.intercambioId = "-LlYJSxjUYBBrvqYkfqk"
        
        
        navigationController?.pushViewController(detailIntercambioController,animated: true)
    }*/
    
    func obtenerIntercambios(){
        
        intercambios = [Intercambio]()
        
        let usuario_actual = Auth.auth().currentUser!.uid
        
        let refIntercambio = Database.database().reference().child("usuarios-intercambios").child(usuario_actual)
        
        
        refIntercambio.observe(.childAdded, with: { (snapshot) in
            
            let intercambio_id = snapshot.key
            let intercambio_values = snapshot.value as! [AnyHashable : Any]
            //let intercambio = Intercambio()
            let intercambio = Intercambio(dictionary: intercambio_values)
            
            
            //cambiar
            //let usuario_id = snapshot.value
            /*
            let miintercambio = snapshot.value as? [String: AnyObject]
            let usuario_id = miintercambio!["con_usuario"] as Any
            */
            
            intercambio.id = intercambio_id
            
            /*
            intercambio.con_usuario = usuario_id as! String
            intercambio.estado = "Pendiente" */
            
            print (intercambio)
            self.intercambios.append(intercambio)
            
            DispatchQueue.main.async(execute: {
                print (self.intercambios.count)
                print ("count")
                self.tableView!.reloadData()
            })
            
        }, withCancel: nil)
        
    }
    
    /* Table view */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intercambios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("table")
        let intercambio = intercambios[indexPath.item]
        print (intercambio)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId5", for: indexPath) as! IntercambioCell
        cell.intercambio = intercambio
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let intercambio = intercambios[indexPath.item]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailIntercambioController = storyboard.instantiateViewController(withIdentifier: "intercambioController") as! DetailIntercambioController
        
        //Pasar parametros
        let newUsuario = Usuario()
        newUsuario.id = intercambio.con_usuario
        //detailIntercambioController.usuario = newUsuario
        detailIntercambioController.usuario_other = newUsuario.id
        detailIntercambioController.intercambioId = intercambio.id
        
         navigationController?.pushViewController(detailIntercambioController,animated: true)
        
    }
    
 
}
