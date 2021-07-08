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
    var viewModel: MapViewModelProtocol!
    
    private var isLocationUpdatesEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        bind()
    }
    
    @IBAction func onListTap(_ sender: Any) {
        viewModel.showList()
    }
    
    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.deviceLocation.lat, longitude: viewModel.deviceLocation.long, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.mapView = mapView
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
    }
    
    private func bind() {
        viewModel.onPlacesUpdate = { [weak self] places in
            self?.updateMarkers(places: places)
        }
        viewModel.onDeviceLocationUpdate = { [weak self] location in
            let loc = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
            let update = GMSCameraUpdate.setTarget(loc)
            self?.mapView.moveCamera(update)
        }
    }
    
    func updateMarkers(places: [Place]) {
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

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard isLocationUpdatesEnabled else {
            isLocationUpdatesEnabled = true
            return
        }
        viewModel.update(location: Location(long: position.target.longitude, lat: position.target.latitude))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let place = marker.userData as? Place else {
            return false
        }
        viewModel.select(place: place)
        return true
    }
}
