//
//  PlaceCell.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import UIKit

class PlaceCell: UITableViewCell, ReuseIdentifiable {
    @IBOutlet weak var titleLabel: UILabel!

    func update(with place: Place) {
        titleLabel.text = place.placeName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
