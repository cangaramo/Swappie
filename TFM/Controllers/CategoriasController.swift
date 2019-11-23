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
    
    var categoriasMujer = [Categoria]()
    var categoriasHombre = [Categoria]()
    
    var segmentedControlIndex = 0
    
    @IBOutlet var tableView: UITableView?
    
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["Mujer","Hombre"])
            interfaceSegmented.selectorViewColor = UIColor(rgb: 0x5446d9)
            interfaceSegmented.selectorTextColor = UIColor(rgb: 0x5446d9)
            interfaceSegmented.CambiarSegmento = self.cambiarSegmento
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //Obtener categorias
        observeCategoriasMujer()
        observeCategoriasHombre()
    }
    
    //Categorias hombre
    func observeCategoriasHombre() {
        
        let ref = Database.database().reference().child("categorias").child("hombre")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let categoriaId = snapshot.key
            let categoriasReference = ref.child(categoriaId)
            
            categoriasReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let categoria = Categoria(dictionary: dictionary)
                     categoria.categoriaID = categoriaId
                    
                    //Añadir a array categorias Hombre
                    self.categoriasHombre.append(categoria)
                    
                    //Configurar timer
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    //Categorias mujer
    func observeCategoriasMujer() {
        
        let ref = Database.database().reference().child("categorias").child("mujer")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let categoriaId = snapshot.key
            let categoriasReference = ref.child(categoriaId)
            
            categoriasReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let categoria = Categoria(dictionary: dictionary)
                    categoria.categoriaID = categoriaId
                    
                    //Añadir a array categorias Mujer
                    self.categoriasMujer.append(categoria)
    
                    //Configurar timer
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    var timer: Timer?
    @objc func handleReloadTable() {
        //Llamar a la funcion en el hilo principal
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
        })
    }
    

    //Actualizar tabla con el genero correspondiente
    func cambiarSegmento(){
        segmentedControlIndex = interfaceSegmented.selectedIndex
        tableView?.reloadData()
    }
    
    
    /* Table view */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        var categoria_id = ""
        
        if (segmentedControlIndex == 0){
            genero = "mujer"
            //Obtener categoria
            let categoria = categoriasMujer[indexPath.row]
            categoria_id = categoria.categoriaID!
        }
        else {
            genero = "hombre"
            //Obtener categoria
            let categoria = categoriasHombre[indexPath.row]
            categoria_id = categoria.categoriaID!
        }
        
        
        //Ir a productos
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productosController = storyboard.instantiateViewController(withIdentifier :"productosController") as! ProductosController
        productosController.categoria_seleccionada = categoria_id
        productosController.genero_seleccionado = genero
        self.navigationController?.pushViewController(productosController, animated: true)
    }
    
    
}
