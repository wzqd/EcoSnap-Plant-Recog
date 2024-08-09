//
//  LocationManager.swift
//  PlantRecognition
//
//  Created by wzqd on 2024/8/9.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit



class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    
    var span: CLLocationDegrees = 0.01
    
    
    override init() {
        super.init()
        print("init jhere")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
}

