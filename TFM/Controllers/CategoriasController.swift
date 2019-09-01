//
//  CategoriasController.swift
//  TFM
//
//  Created by Clarisa Angaramo on 10/08/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit

class CategoriasController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var firstArray = ["Vaqueros", "Camisetas", "Sudaderas"]
    var secondArray = ["Camisetas", "Pantalones", "Faldas", "Zapatos", "Accesorios", "Vestidos"]
    var segmentedControlIndex = 0
    
    @IBOutlet var tableView: UITableView?
  //  @IBOutlet var segmentedControl: UISegmentedControl?
    
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
        didSet{
            interfaceSegmented.setButtonTitles(buttonTitles: ["Mujer","Hombre"])
            interfaceSegmented.selectorViewColor = UIColor(rgb: 0xEA9085)
            interfaceSegmented.selectorTextColor = UIColor(rgb: 0xEA9085)

            
            interfaceSegmented.Test = self.Test

            
        }
    }
    
    @objc func hasChanged(){
        print ("has changed")
    }
    
    func Test(){
        print ("test")
        segmentedControlIndex = interfaceSegmented.selectedIndex
        
        print (interfaceSegmented.selectedIndex)
        tableView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        /*
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50), buttonTitle: ["OFF","HTTP","AUTO"])
        codeSegmented.backgroundColor = .clear
        view.addSubview(codeSegmented)*/
        
        /*
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true */
        //self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if (segmentedControl?.selectedSegmentIndex == 1) {
        if (segmentedControlIndex == 1){
            return firstArray.count
        }
        else {
            return secondArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UITableViewCell
        
        //if (segmentedControl?.selectedSegmentIndex == 1) {
        if (segmentedControlIndex == 1){
            cell.textLabel!.text = firstArray[indexPath.row]
        }
        else {
            cell.textLabel!.text = secondArray[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("Selected")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productosController = storyboard.instantiateViewController(withIdentifier :"productosController") as! ProductosController
        self.navigationController?.pushViewController(productosController, animated: true)
    }
    
    @IBAction func changed(){
        tableView?.reloadData()
    }
    
}
