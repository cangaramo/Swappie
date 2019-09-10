//
//  MapController.swift
//  
//
//  Created by Clarisa Angaramo on 08/09/2019.
//

import Foundation
import UIKit
import MapKit

class MapController: UIViewController {
    
    @IBOutlet var mapView: MKMapView?
    
    let locationManager = CLLocationManager()
    
    var producto_latitud: Double?
    var producto_longitud: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        showItem()
        
        //fetchStadiumsOnMap()
        
        mapView!.delegate = self
        

    }
    
    func showItem (){
        // 1
        /*
        let location = CLLocationCoordinate2D(latitude: 51.60154930320717,
                                              longitude: -0.10170358233163292) */
        
        let location = CLLocationCoordinate2D(latitude: producto_latitud!,
                                              longitude: producto_longitud!)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView!.setRegion(region, animated: true)
        
        //3
        /*
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView!.addAnnotation(annotation) */
        
        let radius:CLLocationDistance = 500
        showCircle(coordinate: location,
                   radius: radius)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView!.showsUserLocation = true
        case .denied: // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView!.showsUserLocation = true
        case .restricted: // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        }

    }
    
    // Radius is measured in meters
    func showCircle(coordinate: CLLocationCoordinate2D,
                    radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate,
                              radius: radius)
        mapView!.addOverlay(circle)
    }

}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // If you want to include other shapes, then this check is needed.
        // If you only want circles, then remove it.
         let circleOverlay = overlay as? MKCircle
            
            
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay!)
        let purple = UIColor(rgb:0x5446d9)
            circleRenderer.fillColor = purple
            circleRenderer.alpha = 0.1
            
            return circleRenderer
        
        
        
        
        // If other shapes are required, handle them here
    }
}
