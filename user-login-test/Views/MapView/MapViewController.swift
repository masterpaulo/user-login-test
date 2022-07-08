//
//  MapViewController.swift
//  user-login-test
//
//  Created by John Paulo on 7/8/22.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var vm: MapViewModel!
    
    lazy private var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    let bag = DisposeBag()
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var distanceInfoContainerView: UIView!
    @IBOutlet weak var distanceInfoLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLocationManager()
    }
    
    
    // MARK: - Setup
    
    func setup() {
        mapView.delegate = self
        mapView.showsUserLocation = false
        
        setupUserPin()
        zoomInToUserLocation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupUserPin() {
        guard let location = vm.targetLocation else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = vm.userDisplayTitle
        mapView.addAnnotation(annotation)
    }
    
    func setupCurrentLocationPin(to location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "You"
        mapView.addAnnotation(annotation)
        
        vm.currentLocation = location
    }
    
    // MARK: - Methods
    
    func zoomInToUserLocation() {
        guard let coordinate = vm.targetLocation?.coordinate else { return }
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    func zoomInToCurrentLocation() {
        guard let coordinate = vm.currentLocation?.coordinate else { return }
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    func zoomToDefault() {
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - Bind View Model

extension MapViewController {
    func bindViewModel() {
        vm.distanceInKilometers
            .map({ $0 == nil })
            .bind(to: distanceInfoContainerView.rx.isHidden)
            .disposed(by: bag)
        
        vm.distanceInKilometers
            .map({ String(format: "%.2fkm", $0 ?? 0.0) })
            .bind(to: distanceInfoLabel.rx.text)
            .disposed(by: bag)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        setupCurrentLocationPin(to: location)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.zoomToDefault()
        }
        locationManager.stopUpdatingLocation()
    }
}
    
