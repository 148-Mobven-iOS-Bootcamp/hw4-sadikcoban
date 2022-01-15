//
//  MapViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationPermission()
        addLongGestureRecognizer()
    }
    
    func addLongGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPressGesture(_ :)))
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Pinned"
        mapView.addAnnotation(annotation)
    }
    
    func checkLocationPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.requestLocation()
        case .denied, .restricted:
            //popup gosterecegiz. go to settings butonuna basildiginda
            //kullaniciyi uygulamamizin settings sayfasina gonder
            let alertOKAction=UIAlertAction(title: "Go to Settings", style: .default,  handler: { (action: UIAlertAction!) in
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            let alertCancelAction = UIAlertAction(title: "CANCEL", style: .default,handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)

            })
            alert(message: "Location permission is required",okAction: alertOKAction,cancelAction: alertCancelAction)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    
    @IBAction func showCurrentLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        print("latitude: \(coordinate.latitude)")
        print("longitude: \(coordinate.longitude)")
        
        mapView.setCenter(coordinate, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController {
    func alert(message: String, title: String = "", okAction: UIAlertAction, cancelAction: UIAlertAction) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
