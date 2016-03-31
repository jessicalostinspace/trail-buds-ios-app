//
//  SingleEventViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import MapKit

class SingleEventViewController: UIViewController, MKMapViewDelegate{
    
    var delegate: goBackProtocol?
    var eventInfoReceivedFromAllEventsViewController: AnyObject?
    
    @IBOutlet var collectionView: [UICollectionView]!
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
        eventInfoReceivedFromAllEventsViewController = nil
        delegate?.goBack()
    }

    @IBOutlet weak var singleEventScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---------------------------")
        print("---------------------------")
        print(eventInfoReceivedFromAllEventsViewController!)
        print(eventInfoReceivedFromAllEventsViewController!.value["hikeLocation"] as! String)
        print(eventInfoReceivedFromAllEventsViewController!.value["createdBy"] as! String)
        print("---------------------------")
        print("---------------------------")
        
        
        singleEventScrollView.contentSize.height = 1500
        
        
        let latitudeAsDouble = eventInfoReceivedFromAllEventsViewController!.value["latitude"] as! Double
        let longitudeAsDouble = eventInfoReceivedFromAllEventsViewController!.value["longitude"] as! Double


        
        let longitude = CLLocationDegrees(longitudeAsDouble)
        let latitude = CLLocationDegrees(latitudeAsDouble)
//
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        
        self.mapView.addAnnotation(annotation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
