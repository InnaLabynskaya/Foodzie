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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        bind()
    }
    
    @IBAction func onListTap(_ sender: Any) {
        viewModel.showList()
    }
    
    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 14.0)
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
