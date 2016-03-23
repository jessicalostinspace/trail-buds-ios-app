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
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
        delegate?.goBack()
    }

    @IBOutlet weak var singleEventScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2DMake(46.852886, -121.760374)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        
        singleEventScrollView.contentSize.height = 1000


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
