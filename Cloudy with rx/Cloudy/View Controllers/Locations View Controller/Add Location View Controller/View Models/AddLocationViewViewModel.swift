//
//  AddLocationViewViewModel.swift
//  Cloudy
//
//  Created by Bart Jacobs on 17/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation
import CoreLocation

class AddLocationViewViewModel {

    // MARK: - Properties

    var querying: Driver<Bool> { return _querying.asDriver() }
    var locations: Driver<[Location]> { return _locations.asDriver() }

    // MARK: -

    var hasLocations: Bool { return numberOfLocations > 0 }
    var numberOfLocations: Int { return _locations.value.count }

    // MARK: -

    private let _querying = BehaviorRelay<Bool>(value: false)
    private let _locations = BehaviorRelay<[Location]>(value: [])

    // MARK: -

    var queryingDidChange: ((Bool) -> ())?
    var locationsDidChange: (([Location]) -> ())?

    // MARK: -

    private lazy var geocoder = CLGeocoder()

    // MARK: -

    private let disposeBag = DisposeBag()

    // MARK: - Initializtion

    init(query: Driver<String>) {
        query
            .throttle(0.5)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (addressString) in
                self?.geocode(addressString: addressString)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public Interface

    func location(at index: Int) -> Location? {
        guard index < _locations.value.count else { return nil }
        return _locations.value[index]
    }

    func viewModelForLocation(at index: Int) -> LocationRepresentable? {
        guard let location = location(at: index) else { return nil }
        return LocationsViewLocationViewModel(location: location.location, locationAsString: location.name)
    }

    // MARK: - Helper Methods

    private func geocode(addressString: String?) {
        guard let addressString = addressString, !addressString.isEmpty else {
            _locations.accept([])
            return
        }

        _querying.accept(true)

        // Geocode Address String
        geocoder.geocodeAddressString(addressString) { [weak self] (placemarks, error) in
            var locations: [Location] = []

            self?._querying.accept(false)

            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")

            } else if let _placemarks = placemarks {
                locations = _placemarks.flatMap({ (placemark) -> Location? in
                    guard let name = placemark.name else { return nil }
                    guard let location = placemark.location else { return nil }
                    return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                })
            }

            self?._locations.accept(locations)
        }
    }

}
