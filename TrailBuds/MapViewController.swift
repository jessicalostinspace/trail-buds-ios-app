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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var latitude1: AnyObject?
    var longitude1: AnyObject?
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            print("-----------")
            
            let latitude2 = self.latitude1 as! Double
            let longitude2 = self.longitude1 as! Double
            
            //pinpointing every location on a map
            
            let coordinate = CLLocationCoordinate2DMake(latitude2, longitude2)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
//            annotation.subtitle = subJson["descriptio"].string!
//            annotation.title = subJson["park"].string!
            
            self.mapView.addAnnotation(annotation)
            //end pinpointing every location on a map
        })
        
    } //end of viewDidLoad
}
