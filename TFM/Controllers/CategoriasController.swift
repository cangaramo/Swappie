//
//  CategoriasController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 10/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CategoriasController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var firstArray = ["Vaqueros", "Camisetas", "Sudaderas"]
    var secondArray = ["Camisetas", "Pantalones", "Faldas", "Zapatos", "Accesorios", "Vestidos"]
    
    var categoriasMujer = [Categoria]()
    var categoriasHombre = [Categoria]()
    
    var segmentedControlIndex = 0
    
    @IBOutlet var tableView: UITableView?
  //  @IBOutlet var segmentedControl: UISegmentedControl?
    
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["Mujer","Hombre"])
            interfaceSegmented.selectorViewColor = UIColor(rgb: 0x5446d9)
            interfaceSegmented.selectorTextColor = UIColor(rgb: 0x5446d9)

            interfaceSegmented.Test = self.Test

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
        
        /*
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true */
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    //Categorias hombre
    func observeCategoriasHombre() {
        
        //Buscamos ese usuario en Categorias mujer
        let ref = Database.database().reference().child("categorias").child("hombre")
        
        //Loop mensaje
        ref.observe(.childAdded, with: { (snapshot) in
            
            //Cogemos la categoria
            let categoriaId = snapshot.key
            
            //Y ahora vamos a MESSAGES
            let categoriasReference = ref.child(categoriaId)
            
            //Single
            categoriasReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let categoria = Categoria(dictionary: dictionary)
                    
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

            //Y ahora vamos a MESSAGES
            let categoriasReference = ref.child(categoriaId)
            
            //Single
            categoriasReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let categoria = Categoria(dictionary: dictionary)
                    categoria.categoriaID = categoriaId
                    
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
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            print("we reloaded the table")
           // print (self.messages)
            self.tableView?.reloadData()
        })
    }
    
    @objc func hasChanged(){
        print ("has changed")
    }
    
    func Test(){
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CategoriaCell
        
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
        
        //Obtener genero
        var genero = ""
        if (segmentedControlIndex == 0){
            genero = "mujer"
        }
        else {
            genero = "hombre"
        }
        
        //Obtener categoria
        let categoria = categoriasMujer[indexPath.row]
        let categoria_id = categoria.categoriaID
        
        //Ir a productos
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productosController = storyboard.instantiateViewController(withIdentifier :"productosController") as! ProductosController
        productosController.categoria_seleccionada = categoria_id
        productosController.genero_seleccionado = genero
        self.navigationController?.pushViewController(productosController, animated: true)
    }
    
    @IBAction func changed(){
        tableView?.reloadData()
    }
    
}
