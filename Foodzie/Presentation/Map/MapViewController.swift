//
//  MapViewController.swift
//  Foodzie
//
//  Created by Inna Kuts on 06.07.2021.
//

import Foundation
import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    var viewModelInput: MapViewModelInputProtocol!
    var viewModelOutput: MapViewModelOutputProtocol!
    
    private var isLocationUpdatesEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        bind()
    }
}

// MARK: - Actions
extension MapViewController {
    @IBAction func onListTap(_ sender: Any) {
        viewModelInput.showList()
    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard isLocationUpdatesEnabled else {
            isLocationUpdatesEnabled = true
            return
        }
        viewModelInput.update(location: Location(long: position.target.longitude, lat: position.target.latitude))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let place = marker.userData as? Place else {
            return false
        }
        viewModelInput.select(place: place)
        return true
    }
}

// MARK: - Private
extension MapViewController {
    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: viewModelOutput.deviceLocation.lat, longitude: viewModelOutput.deviceLocation.long, zoom: Constants.mapZoom)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.mapView = mapView
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
    }
    
    private func bind() {
        viewModelOutput.onPlacesUpdate = { [weak self] places in
            self?.updateMarkers(places: places)
        }
        viewModelOutput.onDeviceLocationUpdate = { [weak self] location in
            let loc = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            let update = GMSCameraUpdate.setTarget(loc)
            self?.mapView.moveCamera(update)
        }
    }
    
    private func updateMarkers(places: [Place]) {
        mapView.clear()
        let markers = places.map { place -> GMSMarker in
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.location.lat, longitude: place.location.long))
            marker.userData = place
            return marker
        }
        markers.forEach {
            $0.map = mapView
        }
    }
}

// MARK: - Constants
extension MapViewController {
    enum Constants {
        static let mapZoom: Float = 14.0
    }
}
