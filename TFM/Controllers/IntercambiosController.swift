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
    @IBOutlet var mensajeView:UIView?
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        mensajeView?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        obtenerIntercambios()
    }
    
    /* Obtener intercambios */
    func obtenerIntercambios(){
        
        intercambios = [Intercambio]()
        let usuario_actual = Auth.auth().currentUser!.uid
        
        let refIntercambios = Database.database().reference().child("usuarios-intercambios")
        
        refIntercambios.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //El usuario tiene intercambios
            if (snapshot.hasChild(usuario_actual)) {
                
                let refIntercambioUsuario = Database.database().reference().child("usuarios-intercambios").child(usuario_actual)
                
                refIntercambioUsuario.observe(.childAdded, with: { (snapshot) in
                    
                    let intercambio_id = snapshot.key
                    let intercambio_values = snapshot.value as! [AnyHashable : Any]
                    
                    let intercambio = Intercambio(dictionary: intercambio_values)
                    intercambio.id = intercambio_id
                    
                    self.intercambios.append(intercambio)
         
                    //Configurar timer
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                }, withCancel: nil)
            }
            
            //El usuario no tiene intercambios
            else {
                if (self.intercambios.isEmpty) {
                    self.mensajeView?.isHidden = false
                }
            }
            
        }, withCancel: nil)
    
        
    }
    
    /* Table view */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intercambios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let intercambio = intercambios[indexPath.item]
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
        detailIntercambioController.usuario_other = newUsuario.id
        detailIntercambioController.intercambioId = intercambio.id
        
         navigationController?.pushViewController(detailIntercambioController,animated: true)
    }
    
    
    var timer: Timer?
    
    @objc func handleReloadTable () {
        //Hilo principal
        DispatchQueue.main.async(execute: {
            self.tableView!.reloadData()
        })
    }
    
}
