//
//  CurrentLocation.swift
//  MachineTestRB
//
//  Created by Ashwini on 01/06/21.
//

import Foundation
import Foundation
import CoreLocation
import MapKit

@objc protocol CurrentLocationDelegate{
    @objc optional func displayAddress(currentAddress:String)
}


class CurrentLocation:NSObject,CLLocationManagerDelegate{
    
    static var currentLocation = CurrentLocation()
    var delegate: CurrentLocationDelegate?
    
    var locationManager:CLLocationManager!

    public func getUserCurrentLocation()
    {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
       
            getAddress(selectedLat: locValue.latitude, selectedLon: locValue.longitude) { (address) in
                self.locationManager.stopUpdatingLocation()
            
            }
    }
    
    // Using closure
    func getAddress(selectedLat:Double,selectedLon:Double,handler: @escaping (String) -> Void)
    {
        
        var address: String = ""
        let geoCoder = CLGeocoder()
 
        let location = CLLocation(latitude: selectedLat, longitude: selectedLon)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
         
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark?.name {
                address += locationName + ", "
            }
            
            // Street address
            if let street = placeMark?.thoroughfare {
                address += street + ", "
            }
            
            // City
            if let city1 = placeMark?.locality {
                address += city1 + ", "
            }
      
            // Zip code
            if let zip = placeMark?.postalCode {
                address += zip + ", "
     
            }
            // Country
            if let country = placeMark?.country{
                address += country
           
            }
         
            
            handler(address)
            if !address.isEmpty{
                self.delegate?.displayAddress?(currentAddress: address)
            
            }
            else{
                self.delegate?.displayAddress?(currentAddress: "Current location not found")
            
            }
            
        })
    }
    
 
    
    
    
}
