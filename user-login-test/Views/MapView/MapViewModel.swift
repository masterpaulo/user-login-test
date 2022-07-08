//
//  MapViewModel.swift
//  user-login-test
//
//  Created by John Paulo on 7/8/22.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

class MapViewModel {
    
    let user: User
    
    var currentLocation: CLLocation? {
        didSet {
            _currentLocation.accept(currentLocation)
        }
    }
    var targetLocation: CLLocation? {
        didSet {
            _targetLocation.accept(targetLocation)
        }
    }
    
    let _currentLocation = BehaviorRelay<CLLocation?>(value: nil)
    let _targetLocation = BehaviorRelay<CLLocation?>(value: nil)
    
    
    // MARK: - init
    
    init(user: User) {
        self.user = user
        
        
        if let lat = Double(user.address.coordinates.lat), let lng = Double(user.address.coordinates.lat) {
            self.targetLocation = CLLocation(latitude: lat, longitude: lng)
            _targetLocation.accept(self.targetLocation)
        }
    }
    
    
    // MARK: - Display Properties
    
    var distanceInKilometers: Observable<Double?> {
        return Observable.combineLatest(_currentLocation, _targetLocation) { currentLocation, targetLocation in
            guard let currentLocation = currentLocation, let targetLocation = targetLocation else {
                return nil
            }
            let distanceInMeters = currentLocation.distance(from: targetLocation)
            return distanceInMeters / 1000.0
        }
    }
    
    var userDisplayTitle: String {
        user.name
    }
    
}
