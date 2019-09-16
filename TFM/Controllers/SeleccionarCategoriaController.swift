//
//  seleccionarCategoriaController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 02/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SeleccionarCategoriaController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var categoriasMujer = [Categoria]()
     var categoriasHombre = [Categoria]()
    
    var segmentedControlIndex = 0
    
    var seleccionarCategoria : ( (String, String, String) -> Void)?
    
    @IBOutlet var tableView: UITableView?
    //  @IBOutlet var segmentedControl: UISegmentedControl?
    
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["Mujer","Hombre"])
            interfaceSegmented.selectorViewColor = UIColor(rgb: 0xf45b55)
            interfaceSegmented.selectorTextColor = UIColor(rgb: 0xf45b55)
            interfaceSegmented.Test = self.cambiarGenero
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        observeCategoriasMujer()
        observeCategoriasHombre()
    }
    
    //Categorias hombre
    func observeCategoriasHombre() {
        
        //Buscamos ese usuario en Categorias mujer
        let ref = Database.database().reference().child("categorias").child("hombre")
        
        //Loop categorias
        ref.observe(.childAdded, with: { (snapshot) in
            
            //Cogemos la categoria
            let categoriaId = snapshot.key
            let categoriasReference = ref.child(categoriaId)
            
            //Single
            categoriasReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let categoria = Categoria(dictionary: dictionary)
                    categoria.categoriaID = snapshot.key
                    
                    self.categoriasHombre.append(categoria)
                    
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    //Categorias mujer
    func observeCategoriasMujer() {
        
        //Buscamos ese usuario en Categorias mujer
        let ref = Database.database().reference().child("categorias").child("mujer")
        
        //Loop mensaje
        ref.observe(.childAdded, with: { (snapshot) in

            
            //Cogemos la categoria
            let categoriaId = snapshot.key
            let categoriasReference = ref.child(categoriaId)
            
            //Single
            categoriasReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let categoria = Categoria(dictionary: dictionary)
                    categoria.categoriaID = snapshot.key
                    
                    self.categoriasMujer.append(categoria)
                    
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        DispatchQueue.main.async(execute: {
            print("we reloaded the table")
            self.tableView?.reloadData()
        })
    }
    
    
    func cambiarGenero(){
        segmentedControlIndex = interfaceSegmented.selectedIndex
        tableView?.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if (segmentedControl?.selectedSegmentIndex == 1) {
        if (segmentedControlIndex == 0){
            return categoriasMujer.count
        }
        else {
            return categoriasHombre.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SeleccionarCategoriaCell
        
        if (segmentedControlIndex == 0){
            let categoria = categoriasMujer[indexPath.row]
            cell.categoria = categoria
        }
        else {
            let categoria = categoriasHombre[indexPath.row]
            cell.categoria = categoria
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Genero y categorias
        if (segmentedControlIndex == 0){
            let genero = "mujer"
            let categoria = categoriasMujer[indexPath.row]
            self.seleccionarCategoria!(categoria.categoriaID!, categoria.nombre!, genero)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let genero = "hombre"
            let categoria = categoriasHombre[indexPath.row]
            self.seleccionarCategoria!(categoria.categoriaID!, categoria.nombre!, genero)
            self.navigationController?.popViewController(animated: true)
        }
    
        
    }
    
    @IBAction func changed(){
        tableView?.reloadData()
    }
}
