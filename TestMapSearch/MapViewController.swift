//
//  MapViewController.swift
//  TestMapSearch
//  Created by 荒亮祐 on 2017/05/31.
//  Copyright © 2017年 sptm6759. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMobileAds

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var myLocationManager: CLLocationManager!

    var mapAddresses: [String?] = []
    var locationsX:[CLLocation] = []
    var sourceLocations:[CLLocationCoordinate2D] = []
    var destinationLocations: [CLLocationCoordinate2D] = []
    var sourcePlaceMarks:[MKPlacemark] = []
    var destinationPlaceMarks:[MKPlacemark] = []
    
    var inputAddressCounter = Int()
    var searchButton = UIButton()

    //let request = MKDirections.Request()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        textInput()
        //tableViewに戻るボタン
        searchButton.frame = CGRect(x: self.view.frame.width / 2 - 40, y: 100, width: 80, height: 30)
        searchButton.setTitle("経路検索", for: UIControl.State())
        searchButton.setTitleColor(.white, for: UIControl.State())
        searchButton.backgroundColor = .red
        searchButton.layer.cornerRadius = 0.0
        searchButton.addTarget(self, action: #selector(self.getRoutes(sender:)), for: .touchUpInside)
        searchButton.showsTouchWhenHighlighted = true
        self.view.addSubview(searchButton)
        print("確認　\(mapAddresses)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager error")
    }
    
    func textInput() {
        self.inputAddressCounter = self.mapAddresses.count
        for i in 0 ..< self.inputAddressCounter {
            if (mapAddresses[i] == nil) || (mapAddresses[i] == "") {
                print("continueでスキップした")
                continue
            } else {
                print("スキップしなかった")
                let myGeocoder:CLGeocoder = CLGeocoder()
                myGeocoder.geocodeAddressString(mapAddresses[i]!, completionHandler: {(placemarks, error) in
                    if(error == nil) {
                        for placemark in placemarks! {
                            let location:CLLocation = placemark.location!
                            
                            if i == 0 {
                                let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                                let span = MKCoordinateSpan.init(latitudeDelta: 0.001, longitudeDelta: 0.001)
                                let region = MKCoordinateRegion.init(center: center, span: span)
                                self.mapView.setRegion(region, animated: true)
                            }
                            let annotation = SpeMKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                            self.locationsX.append(placemark.location!)
                            annotation.title = String(i + 1) + self.mapAddresses[i]!
                            annotation.pinColor = annotation.pinColors[i]
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                })
            }
        }
    }
    
    @objc func getRoutes(sender: AnyObject) {
        for i in 0..<self.inputAddressCounter - 1  {
            if mapAddresses[i] == "" {
                continue
            }
            self.sourceLocations.append(CLLocationCoordinate2D(latitude:self.locationsX[i].coordinate.latitude, longitude: self.locationsX[i].coordinate.longitude))
            self.destinationLocations.append(CLLocationCoordinate2D(latitude:self.locationsX[i + 1].coordinate.latitude, longitude: self.locationsX[i + 1].coordinate.longitude))
            self.sourcePlaceMarks.append(MKPlacemark(coordinate: sourceLocations[i]))
            self.destinationPlaceMarks.append(MKPlacemark(coordinate: destinationLocations[i]))
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlaceMarks[i])
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMarks[i])
            directionRequest.transportType = .automobile
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let directionResonse = response else {
                    if let error = error {
                        print("we have error getting directions==\(error.localizedDescription)")
                    }
                    return
                }
                let route = directionResonse.routes[0]
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        print(self.locationsX)
        return renderer
    }
    
    //アノテーションビューを返すメソッド
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //アノテーションビューを生成する。
        let SoreDokoPinView = MKPinAnnotationView()
        //アノテーションビューに座標、タイトル、サブタイトルを設定する。
        SoreDokoPinView.annotation = annotation
        //アノテーションビューに色を設定する。
        if let test = annotation as? SpeMKPointAnnotation {
            SoreDokoPinView.pinTintColor = test.pinColor
            
        }
        //吹き出しの表示をONにする。
        SoreDokoPinView.canShowCallout = true
        return SoreDokoPinView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

/*
 
 var latitude: Double = Double()
 var longitude: Double = Double()
 
 
 var annotationFirst: CLLocationCoordinate2D!
 var annotationSecond: CLLocationCoordinate2D!
 var annotationThird: CLLocationCoordinate2D!
 var annotationForth: CLLocationCoordinate2D!
 var annotationFifth: CLLocationCoordinate2D!
 
 var locationFirst: CLLocation!
 var locationSecond: CLLocation!
 var locationThird: CLLocation!
 var locationForth: CLLocation!
 var locationFifth: CLLocation!
 
 
 
 var mapAddress1:String!
 var mapAddress2:String!
 var mapAddress3:String!
 var mapAddress4:String!
 var mapAddress5:String!
 
 var Placemarks:[MKPlacemark] = []
 var locations:[CLLocationCoordinate2D] = []
 var mapItems:[MKMapItem] = []
 
 
 var sourceLocation1: CLLocationCoordinate2D!
 var sourceLocation2: CLLocationCoordinate2D!
 var sourceLocation3: CLLocationCoordinate2D!
 var sourceLocation4: CLLocationCoordinate2D!
 var sourceLocation5: CLLocationCoordinate2D!
 
 var destinationLocation1: CLLocationCoordinate2D!
 var destinationLocation2: CLLocationCoordinate2D!
 var destinationLocation3: CLLocationCoordinate2D!
 var destinationLocation4: CLLocationCoordinate2D!
 var destinationLocation5: CLLocationCoordinate2D!
 
 var placeMark1: MKPlacemark!
 var placeMark2: MKPlacemark!
 var placeMark3: MKPlacemark!
 var placeMark4: MKPlacemark!
 var placeMark5: MKPlacemark!
 
 var sourcePlaceMark1: MKPlacemark!
 var sourcePlaceMark2: MKPlacemark!
 var sourcePlaceMark3: MKPlacemark!
 var sourcePlaceMark4: MKPlacemark!
 var sourcePlaceMark5: MKPlacemark!
 
 var destinationPlaceMark1: MKPlacemark!
 var destinationPlaceMark2: MKPlacemark!
 var destinationPlaceMark3: MKPlacemark!
 var destinationPlaceMark4: MKPlacemark!
 var destinationPlaceMark5: MKPlacemark!
 
 
 func textInput1() {
 let myGeocoder:CLGeocoder = CLGeocoder()
 let searchStr = mapAddress1
 myGeocoder.geocodeAddressString(searchStr!, completionHandler: {(placemarks, error) in
 if(error == nil) {
 for placemark in placemarks! {
 let location:CLLocation = placemark.location!
 let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
 let span = MKCoordinateSpan.init(latitudeDelta: 0.001, longitudeDelta: 0.001)
 let region = MKCoordinateRegion.init(center: center, span: span)
 self.mapView.setRegion(region, animated: true)
 let annotation = SpeMKPointAnnotation()
 annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
 self.locationFirst = placemark.location
 annotation.title = "①" + self.mapAddress1
 annotation.pinColor = UIColor.orange
 self.mapView.addAnnotation(annotation)
 }
 }
 })
 }
 func textInput2() {
 let myGeocoder:CLGeocoder = CLGeocoder()
 let searchStr2 = mapAddress2
 myGeocoder.geocodeAddressString(searchStr2!, completionHandler: {(placemarkds, error) in
 if(error == nil) {
 for placemark in placemarkds! {
 let location:CLLocation = placemark.location!
 let annotation = SpeMKPointAnnotation()
 annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
 self.locationSecond = placemark.location
 annotation.pinColor = UIColor.blue
 annotation.title = "②" + self.mapAddress2
 self.mapView.addAnnotation(annotation)
 }
 }
 })
 }
 
 func textInput3() {
 let myGeocoder:CLGeocoder = CLGeocoder()
 let searchStr = mapAddress3
 myGeocoder.geocodeAddressString(searchStr!, completionHandler: {(placemarkds, error) in
 if(error == nil) {
 for placemark in placemarkds! {
 let location:CLLocation = placemark.location!
 let annotation = SpeMKPointAnnotation()
 annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
 self.locationThird = placemark.location
 annotation.title = "③" + self.mapAddress3
 annotation.pinColor = UIColor.red
 self.mapView.addAnnotation(annotation)
 }
 }
 })
 }
 
 func textInput4() {
 let myGeocoder:CLGeocoder = CLGeocoder()
 let searchStr = mapAddress4
 myGeocoder.geocodeAddressString(searchStr!, completionHandler: {(placemarkds, error) in
 if(error == nil) {
 for placemark in placemarkds! {
 let location:CLLocation = placemark.location!
 let annotation = SpeMKPointAnnotation()
 annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
 self.locationForth = placemark.location
 annotation.title = "④" + self.mapAddress4
 annotation.pinColor =  .purple
 self.mapView.addAnnotation(annotation)
 }
 }
 })
 }
 
 func textInput5() {
 let myGeocoder:CLGeocoder = CLGeocoder()
 let searchStr = mapAddress5
 myGeocoder.geocodeAddressString(searchStr!, completionHandler: {(placemarkds, error) in
 if(error == nil) {
 for placemark in placemarkds! {
 let location:CLLocation = placemark.location!
 let annotation = SpeMKPointAnnotation()
 annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
 self.locationFifth = placemark.location
 annotation.title = "⑤" + self.mapAddress5
 annotation.pinColor = UIColor.green
 self.mapView.addAnnotation(annotation)
 }
 }
 })
 }
 
 @objc func getRoute(sender: AnyObject) {
 self.sourceLocation1 = CLLocationCoordinate2D(latitude:self.locationFirst.coordinate.latitude, longitude: self.locationFirst.coordinate.longitude)
 self.destinationLocation1 = CLLocationCoordinate2D(latitude:self.locationSecond.coordinate.latitude, longitude: self.locationSecond.coordinate.longitude)
 self.sourcePlaceMark1 = MKPlacemark(coordinate: sourceLocation1)
 self.destinationPlaceMark1 = MKPlacemark(coordinate: destinationLocation1)
 let directionRequest = MKDirections.Request()
 directionRequest.source = MKMapItem(placemark: sourcePlaceMark1)
 directionRequest.destination = MKMapItem(placemark: destinationPlaceMark1)
 directionRequest.transportType = .automobile
 let directions = MKDirections(request: directionRequest)
 directions.calculate { (response, error) in
 guard let directionResonse = response else {
 if let error = error {
 print("we have error getting directions==\(error.localizedDescription)")
 }
 return
 }
 let route = directionResonse.routes[0]
 self.mapView.addOverlay(route.polyline, level: .aboveRoads)
 let rect = route.polyline.boundingMapRect
 self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
 }
 }
 
 
 */