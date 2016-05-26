//
//  MapViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/22/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Alamofire
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var latitude1: AnyObject?
    var longitude1: AnyObject?
    var trailName1: AnyObject?
    var description1: AnyObject?
    let locationMgr = CLLocationManager()
    var mapRegion: MKCoordinateRegion?
    var satelliteBool: Bool?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var satelliteButton: UIBarButtonItem!
    @IBAction func satelliteButtonPressed(sender: UIBarButtonItem) {
        
        
        if satelliteBool == false{
            mapView.mapType = .Hybrid
            satelliteButton.title = "Standard"
            satelliteBool = true
        }
        else{
            mapView.mapType = .Standard
            satelliteButton.title = "Satellite"
            satelliteBool = false
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        satelliteBool = false;
        
        locationMgr.delegate = self
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.startUpdatingLocation()
        
        print("-----------------------------")
        
        // Get a reference to our posts
        var ref = Firebase(url:"https://trailbuds.firebaseio.com/events")
        
        ref.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            if let latitude = snapshot.value.objectForKey("latitude") {
                print(latitude)
                self.latitude1 = latitude
            }
            
            if let longitude = snapshot.value.objectForKey("longitude") {
                print(longitude)
                self.longitude1 = longitude
            }
            
            if let trailName = snapshot.value.objectForKey("trailName") {
                print(trailName)
                self.trailName1 = trailName
            }
            
            if let description = snapshot.value.objectForKey("description") {
                print(description)
                self.description1 = description
            }
            print("-----------")
            
            let latitude2 = self.latitude1 as! Double
            let longitude2 = self.longitude1 as! Double
            let trailName2 = self.trailName1 as! String
            let description2 = self.description1 as! String
            
            //pinpointing every location on a map
            
            let coordinate = CLLocationCoordinate2DMake(latitude2, longitude2)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            annotation.subtitle = description2
            annotation.title = trailName2
            
            self.mapView.addAnnotation(annotation)
//            self.mapView.setRegion(self.mapRegion!, animated: true)
            //end pinpointing every location on a map
        })
    
        
    } //end of viewDidLoad
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        let userCenter = CLLocationCoordinate2DMake(userLocation!.coordinate.latitude, userLocation!.coordinate.longitude)
        
        
        
        // what part of the map is going to show up in the view
        // how zoomed in or zoomed out of our center do we want to be in
        //smaller the delta number, the more zoomed in it will be (1.25 probably see entire city)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        mapRegion = MKCoordinateRegion(center: userCenter, span: mapSpan)
        
        
        mapView.setRegion(mapRegion!, animated: true)
//        locationMgr.stopUpdatingHeading()
    }
    
}
