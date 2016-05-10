//
//  ViewController.swift
//  Accessibility
//
//  Created by Gaurav Ragtah on 5/5/16.
//  Copyright © 2016 Gaurav Ragtah. All rights reserved.
//

import UIKit

import CoreLocation
import MapKit

import Foundation
//import CoreFoundation
//
//class ParkBenchTimer {
//    
//    let startTime:CFAbsoluteTime
//    var endTime:CFAbsoluteTime?
//    
//    init() {
//        startTime = CFAbsoluteTimeGetCurrent()
//    }
//    
//    func stop() -> CFAbsoluteTime {
//        endTime = CFAbsoluteTimeGetCurrent()
//        
//        return duration!
//    }
//    
//    var duration:CFAbsoluteTime? {
//        if let endTime = endTime {
//            return endTime - startTime
//        } else {
//            return nil
//        }
//    }
//}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var theLabel: UILabel!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()    //popup on iOS device for location-access permission
        manager.startUpdatingLocation()
        
        //Setup our Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.Standard   //Satellite, MKMapType.Standard, MKMapType.Hybrid
        theMap.showsUserLocation = true
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
    
//        let timer = ParkBenchTimer()

        var t = clock()
        
        theLabel.text = "\(locations[0])"
        myLocations.append(locations[0] )
        
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap.addOverlay(polyline)
        }
        
      
        
        t = clock() - t
        
        print("The function takes \(t) ticks, which is \(Double(t) / Double(CLOCKS_PER_SEC)) seconds of CPU time")
//        print("The task took \(timer.stop()) seconds.")
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

