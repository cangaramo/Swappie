//
//  ProductosController+Location.swift
//  TFM
//
//  Created by Clarisa Angaramo on 19/09/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ProductosController: CLLocationManagerDelegate {
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            //Mostrar alerta
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            mostrarMensaje()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .restricted: 
            break
        case .authorizedAlways:
            break
        }
        
    }
    
    func mostrarMensaje(){
        let alertController = UIAlertController(title: "Es necesario activar permisos de Localización", message:
            "Se necesitan permisos de Localización para buscar productos cerca de ti", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        latitud_usuario = String(locValue.latitude)
        longitud_usuario = String(locValue.longitude)
    }
}
