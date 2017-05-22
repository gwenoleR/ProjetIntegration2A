//
//  MapViewController.swift
//  JO 2017
//
//  Created by Gwenolé on 16/05/2017.
//  Copyright © 2017 Gwenolé. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire


struct PreferencesKeys {
    static let savedItems = "savedItems"
}

//MARK: Search Protocol
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var geotifications: [Geotification] = []
    var locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController!
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        
        //MARK: Search Bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        loadAllGeotifications()
        
        mapView.zoomToUserLocation()

        
        Alamofire.request("http://gps.soc.catala.ovh/getAllPoi", method: .get, encoding: JSONEncoding.default)
            .validate().responseJSON{ response in
                
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        print("JSON: \(result)")
                        
                        let json = JSON(result)
                        
                        let points = json["poi"]
                        
                        
                        for point in points{
                            
                            let coordinateFromData = point.1["coordinate"].arrayValue
                            let lat = coordinateFromData.map({$0["latitude"].doubleValue})[0]
                            let long = coordinateFromData.map({$0["longitude"].doubleValue})[1]
                            
                            
                            let coord = CLLocationCoordinate2D(latitude:CLLocationDegrees(lat), longitude:CLLocationDegrees(long))
                            
                            let radius =  CLLocationDistance(point.1["radius"].doubleValue)
                            
                            let id = point.1["_id"].stringValue//NSUUID().uuidString
                            
                            let note = point.1["note"].stringValue
                            
                            let event = point.1["eventType"].stringValue
                            
                            
                            let geo = Geotification(coordinate: coord, radius: radius, identifier: id, note: note, eventType: EventType(rawValue: event)!)
                            self.add(geotification: geo)
                            self.startMonitoring(geotification: geo)
                            self.saveAllGeotifications()
                        }
                        
                    }
                case .failure:
                    print("Failed to get POI")
                }
        }
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //    if segue.identifier == "addGeotification" {
        //      let navigationController = segue.destination as! UINavigationController
        //      let vc = navigationController.viewControllers.first as! AddGeotificationViewController
        //      vc.delegate = self
        //    }
    }
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        geotifications = []
        guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
        for savedItem in savedItems {
            guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification else { continue }
            add(geotification: geotification)
        }
    }
    
    func saveAllGeotifications() {
        var items: [Data] = []
        for geotification in geotifications {
            let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(geotification: Geotification) {
        for g in geotifications{
            if g.isEqual(at: geotification){
                return
            }
        }
        geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        //addRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func remove(geotification: Geotification) {
        if let indexInArray = geotifications.index(of: geotification) {
            geotifications.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geotification)
        removeRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func updateGeotificationsCount() {
        title = "Carte (\(geotifications.count))"
        navigationItem.rightBarButtonItem?.isEnabled = (geotifications.count < 20)
    }
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlay(forGeotification geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    // MARK: Other mapview functions
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        mapView.zoomToUserLocation()
    }
    
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

// MARK: AddGeotificationViewControllerDelegate
//extension GeotificationsViewController: AddGeotificationsViewControllerDelegate {
//
//  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
//    controller.dismiss(animated: true, completion: nil)
//    // 1
//    let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
//    let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
//    add(geotification: geotification)
//    // 2
//    startMonitoring(geotification: geotification)
//    saveAllGeotifications()
//  }
//
//}

//MARK: Search Delegate
extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        for anno in mapView.annotations{
            if anno is SearchAnnotation{
                mapView.removeAnnotation(anno)
            }
        }
        //mapView.removeAnnotation(mapView.annotations.last!)
        
        let annotation = SearchAnnotation(coordinate: placemark.coordinate, name: "search")
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = status == .authorizedAlways
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier) error : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
}

// MARK: - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeotification"
        if annotation is Geotification {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "DeleteGeotification")!, for: .normal)
                
                if let annotationView = annotationView{
                    annotationView.leftCalloutAccessoryView = removeButton
                    annotationView.image = UIImage(named: "stadium")
                }
               
            }
            
            else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        else if annotation is SearchAnnotation{
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.tintColor = UIColor.blue
            annotationView?.canShowCallout = true
            
            let goButton = UIButton(type: .custom)
            goButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
            goButton.setImage(UIImage(named: "CurrentLocation")!, for: .normal)
            goButton.addTarget(self, action: #selector(MapViewController.getDirections), for: .touchUpInside)
            
            annotationView?.leftCalloutAccessoryView = goButton
            
            return annotationView
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        if view.annotation is Geotification{
            let geotification = view.annotation as! Geotification
            remove(geotification: geotification)
            saveAllGeotifications()
        }
        
    }
    
}

