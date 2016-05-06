//
//  SingleEventViewController.swift
//  TrailBuds
//
//  Created by Jessica Wilson on 3/17/16.
//  Copyright © 2016 Garik Kosai. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire

class SingleEventViewController: UIViewController, MKMapViewDelegate{
    
    //MARK: Attributes
    
    var delegate: goBackProtocol?
    var eventInfoReceivedFromAllEventsViewController: AnyObject?
    
    @IBOutlet weak var eventMainImage: UIImageView!
    @IBOutlet weak var trailNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationGainLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostPicture: UIImageView!
    @IBOutlet weak var forecastIconImage: UIImageView!
    @IBOutlet weak var forecastDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func interestedButtonPressed(sender: UIButton) {
    }
    
    @IBAction func joinButtonPressed(sender: UIButton) {
    }
    
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
        print(eventInfoReceivedFromAllEventsViewController!.value["description"] as! String)
        print(eventInfoReceivedFromAllEventsViewController!.value["elevationGain"] as! String)
        print(eventInfoReceivedFromAllEventsViewController!.value["hikeDistance"] as! String)
        print(eventInfoReceivedFromAllEventsViewController!.value["trailName"] as! String)
        print("---------------------------")
        print("---------------------------")
        
        trailNameLabel.text = eventInfoReceivedFromAllEventsViewController!.value["trailName"] as! String
        locationLabel.text = "Location: \(eventInfoReceivedFromAllEventsViewController!.value["hikeLocation"] as! String)"
        distanceLabel.text = "Distance: \(eventInfoReceivedFromAllEventsViewController!.value["hikeDistance"] as! String) miles"
        elevationGainLabel.text = "Elevation Gain: \(eventInfoReceivedFromAllEventsViewController!.value["elevationGain"] as! String) feet"
        hostNameLabel.text = "Host: \(eventInfoReceivedFromAllEventsViewController!.value["createdByName"] as! String)"
        descriptionLabel.text = "Description: \(eventInfoReceivedFromAllEventsViewController!.value["description"] as! String)"
        
        
        singleEventScrollView.contentSize.height = 2000
        
        
        let latitudeAsDouble = eventInfoReceivedFromAllEventsViewController!.value["latitude"] as! Double
        let longitudeAsDouble = eventInfoReceivedFromAllEventsViewController!.value["longitude"] as! Double


        
        let longitude = CLLocationDegrees(longitudeAsDouble)
        let latitude = CLLocationDegrees(latitudeAsDouble)
//
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)

        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)


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
