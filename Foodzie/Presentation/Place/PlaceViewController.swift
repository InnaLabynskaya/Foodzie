//
//  PlaceViewController.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import UIKit

class PlaceViewController: UIViewController {
    var viewModel: PlaceViewModelProtocol!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeType: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func bind() {
        viewModel.onPlaceUpdate = { [weak self] place in
            self?.update(place: place)
        }
    }
    
    private func update(place: Place) {
        placeName.text = place.name
        placeType.text = place.type
        placeAddress.text = place.address
    }
}
