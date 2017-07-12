//
//  ViewController.swift
//  taipei-app
//
//  Created by Shao-Ping Lee on 4/28/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import Mapbox
import PromiseKit
import PMKAlamofire
import SwiftyJSON

class ViewController: UIViewController {
    var mapFinishedLoading = false
    
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    var initialUserLocation: MGLUserLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        searchView.alpha = 0.0
    }
    
    func addAnnotations(location: String?, radius: String?, limit: String?) {
        API.request(endpoint: .cafes(location, radius, limit))
            .responseJSON()
            .then { JSON($0) }
            .then { json in
                self.processGeoJSON(json: json)
            }.then { cafes in
                cafes.map({CafeAnnotation(withCafe: $0)})
            }.then { annotations in
                annotations.forEach({self.mapView.addAnnotation($0)})
            }.catch { error in
                print(error)
        }
    }
    
    func addAnnotationByBounds(sw: String?, ne: String?) {
        API.request(endpoint: .bounds(sw, ne))
            .responseJSON()
            .then { JSON($0) }
            .then { json in
                self.processGeoJSON(json: json)
            }.then { cafes in
                cafes.map({CafeAnnotation(withCafe: $0)})
            }.then { annotations in
                annotations.forEach({self.mapView.addAnnotation($0)})
            }.catch { error in
                print(error)
        }
    }
    
    func processGeoJSON(json: JSON) -> [Cafe] {
        let features: JSON = json["features"]
        return features.arrayValue.map({Cafe(fromJSON: $0)})
    }
    
    func searchByBounds() {
        guard mapFinishedLoading else { return }
        
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        
        let bounds = mapView.visibleCoordinateBounds
        let swString: String = "@\(bounds.sw.latitude),\(bounds.sw.longitude)"
        let neString: String = "@\(bounds.ne.latitude),\(bounds.ne.longitude)"
        
        addAnnotationByBounds(sw: swString, ne: neString)
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        guard let userLocation = mapView.userLocation else { return }
        
        mapView.setCenter(userLocation.coordinate, zoomLevel: 14, animated: true)
        searchByBounds()
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.searchView.alpha = 0.0
        }
        searchByBounds()
    }
}

extension ViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        let reuseIdentifier = "basic"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
            annotationView?.layer.borderWidth = 4.0
            annotationView?.layer.borderColor = UIColor.white.cgColor
            annotationView!.backgroundColor = UIColor(red:0.03, green:0.80, blue:0.69, alpha:1.0)
        }
        
        registerForPreviewing(with: self, sourceView: annotationView!)
        return annotationView
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if initialUserLocation == nil {
            guard let userLocation = userLocation else { return }
            initialUserLocation = userLocation
            
            mapView.setCenter(userLocation.coordinate, zoomLevel: 14, animated: true)
        }
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        
        mapView.deselectAnnotation(annotation, animated: false)
        
        guard let controller = viewControllerForAnnotation(annotation: annotation) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        guard mapFinishedLoading else { return }
        
        UIView.animate(withDuration: 1.0) { [unowned self] in
            self.searchView.alpha = 1.0
        }
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MGLMapView) {
        mapFinishedLoading = false
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapFinishedLoading = true
        searchByBounds()
    }
}

extension ViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        if let navController = viewControllerToCommit as? UINavigationController,
            let rootViewController = navController.viewControllers.first {
            navigationController?.pushViewController(rootViewController, animated: true)
        } else {
            navigationController?.pushViewController(viewControllerToCommit, animated: true)
        }
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let annotationView = previewingContext.sourceView as? MGLAnnotationView else {
             return nil
        }
        
        guard let annotation = annotationView.annotation else {
             return nil
        }
        
        guard let controller = viewControllerForAnnotation(annotation: annotation) else {
            return nil
        }
        
        controller.preferredContentSize = CGSize(width: 0, height: 224)
        let navController = UINavigationController(rootViewController: controller)
        
        return navController
    }
    
    func viewControllerForAnnotation(annotation: MGLAnnotation) -> CafeDetailViewController? {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CafeDetailViewController") as! CafeDetailViewController
        guard let annotation = annotation as? CafeAnnotation else { return nil }
        controller.annotation = annotation
        return controller
    }
}
