//
//  ProductosController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 27/07/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class ProductosController: UIViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet var collectionView:UICollectionView?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 5.0,
                                             bottom: 50.0,
                                             right: 5.0)
    
    //Search bar
    @IBOutlet weak var searchBar: UISearchBar!

    
    //Todos los mensajes
    var productos = [Producto]()
    var categoria_seleccionada:String?
    var genero_seleccionado:String?
    
    override func viewDidLoad() {
        print("Productos")
        
        

        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        let light_gray = UIColor(rgb:0xffffff)
        searchBar.backgroundColor = light_gray
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white 
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0, green: 255, blue: 255, alpha: 0)
        /*
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true*/
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
       // textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.backgroundColor = UIColor(rgb:0xf9f9f9)
        
        //textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(12)
        textFieldInsideUISearchBar?.font =  UIFont(name: "Raleway-Regular", size: 14)
        
        print (categoria_seleccionada)
        obtenerProductos()
        
    }
    
    //Start search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    //Cancel search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    //Search button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        //Refresh
        //filtering = false
        //self.listTableView.reloadData()
    }
    
    
    func obtenerProductos() {
        Database.database().reference().child("productos")
            .observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let producto = Producto(dictionary: dictionary)
                    producto.id = snapshot.key
                    
                    //Mostrar solo los que pertenecen a esa categoria
                    if (producto.genero == self.genero_seleccionado){
                        if (producto.categoria == self.categoria_seleccionada || self.categoria_seleccionada == "_todo") {
                            self.productos.append(producto)
                            
                            //Background thread
                            self.timer?.invalidate()
                            print("we just canceled our timer")
                            
                            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                            print("schedule a table reload in 0.1 sec")
                        }
                    }
                    
                }
                
            }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable () {
        DispatchQueue.main.async(execute: {
            self.collectionView!.reloadData()
        })
    }
    
    /* Collection view */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height:250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let producto = productos[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProductoCell
        
        cell.producto = producto
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Detail Producto Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailProductoController = storyboard.instantiateViewController(withIdentifier: "detailProductoController") as! DetailProductoController
        
        //Pasar producto
        let producto = productos[indexPath.item]
        detailProductoController.producto = producto
        navigationController?.pushViewController(detailProductoController,animated: true)
    }
}

// MARK: - Collection View Flow Layout Delegate
/*
extension ProductosController  {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}*/
