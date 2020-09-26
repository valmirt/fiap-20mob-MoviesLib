//
//  MapViewController.swift
//  MoviesLib
//
//  Created by Valmir Junior on 26/09/20.
//
import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    // MARK: - Properties
    lazy var locationManager = CLLocationManager()
    
    // MARK: - IBOutlets
    @IBOutlet weak var sbMap: UISearchBar!
    @IBOutlet weak var mainMap: MKMapView!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestAuthorization()
    }
    
    // MARK: - Methods
    private func setupView() {
        mainMap.mapType = .standard
        mainMap.showsUserLocation = true
        mainMap.userTrackingMode = .follow
        mainMap.delegate = self
        sbMap.delegate = self
    }
    
    private func requestAuthorization() {
        
//        Saber se o usuário desligou o gps
//        CLLocationManager.locationServicesEnabled()
        
//        Saber se o usário já autorizou
//        CLLocationManager.authorizationStatus()
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - IBActions
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.lineWidth = 7.0
        render.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return render
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            let camera = MKMapCamera()
            camera.centerCoordinate = coordinate
            camera.pitch = 80
            camera.altitude = 100
            mainMap.setCamera(camera, animated: true)
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                if let response = response, let route = response.routes.sorted(by: { $0.distance < $1.distance }).first {
                    for step in route.steps {
                        print("Em", step.distance, "metros", step.instructions)
                    }
                    
                    self.mainMap.removeOverlays(self.mainMap.overlays)
                    self.mainMap.addOverlay(route.polyline, level: .aboveRoads)
                }
            }
        }
    }
}


extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let request = MKLocalSearch.Request()
        request.region = mainMap.region
        request.naturalLanguageQuery = searchBar.text
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if let response = response {
                self.mainMap.removeAnnotations(self.mainMap.annotations)
                
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    self.mainMap.addAnnotation(annotation)
                }
                
                self.mainMap.showAnnotations(self.mainMap.annotations, animated: true)
            }
        }
    }
}

