//
//  SubirProducto+Localizacion.swift
//  TFM
//
//  Created by Clarisa Angaramo on 17/11/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation

/* LOCALIZACION */

extension SubirProductoController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        latitud_producto = String(locValue.latitude)
        longitud_producto = String(locValue.longitude)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            //Mostrar alerta para activar permisos
            subirProductoButton?.isEnabled = false
            subirProductoButton?.backgroundColor = UIColor(rgb:0xC9CCD1)
            mostrarMensaje()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        }
        
    }
    
    func mostrarMensaje(){
        let alertController = UIAlertController(title: "Es necesario activar permisos de Localización", message:
            "Se necesitan permisos de Localización para publicar un producto", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
