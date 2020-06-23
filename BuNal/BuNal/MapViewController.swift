//
//  SearchViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    var stationName = NSMutableString()

    @IBAction func SegmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            locationManager.startUpdatingLocation()
        }
        else if sender.selectedSegmentIndex == 1 {
            setAnnotation(latiValue: locationY.doubleValue, longtiValue: locationX.doubleValue, delta: 0.1, title: String(stationName), subtitle: "정류장")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mapView.delegate = self
        
        // print("\(locationX) , \(locationY)")
        
        setAnnotation(latiValue: locationY.doubleValue, longtiValue: locationX.doubleValue, delta: 0.1, title: String(stationName), subtitle: "정류장")
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func goLocation(latiValue: CLLocationDegrees, longtiValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latiValue, longtiValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        
        mapView.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    func setAnnotation(latiValue: CLLocationDegrees, longtiValue: CLLocationDegrees,
                       delta span: Double, title strTitle: String, subtitle strSubTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latiValue: latiValue, longtiValue: longtiValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func showDirection(_ sender: Any) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 37.341237 , longitude: locationManager.location?.coordinate.longitude ?? 126.732894 )))
        source.name = "출발지"
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locationY.doubleValue, longitude: locationX.doubleValue)))
        destination.name = "도착지"
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: launchOptions)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latiValue: (pLocation?.coordinate.latitude)!,
                       longtiValue: (pLocation?.coordinate.longitude)!,
                   delta: 0.01)
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {(placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address: String = ""
            if country != nil {
                address = country!
            }
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
        })
        locationManager.stopUpdatingLocation()
    }

}
