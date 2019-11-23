//
//  DetailProductoController+Mapa.swift
//  TFM
//
//  Created by Clarisa Angaramo on 17/11/2019.
//  Copyright © 2019 Clarisa. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import AlamofireImage
import Firebase
import MapKit

extension DetailProductoController: MKMapViewDelegate {
    
    /* Ir a mapa */
    @objc func mapaTapped(){
        
        if (producto!.latitud != "" && producto!.longitud != "" ){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapController = storyboard.instantiateViewController(withIdentifier: "mapController") as! MapController
            mapController.producto_latitud = Double(producto!.latitud!)
            mapController.producto_longitud = Double(producto!.longitud!)
            navigationController?.pushViewController(mapController,animated: true)
        }
        
    }
    
    /* MAPA - Crear pin customizado */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "marker40")
        }
        
        return annotationView
    }
    
    /* Mostrar mapa - Mostrar ubicacion del producto */
    func showMap (){
        if (producto!.latitud != "" && producto!.longitud != "" ){
            
            let loc_lat = Double(producto!.latitud!)
            let loc_long = Double(producto!.longitud!)
            let location = CLLocationCoordinate2D(latitude: loc_lat!,
                                                  longitude: loc_long!)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView!.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = ""
            annotation.subtitle = ""
            mapView!.addAnnotation(annotation)
        }
        
    }
    
}
