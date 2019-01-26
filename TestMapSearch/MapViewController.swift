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
    
    let imageHere = UIImage(named: "here")!
    let imageRoute = UIImage(named: "route")!

    //let request = MKDirections.Request()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        textInput()
        //tableViewに戻るボタン
        searchButton.frame = CGRect(x: self.view.frame.width - 70, y: self.view.frame.height - 70, width: 50, height: 50)
        searchButton.setImage(imageRoute, for: .normal)
        searchButton.layer.shadowOpacity = 0.5
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        //searchButton.setTitle("経路検索", for: UIControl.State())
        //searchButton.setTitleColor(.white, for: UIControl.State())
        //searchButton.backgroundColor = .red
        //searchButton.layer.cornerRadius = 0.0
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

